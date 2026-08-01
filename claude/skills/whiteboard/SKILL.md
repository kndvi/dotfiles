---
name: whiteboard
description: Design a real trade-off decision — architecture, a new dependency, a breaking change, or a multi-step plan — with deep research, cited findings, trade-off debate, and a design doc with a verification plan, before implementation starts.
---

# whiteboard

`<trigger>`
Architecture, performance, compatibility, maintainability, a new dependency/major upgrade, or a breaking change to a public API/schema/config (see `decisions`: never trivial and reversible). Reached by escalation — propose it when a question you're investigating turns out to hinge on one of these, and let the user decide whether to proceed.
`</trigger>`

`<procedure>`
- Before researching, check existing plans for a prior hit (an existing plan's Findings section may already answer this). Reuse it only after checking the library/dependency version or code referenced still matches what's in use now; re-research anything that's drifted or missing.
- Go deeper. Every claim the design's Design Decision or Risks rests on must be researched and recorded in the doc's Findings section (below); no unsupported claims.
- Debate trade-offs out loud. Present every viable option with its pros and cons and never pick a non-trivial one unilaterally. Prefer a library already used in the project unless you state a specific reason not to.
- Iterate with the user until they give an explicit final decision. One unconfirmed proposal isn't a decision.
- Break the task down and write it up as a design doc (below), with a Verification Plan that covers `testing` and anything else worth checking.
`</procedure>`

`<design_doc>`
Save it to `.claude/plans/<snake_case_slug>.md` in the repo (prefix a ticket ID if one exists), creating the directory if it doesn't exist yet. On revision, edit the existing file instead of creating a new one. Use `wordsmith` to draft the prose: narrative for Requirements/Design Decision, explicit and precise for Scope/Risks/Tasks/Verification Plan/Findings.

The template in [templates/design_doc.md](templates/design_doc.md) is shaped for a non-trivial solution. During the debate, decide which sections the decision actually warrants instead of mechanically filling every heading: Requirements, Scope, Design Decision, Tasks, and Verification Plan are load-bearing and always filled; Findings is required for any claim the Design Decision or Risks rests on; the rest are optional and can be skipped on a lighter decision. Don't omit a load-bearing section to save time. `Status` only flips to `Approved` once the user has given that explicit final decision and `Open Questions` is empty.
`</design_doc>`

`<examples>`
`<example>`Good: "Add caching." Deep-research Redis vs in-memory vs on-disk, log findings with sources, present pros and cons, and ask which fits before writing the design doc.`</example>`
`<example>`Good: "Upgrade Postgres 14 to 17" is a major upgrade with breaking changes. Research the release notes, record it in the doc's Findings section, surface the risks, flag which touched queries/migrations need dedicated test coverage, then write the doc.`</example>`
`<example>`Good: "Should we adopt library X over Y?" is a new-dependency decision — propose escalating first; if the user agrees, design it here.`</example>`
`<example>`Skip: renaming a local variable, fixing a typo. Trivial and reversible (see `decisions`), just do it, no design needed.`</example>`
`<example>`Bad: designing a real trade-off decision without proposing the escalation to the user first.`</example>`
`<example>`Bad: writing a design doc with no Verification Plan, leaving no direction for what to test or check.`</example>`
`</examples>`
