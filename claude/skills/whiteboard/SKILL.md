---
name: whiteboard
description: Ground any question or claim yourself. Interview the user one question at a time, trace the codebase, and research the web with official/high-reputation sources first, escalating to Plan Mode on demand for a real trade-off decision. Inside Plan Mode, go further with deep research, cited findings, trade-off debate, task breakdown, and a design doc that lines up a verification plan before implementation starts. Auto-triggers for any question worth getting right, not just work decisions, including a library's behavior, a pinned dependency's API/version, how existing code works, or a decision with real trade-offs (architecture, a new dependency, a breaking change, a multi-step plan).
---

# whiteboard

Plan Mode gates two tiers of the same skill. Design mode fully inherits Explore mode, plus more.

`<explore_mode>`
- Confident from your own knowledge and nothing hinges on precision? Just answer, no lookup needed.
- Clarifying with the user? Ask one question at a time with a recommended answer attached (see `decisions`).
- Codebase question, like architecture, call flow, "how does X work", or a diagram? Trace the actual code path via Grep/Glob/Read: entry point, callers, callees, tests. Cite `file:line`. Draw a Mermaid diagram for structure or flow questions.
- External question about a library, an API, docs, or general research? Search the web and trace claims to primary sources, ranked official docs/spec first, then source code, then a reputable write-up, then a random blog last. Match the version actually pinned in the lockfile or manifest, not "latest".
- Before researching, check existing plans for a prior hit (an existing plan's Findings section may already answer this). Reuse it only after checking the library/dependency version or code referenced still matches what's in use now; re-research anything that's drifted or missing.
- Synthesize, don't dump. State what it means, what's still unclear, and flag disagreements between sources instead of picking one silently.
- Still unsure after checking primary sources? Ask the user. Never guess.
- Turns out to be a decision with real trade-offs (architecture, a new dependency, a breaking change, a multi-step plan)? Don't design it here. Propose escalating to Plan Mode and let the user decide. If they decline, give your best answer but flag it as a design question, not a checked fact.
- Invoke with `/whiteboard` any time something needs checking, answering, or a one-question-at-a-time interview.
`</explore_mode>`

`<design_mode>`
Inherits everything above, plus:
- Trigger: architecture, performance, compatibility, maintainability, a new dependency/major upgrade, or a breaking change to a public API/schema/config (see `decisions`: never trivial and reversible).
- Go deeper. Every claim the design's Approach or Risks rests on must be researched and recorded in the doc's Findings section (below); no unsupported claims.
- Debate trade-offs out loud. Present every viable option with its pros and cons and never pick a non-trivial one unilaterally. Prefer a library already used in the project unless you state a specific reason not to.
- Iterate with the user until they give an explicit final decision. One unconfirmed proposal isn't a decision.
- Break the task down and write it up as a design doc (below), with a Verification Plan that covers `testing` and anything else worth checking.
`</design_mode>`

`<design_doc>`
Always save it alongside the agent's other plan files, named `<snake_case_slug>.md` (prefix a ticket ID if one exists). On revision, edit the existing file instead of creating a new one. Use `wordsmith` to draft the prose: narrative for Goal/Context/Design Decision, explicit and precise for Approach/Risks/Verification Plan/Findings.

Every section in [templates/design_doc.md](templates/design_doc.md) is required, including Findings for every claim the Approach or Risks rests on. Don't omit a section to save time; if one genuinely doesn't apply (e.g. no viable alternative existed), say so explicitly rather than dropping it, so the doc has a complete shape.
`</design_doc>`

`<examples>`
`<example>`Good (explore): "How does a TCP handshake work?" out of curiosity. Answer from your own knowledge, no lookup needed.`</example>`
`<example>`Good (explore): "Does this endpoint retry on timeout?", a single file to check. Read it yourself.`</example>`
`<example>`Good (explore): "How does our auth flow work end-to-end?" Trace the middleware file, its callers, and its tests via Grep/Read, then explain with `file:line` refs and a Mermaid sequence diagram.`</example>`
`<example>`Good (explore): "Can we use Python's `tomllib` here?" Check the pinned Python version in the lockfile, then the stdlib docs for that version, not "latest" docs.`</example>`
`<example>`Good (explore, escalate on demand): "Should we adopt library X over Y?" is a new-dependency decision. Propose escalating to Plan Mode; if the user agrees, continue there instead of designing it here.`</example>`
`<example>`Good (design): "Add caching." Deep-research Redis vs in-memory vs on-disk, log findings with sources, present pros and cons, and ask which fits before writing the design doc.`</example>`
`<example>`Good (design): "Upgrade Postgres 14 to 17" is a major upgrade with breaking changes. Research the release notes, record it in the doc's Findings section, surface the risks, flag which touched queries/migrations need dedicated test coverage, then write the doc.`</example>`
`<example>`Skip: renaming a local variable, fixing a typo. Trivial and reversible (see `decisions`), just do it, no mode needed.`</example>`
`<example>`Bad: answering "does this library retry on 429s?" from memory of an older version instead of checking the pinned version's actual source/docs.`</example>`
`<example>`Bad: designing a real trade-off decision while Plan Mode is inactive instead of proposing the escalation first.`</example>`
`<example>`Bad: writing a design doc with no Verification Plan, leaving no direction for what to test or check.`</example>`
`</examples>`
