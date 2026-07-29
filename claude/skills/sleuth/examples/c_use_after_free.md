# C: Use-After-Free

## Scenario
A linked-list-backed job queue occasionally processes a job with garbage field values, or crashes, but not consistently and not always on the same job. Classic symptom of memory corruption rather than a straightforward null deref.

## Evidence
A bare crash log is useless here since the corruption happens before the eventual crash, potentially far from its cause:
```
$ ./job_queue
job 42: status=207, retries=-1837483920   <- garbage, should be 0-3
Segmentation fault (core dumped)
```
Rebuilt with AddressSanitizer (`-fsanitize=address -g`) to get a precise report instead of guessing from the bare crash:
```
==12345==ERROR: AddressSanitizer: heap-use-after-free on address 0x602000000010
READ of size 4 at 0x602000000010 thread T0
    #0 job_queue_process (queue.c:88)
freed by thread T0 here:
    #1 job_queue_remove (queue.c:54)
```

## Reproduction
Removing a job from the queue and then immediately processing the next tick reproduces it every time under ASan; without ASan it's intermittent because it depends on whether the freed memory has been reused/overwritten yet.

## Failing test
Before forming any hypotheses, wrote an ASan-instrumented test (`test_queue.c`) that removes a job then runs another process tick. It reliably flags a heap-use-after-free under ASan, giving a concrete pass/fail signal for the rest of the investigation instead of relying on the flaky un-instrumented crash.

## Hypotheses (ranked)
1. `job_queue_remove()` frees a `Job*` but a stale copy of that pointer is still sitting in a "recently removed" cache array, and a later tick dereferences it. *Prediction: ASan's freed-by trace points at `job_queue_remove`, and the read happens from a different array than the main queue.*
2. Two threads both call `job_queue_remove` on the same job (double free / race). *Prediction: reproduces only under concurrent load, not single-threaded.*
3. `job_queue_process` has an off-by-one that reads one slot past the live queue into already-freed memory. *Prediction: the freed pointer and the read pointer are adjacent queue slots, not the same object.*

## Isolation
ASan's report already names the exact free (`queue.c:54`) and the exact later read (`queue.c:88`) on the *same address*, which alone confirms it's the same object being reused after free, not an adjacent-slot overrun (rules out 3). The repro is single-threaded, ruling out 2. Reading `queue.c:54` showed the recently-removed cache array retaining the pointer without clearing it, confirming hypothesis 1.

## Root cause
`job_queue_remove()` frees the job and removes it from the live queue, but a separate "recently removed" ring buffer (used for retry-logging) still held the same raw pointer, which `job_queue_process` later dereferenced on its next pass.

## Check in with user
Reported the root cause and two possible fixes ((a) store `job->id` instead of the pointer in the retry log, or (b) keep the pointer but clear it and add a null-check before use) before touching code, since (b) leaves the door open for the same class of bug elsewhere while (a) removes the raw pointer from that log entirely. Got confirmation to go with (a).

## Fix
```c
void job_queue_remove(Job *job) {
    remove_from_queue(job);
    recently_removed_log(job->id); // log the id, not the pointer
    free(job);
}
```
Changed the recently-removed log to store `job->id` (a plain integer) instead of the `Job*`, eliminating the dangling reference entirely.

## Verification
The failing ASan test from earlier now passes cleanly with no use-after-free flagged. Confirmed no `[DEBUG-...]` tags were left (none were needed here since ASan's own trace was sufficient) before calling it done.
