# Python: Mutable Default Argument

## Scenario
`add_item_to_cart(item, cart=[])` is meant to start a fresh cart per call, but users are seeing items from other people's earlier orders showing up in their own "empty" cart.

## Evidence
Support logs show user B's cart containing user A's items, even though `add_item_to_cart` was called with no `cart` argument for both (i.e. both should have gotten a fresh empty list). No exception is raised: this is a silent data-corruption bug, not a crash, so the evidence has to come from application logs/state rather than a traceback.

## Reproduction
```python
def add_item_to_cart(item, cart=[]):
    cart.append(item)
    return cart

add_item_to_cart("apple")            # ["apple"]
add_item_to_cart("banana")           # ["apple", "banana"]  <- should be ["banana"]
```
Reproduces every time, on the second call onward: deterministic, not a race.

## Failing test
Before forming any hypotheses, wrote `test_add_item_to_cart_defaults_to_fresh_list_each_call()` asserting two successive no-arg calls don't share state. It fails on the current code (second call inherits the first item), giving a concrete pass/fail signal to check hypotheses against.

## Hypotheses (ranked)
1. Python evaluates default argument expressions once, at function-definition time, not per call, so every call that omits `cart` shares the exact same list object. *Prediction: `id(cart)` is identical across separate calls that both omit the argument.*
2. A caching layer or session store is returning the same cart object for different users. *Prediction: the bug only reproduces across requests/sessions, not within a single-process unit test.*
3. `add_item_to_cart` is being called with an explicit shared list somewhere upstream (e.g. a module-level `default_cart` passed in by mistake). *Prediction: grepping call sites shows a shared variable being passed as `cart`.*

## Isolation
Added `print(f"[DEBUG-cart4] id(cart)={id(cart)} contents={cart}")` at the top of the function and called it twice from a plain script with no session/cache involved.
Output showed the identical `id(cart)` on both calls, and the list already containing the previous call's item before `.append()` even ran, confirming hypothesis 1 immediately and ruling out 2 and 3 since no session, cache, or upstream call site was involved in this minimal repro.

## Root cause
`cart=[]` in the function signature is evaluated exactly once when the module loads, creating one list object that's reused as the default for every call that doesn't pass `cart` explicitly.

## Check in with user
Reported the root cause and the standard `cart=None` fix before applying it, since it's worth flagging that this pattern (mutable default arguments) might exist elsewhere in the codebase and could warrant a broader sweep. Got confirmation to fix this call site now and file a follow-up ticket for a codebase-wide grep, rather than expanding scope here.

## Fix
```python
def add_item_to_cart(item, cart=None):
    if cart is None:
        cart = []
    cart.append(item)
    return cart
```

## Verification
The failing test from earlier now passes: it failed on the old code (second call inherits the first item) and passes after the fix. Confirmed `grep -r "DEBUG-cart4"` is empty before calling it done.
