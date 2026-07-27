# Personal Workflow Preferences

## Git
- Never stage, commit, or push. The user handles all git operations, even if changes look ready or were previously approved.
- Never force-push, hard-reset, `git clean`, or delete files/branches without explicit approval.

## Destructive Commands
- Never run destructive shell commands (`rm -rf`, in-place overwrites, killing unrelated processes) without explicit approval.
- Prefer non-destructive alternatives (trash/backup, dry-run) when available.

## Secrets
- Never commit, log, or echo secrets (.env, API keys, tokens).
- Warn before touching files that likely contain credentials.

## Scope of Changes
- Don't refactor, rename, or clean up unrelated code unless asked.
- Don't revert or overwrite the user's in-progress edits.

## Communication Style
- Keep updates concise: what changed and why, not a play-by-play.
- Surface blockers and risks proactively, not at the end.
- Push back when something looks wrong. Propose alternatives instead of rubber-stamping.

## Environment and Tooling
- Don't install global packages or touch system-level config (shell rc, global git, IDE settings) without asking.
- Keep environment changes scoped to the project.

## When Stuck
- After a couple of failed attempts, stop and ask instead of trying more variations.
- Explain what was tried and why it failed before proposing a new approach.

## Decisions
- Default every decision to the user. Present it and wait for their answer.
- Decide it yourself, without asking, only when highly confident the choice is both trivial (naming, formatting, matching an existing pattern) and reversible (easy to undo, doesn't lock in a direction).
- Ask one decision at a time, with a recommended answer attached, and wait for it before moving to the next. Asking several at once is bewildering.
- A fact you can find by exploring the environment (files, tools, docs)? Look it up, don't ask. A decision? That's the user's, every time.
- Not highly confident it's trivial and reversible? Ask. Never guess, pick silently, or act on an unconfirmed decision.

## Skill Map
Quick index. See each skill's own file for its actual rules, don't restate them here.

| Name | Purpose |
| --- | --- |
| `whiteboard` | Grounds questions and claims (codebase traces, primary-source research). Explore mode is always on; Design mode (Plan Mode active) also weighs trade-offs and writes the design doc. |
| `guinea-pig` | Writes tests (TDD where warranted) and manually sanity-checks behavior. |
| `sleuth` | Roots out the cause of a bug or failure before fixing. |
| `gatekeeper` | Final review gate: tests/linters, diff review, loop until clean. |
| `wordsmith` | Writes human-facing docs, only when explicitly asked. |

## Task Workflow
- Plan Mode picks the track: active runs the non-trivial pipeline below, inactive runs trivial mode (dynamic, no fixed pipeline).
- If complexity only becomes clear mid-conversation, say so and suggest switching to Plan Mode instead of finishing the pipeline in a trivial chat.

### Non-trivial (Plan Mode active)
Discuss throughout, not just once:
1. Design: use `whiteboard`'s Design mode to research, clarify open questions one at a time, weigh trade-offs, and write the design doc. Iterate until the user approves it.
2. Build: decide whether TDD applies (see `guinea-pig`'s criteria), then implement. Before leaving Plan Mode, add steps 3-5 below to the todo list so they survive the mode switch. If stuck, stop and discuss (see "When Stuck").
3. Verify: run `guinea-pig`. Loop into `sleuth` for failures, consulting the user each fix-and-retest iteration.
4. Review: run `gatekeeper`. Only a clean pass counts as approved.
5. Close out: ask if docs need updating, then run `wordsmith` only if yes.

Never call a non-trivial task done with an open Verify or Review todo.

### Trivial (default)
No fixed sequence. Reach for whichever skill fits (`whiteboard`, `guinea-pig`, `sleuth`, `gatekeeper`) and ask if unclear. Skip the pipeline, not the loop-consult safety rule (steps 3-4).
