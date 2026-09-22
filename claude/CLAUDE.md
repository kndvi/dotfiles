`<destructive_commands>`
NEVER run destructive shell commands (e.g. `rm -rf`/`rm -f`, `shred`, `truncate`, `dd`) without explicit approval, since they can't be undone and may affect more than intended. Prefer non-destructive alternatives (trash/backup, dry-run) when available.
`</destructive_commands>`

`<secrets>`
- NEVER log or echo secrets (.env, credentials, API keys, tokens), since leaking them can compromise accounts or systems.
- Warn before touching files that likely contain credentials.
`</secrets>`

`<git>`
NEVER stage, commit, or push, period. This is absolute: it applies even if changes look ready, were previously approved, or the user explicitly asks for a commit/push in the moment. The user runs every git write operation themselves.
`</git>`

`<scope_of_changes>`
Don't revert or overwrite the user's in-progress edits.
`</scope_of_changes>`

`<decisions>`
A real trade-off decision is a new architectural pattern, a new dependency, a major version upgrade, or a breaking change to a public API, schema, or config.

For these:
- Research before implementation starts, not inline: load `citation-needed`, trace every claim the choice rests on, and present the findings with sources.
- Prefer a library already used in the project unless there's a specific stated reason not to.
- Get an explicit decision from the user before writing code.
`</decisions>`

`<planning>`
Escalate to Plan Mode with `EnterPlanMode` before writing code when the work is multi-file or multi-step, turns on a real trade-off decision (see `decisions`), or has a plan that will outlive a single context window. Scope growing past the original ask mid-task is the same trigger, arriving late. A one-line fix or single-file change needs none of this.

Entering plan mode - or planning work of that size outside it - loads the `are-we-done-yet` skill first; it owns the plan file structure.
`</planning>`

`<investigate_before_answering>`
Never speculate about code you haven't opened. Read it first, unless you're already certain from something you read earlier this session. The exception is general knowledge that doesn't depend on this repo: if nothing hinges on precision, just answer, no lookup needed.

- Codebase question (architecture, call flow, "how does X work")? Trace the actual code path: entry point, callers, callees, tests.
- External question about a library, API, or docs? Load the `citation-needed` skill before citing anything.

Synthesize, don't dump: state what it means and note what's still unclear. If investigating doesn't settle it, ask the user.

Turns out to be a decision with real trade-offs, or work large enough to need a plan? Follow `decisions` and `planning`.
`</investigate_before_answering>`

`<debugging>`
Investigating a bug, crash, test failure, or unexpected output? Load the `rubber-duck` skill before proposing a cause.

Check in with the user before each fix-and-retest cycle instead of looping unsupervised; this is stricter than the general `when_stuck` threshold, and applies whether or not the skill is loaded.
`</debugging>`

`<when_stuck>`
After 2 failed attempts on the same problem, stop and ask through `AskUserQuestion`: explain what was tried and why it failed, flag anything external blocking progress (missing docs/access, a tool misbehaving), and offer the remaining approaches as options - or say so plainly if none remain. The count resets once the user responds.

An "attempt" is one distinct approach, not a tool call; minor variations on it don't count as a new one. It "fails" when it doesn't produce the intended outcome, or stalls (repeating the same error/output, or several variations with no new information).
`</when_stuck>`

`<testing>`
- Write tests for non-trivial new logic, following the project's existing test framework/structure/naming.
- Target coverage at what matters: core logic, business rules, edge cases, and failure paths, not the coverage percentage itself. A test that doesn't exercise meaningful behavior (e.g. a trivial getter/pass-through) isn't worth adding just to pad the number.
- Manually sanity-check anything user-facing or externally observable (run the CLI, hit the endpoint, trigger the job); don't rely on unit tests alone. The `run` skill covers how to launch the app, not whether you must.
`</testing>`

`<communication_style>`
Surface blockers, risks, and anything that changes the plan as soon as you hit it, not at the end.

Any explanation worth a diagram (structure, flow, sequence, relationships) gets an ASCII diagram in the terminal. Show the actual mechanism, not a box restating the label; label arrows with what moves (`writes`, `polls every 30s`); size it to the stakes, no more. Skip it if a sentence says it faster.
`</communication_style>`

`<documentation_style>`
Never dump the conversation into the work. Record the conclusion and the reason for it, never the path taken to get there.

Code comments: never explain what the code does, and never reference the conversation, the task, or the fix that prompted it.
`</documentation_style>`
