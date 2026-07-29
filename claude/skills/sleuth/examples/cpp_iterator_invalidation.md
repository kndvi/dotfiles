# C++: Iterator Invalidation

## Scenario
`CacheManager::evictExpired()` is supposed to remove every expired entry from `entries_`, but some expired entries survive, and occasionally the process crashes with heap corruption under load.

## Evidence
```cpp
for (auto it = entries_.begin(); it != entries_.end(); ++it) {
    if (it->isExpired()) {
        entries_.erase(it); // erases, but `it` is now invalidated
    }
}
```
Rebuilt with AddressSanitizer to get a precise report instead of guessing from the intermittent crash:
```
==31337==ERROR: AddressSanitizer: container-overflow on address 0x602000000040
READ of size 8 at 0x602000000040 thread T0
    #0 CacheManager::evictExpired() cache_manager.cpp:24
```

## Reproduction
Populate the cache with two *consecutive* expired entries and call `evictExpired()`: the second one is always left behind (or ASan flags container-overflow), every time. A single isolated expired entry among non-expired ones evicts fine, so the bug only shows up with adjacent expired entries.

## Failing test
Before forming any hypotheses, wrote `CacheManagerTest.EvictExpired_RemovesAllConsecutiveExpiredEntries` seeding two consecutive expired entries and asserting the cache ends up empty. It fails (one entry remains) on the current code, giving a concrete pass/fail signal for the rest of the investigation.

## Hypotheses (ranked)
1. `std::vector::erase(it)` invalidates `it` (and every iterator after it), so the loop's own `++it` operates on a dangling iterator, skipping the element that shifted into its place. *Prediction: reproduces specifically when two expired entries are adjacent, since the second one shifts into the erased slot and gets skipped by the invalidated `++it`.*
2. `Entry::isExpired()` has an off-by-one in its timestamp comparison, so the second entry in a pair isn't actually flagged as expired. *Prediction: reproduces even for two non-adjacent expired entries evaluated independently.*
3. A background thread is concurrently inserting into `entries_` while eviction runs, resizing the vector mid-loop. *Prediction: only reproduces under concurrent load, not in a single-threaded unit test.*

## Isolation
Added `std::cerr << "[DEBUG-evict5] erasing idx=" << std::distance(entries_.begin(), it) << " size=" << entries_.size() << "\n";` before the `erase` call, and ran the single-threaded failing test from above under ASan.
ASan's own report already pinpoints the invalidated-iterator read at the `++it` following `erase` on `cache_manager.cpp:24`, confirming hypothesis 1 directly. The debug log showed only one erase happening for two expired entries (the second was never visited), consistent with the loop skipping past it. The repro is single-threaded with no concurrency involved, ruling out 3. Testing `isExpired()` directly against both entries' timestamps showed both correctly flagged as expired, ruling out 2.

## Root cause
`std::vector::erase` returns a valid iterator to the element that took the erased element's place, but the code discards that return value and does `++it` on the now-invalidated iterator, stepping past the very element that needs to be checked next.

## Check in with user
Reported the root cause and two fix options ((a) capture `erase`'s return value and skip the loop's own increment when an erase happens, or (b) switch to the standard erase-remove idiom (`std::remove_if` + `erase`)) before changing anything, since (b) is a broader rewrite of the method even though it's the more idiomatic/efficient fix. Got confirmation to go with (b).

## Fix
```cpp
entries_.erase(
    std::remove_if(entries_.begin(), entries_.end(),
                    [](const Entry& e) { return e.isExpired(); }),
    entries_.end());
```

## Verification
The failing test from earlier now passes: the cache ends up empty after evicting two consecutive expired entries. Ran the full suite under ASan with no container-overflow reported. Confirmed `grep -r "DEBUG-evict5"` is empty before calling it done.
