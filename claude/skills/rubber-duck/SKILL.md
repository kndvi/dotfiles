---
name: rubber-duck
description: Debugging discipline - finding a root cause without guessing. Use when investigating a bug, crash, test failure, unexpected output, or any "why is this happening" question. Not for writing new code.
---

# Debugging

Collect the actual evidence (error messages, stack traces, logs) before proposing a cause.
If it can't be reproduced, say so. Reason from the artifacts you do have and narrow the
candidate causes and fixes with the user, since there's no repro to test against.

Check in with the user before each fix-and-retest cycle instead of looping unsupervised;
this is stricter than the general `when_stuck` threshold. When asking, report symptoms, not
theories. A passing repro test isn't the same as confirming real behavior: sanity-check the
affected flow before calling the fix done.

In order:

1. Record the symptom verbatim - exact message, exit code, timestamp, command - before
   changing anything. Keep appending to that log as you go; the detail you didn't think
   mattered is the one you'll need.
2. Reproduce it on demand. Stimulate the real failure rather than simulating something like
   it, and hunt the uncontrolled condition behind anything intermittent.
3. Look before theorising. Read the trace, the log, the actual state. Guess only to decide
   where to look next.
4. Check the plug. Right binary, right branch, right config, right environment, tool actually
   working - the cheap assumptions, before any deep theory.
5. Write a test that fails on the bug, so the fix has a concrete pass/fail signal.
6. Shrink it. Cut the input and the steps until nothing more can go without the failure
   going too; that reduction usually names the cause on its own.
7. Generate 2-3 falsifiable hypotheses, ranked by likelihood, stated as predictions ("if X is
   the cause, then Y should happen"). Don't anchor on the first plausible idea.
8. Isolate by bisecting or targeted logging, testing hypotheses in ranked order and changing
   one thing at a time against a known-good comparison.
9. Fix the cause, not the symptom. Then confirm it's really fixed, and that your change is
   what fixed it - a bug that "went away" didn't.

Tag debug logging with a unique prefix (e.g. `[DEBUG-a1b2]`) so it's one grep to remove
later, and confirm that grep is empty once the repro test passes.
