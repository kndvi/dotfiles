---
name: rubber-duck
description: Debugging discipline - finding a root cause without guessing. Use when investigating a bug, crash, test failure, unexpected output, or any "why is this happening" question. Not for writing new code.
---

# Debugging

Collect the actual evidence (error messages, stack traces, logs) before proposing a cause.
If it can't be reproduced, say so. Reason from the artifacts you do have and narrow the
candidate causes and fixes with the user, since there's no repro to test against.

Check in with the user before each fix-and-retest cycle instead of looping unsupervised;
this is stricter than the general `when_stuck` threshold. A passing repro test isn't the
same as confirming real behavior: sanity-check the affected flow before calling the fix
done.

When the cause isn't obvious and the bug does reproduce, work in this order:

1. Write a test that fails on the bug, so the fix has a concrete pass/fail signal.
2. Generate 2-3 falsifiable hypotheses for the root cause, ranked by likelihood, stated as
   predictions ("if X is the cause, then Y should happen"). Don't anchor on the first
   plausible idea.
3. Isolate the root cause via bisecting or targeted logging/breakpoints, testing hypotheses
   in ranked order.
4. Tag debug logging with a unique prefix (e.g. `[DEBUG-a1b2]`) so it's one grep to remove
   later, and confirm that grep is empty once the repro test passes.
