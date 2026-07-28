---
name: gatekeeper
description: Careful review gate that runs tests/linters, critically reviews the diff, and loops back to fix rather than stop-and-report. Use right before declaring a non-trivial task done.
---

# gatekeeper

- Trigger: right before declaring a non-trivial task done. Run every section below, in order, before saying so.

`<step_1_confirm_checks>`
- Run relevant tests/linters when the project has them; report what ran and the result.
- Tests missing for non-trivial new logic? Use `guinea-pig` (`/guinea-pig`) to write them rather than skipping to done.
`</step_1_confirm_checks>`

`<step_2_review_diff>`
- Read every changed line. Check logic, edge cases, and error handling, not just "does it run."
- Re-check against the original request/plan: nothing missed, nothing unrelated changed.
- Check for unrequested abstractions, dead/defensive code, or test-specific hardcoding introduced during Build (see `avoid_overengineering`, `avoid_hardcoding`).
- Grep for any `[DEBUG-...]` tags left by `sleuth` (must be empty) and check for other dead code or TODOs.
- Confirm no workflow rule was violated.
`</step_2_review_diff>`

`<step_3_loop_until_pass>`
- Surface everything you notice, including issues you're unsure about or consider minor. Don't self-filter for importance or confidence; the user is the downstream filter that decides what matters.
- Found a real problem (bug, missed requirement, failing test, rule violation)? Report it to the user before fixing; never retry on your own.
- Consult the user on every loop, not just after repeated failures. Stricter than `when_stuck`, to avoid unsupervised fix-and-recheck cycles.
- Once the user agrees with the fix direction, go back to Build/Verify, fix it, and re-review from step 1.
- Only a clean pass (tests green, diff reviewed, nothing outstanding) counts as approved. A partial pass is not "done."
- Genuinely ambiguous or a trade-off, not a clear defect? Ask instead of guessing (see `decisions`).
`</step_3_loop_until_pass>`

`<examples>`
`<example>`Good: diff review finds a missing null check. Stop, report it, wait for direction, then fix and re-review from the top.`</example>`
`<example>`Good: task touched a file that wasn't part of the original request. Flag it as scope creep before approving, even if the change itself looks fine.`</example>`
`<example>`Bad: silently patching a found bug and re-running tests without telling the user first.`</example>`
`</examples>`
