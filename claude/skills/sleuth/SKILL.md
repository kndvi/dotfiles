---
name: sleuth
description: Systematically troubleshoot a bug, error, or unexpected behavior. Use when investigating a failure, exception, test failure, or something not working as expected, before attempting a fix.
---

# sleuth

<procedure>
- Trigger: a bug, error, exception, or failing test, before attempting any fix.
- Collect the actual evidence first: error messages, stack traces, logs. Don't theorize ahead of it.
- Reproduce the issue reliably before fixing. If it can't be reproduced, say so rather than guessing at a cause.
- Unfamiliar with the code path involved? Use `whiteboard`'s Explore mode to trace how it actually works before generating hypotheses. Don't guess your way through code you haven't read.
- Write/run a test that fails on the bug so the fix has a concrete pass/fail signal (see `guinea-pig` for structure).
- Generate 2-3 falsifiable hypotheses for the root cause before testing any of them, ranked by likelihood. Testing only the first plausible idea invites anchoring. State each as a prediction: "if X is the cause, then Y should happen."
- Isolate the root cause via bisecting or targeted logging/breakpoints, testing hypotheses in ranked order. Don't pattern-match a plausible-looking fix. Tag any debug logging with a unique prefix (e.g. `[DEBUG-a1b2]`) so removing it later is one grep, not a vibe-check.
- Check in with the user before each fix-and-retest cycle instead of looping unsupervised. Stricter than the general `when_stuck` threshold.
- Once the repro test passes, confirm the debug-tag grep is empty, then run a full verification pass (`gatekeeper`) before calling it done.
</procedure>

<examples>
<example>Good: "Worker process crashes with SIGSEGV under load." Pull the stack trace/core dump, reproduce locally, write a test that fails on the exact crash, rank a few hypotheses, bisect/instrument to test them in order, fix, confirm the test passes, then `gatekeeper`.</example>
<example>Good: "This started failing after a recent change." Bisect across recent commits to find the one that introduced it before touching any code.</example>
<example>Good: bug is in an unfamiliar auth middleware chain. Use `whiteboard` for a trace/diagram of how it currently works, then use that to generate grounded hypotheses instead of guessing.</example>
<example>Bad: seeing a `TypeError` in the logs and guessing a fix without reproducing it first.</example>
<example>Bad: instrumenting the first idea that comes to mind instead of ranking a few hypotheses first.</example>
</examples>
