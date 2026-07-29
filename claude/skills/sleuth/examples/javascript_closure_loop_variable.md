# JavaScript: Closure Over a Shared Loop Variable

## Scenario
A UI countdown is supposed to log `5, 4, 3, 2, 1` at one-second intervals but instead logs `0, 0, 0, 0, 0` (or the loop's final value, depending on the exact code), a classic `var`-in-a-loop closure bug with no exception thrown.

## Evidence
```javascript
for (var i = 5; i > 0; i--) {
  setTimeout(() => console.log(i), (5 - i) * 1000);
}
// logs: 0, 0, 0, 0, 0
```
No stack trace to work from since nothing throws: the evidence is just "the printed values are wrong," so it has to be diagnosed by inspecting variable state, not an error message.

## Reproduction
Deterministic: every run prints the same wrong sequence, ruling out a timing race in `setTimeout`'s scheduling itself.

## Failing test
Before forming any hypotheses, wrote a test using fake timers (`jest.useFakeTimers()`) asserting the logged sequence is `[5, 4, 3, 2, 1]`. It fails with `[0, 0, 0, 0, 0]` on the current code, giving a concrete pass/fail signal to check hypotheses against.

## Hypotheses (ranked)
1. `var` is function-scoped, not block-scoped, so all five callbacks close over the *same* `i` binding, and by the time any callback runs (after the loop has finished), `i` already holds its final value. *Prediction: logging `i`'s identity/reference at callback time shows all five callbacks reading the same variable, not five separate snapshots.*
2. `setTimeout` callbacks are firing out of order, so the last-scheduled one happens to run first and skews the observed sequence. *Prediction: the delays passed to `setTimeout` are wrong or non-monotonic.*
3. Something else mutates `i` between the loop and the callbacks firing (e.g. another timer or event handler touching a global `i`). *Prediction: grepping the file for other reads/writes to `i` turns up an external mutator.*

## Isolation
Added `console.log("[DEBUG-loop2] i=" + i);` inside the callback, plus logged the computed delay value at scheduling time.
Delays were correctly `0, 1000, 2000, 3000, 4000` (rules out 2; ordering was never the issue), and every callback logged the same final `i=0` regardless of which delay fired (confirms 1). No other code in the file touches `i` (rules out 3).

## Root cause
`var i` creates one binding shared by the whole loop; the closures capture that single binding by reference, not its value at each iteration, so they all observe whatever `i` is when they finally execute.

## Check in with user
Reported the root cause and two fix options (switch to `let`, or keep `var` and wrap the body in an IIFE that captures `i` by value) before applying either. Got confirmation to go with `let` since there's no reason to keep `var` here and it's the simpler change.

## Fix
```javascript
for (let i = 5; i > 0; i--) {
  setTimeout(() => console.log(i), (5 - i) * 1000);
}
// logs: 5, 4, 3, 2, 1
```
`let` creates a fresh binding per iteration, so each closure captures its own snapshot of `i`.

## Verification
The failing test from earlier now passes: it failed (`[0,0,0,0,0]`) on the `var` version and passes after switching to `let`. Confirmed `grep -r "DEBUG-loop2"` is empty before calling it done.
