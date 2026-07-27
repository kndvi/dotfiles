---
name: whiteboard
description: Ground any question or claim yourself. Interview the user one question at a time, trace the codebase, and research the web with official/high-reputation sources first, escalating to Plan Mode on demand for a real trade-off decision. Inside Plan Mode, go further with deep research, cited findings, trade-off debate, task breakdown, and a design doc that lines up `guinea-pig`/`gatekeeper` and a TDD call before implementation starts. Auto-triggers for any question worth getting right, not just work decisions — a library's behavior, a pinned dependency's API/version, how existing code works, or a decision with real trade-offs (architecture, a new dependency, a breaking change, a multi-step plan).
---

# Whiteboard

Plan Mode gates two tiers of the same skill. Design mode fully inherits Explore mode, plus more.

## Explore mode (always available)
- Confident from your own knowledge and nothing hinges on precision? Just answer, no lookup needed.
- Clarifying with the user? Ask one question at a time with a recommended answer attached (see "Decisions").
- Codebase question, like architecture, call flow, "how does X work", or a diagram? Trace the actual code path yourself via Grep/Glob/Read: entry point, callers, callees, tests. Don't infer from naming or memory. Cite `file:line`. Draw a Mermaid diagram for structure or flow questions.
- External question about a library, an API, docs, or general research? Search the web and trace claims to primary sources, ranked official docs/spec first, then source code, then a reputable write-up, then a random blog last. Match the version actually pinned in the lockfile or manifest, not "latest".
- Before researching, check `~/work/notes/plans/` and `~/work/notes/research/` for a prior hit. Reuse it only after confirming it's still current; re-research anything stale or missing.
- Synthesize, don't dump. State what it means, what's still unclear, and flag disagreements between sources instead of picking one silently.
- Still unsure after checking primary sources? Ask the user. Never guess.
- Turns out to be a decision with real trade-offs (architecture, a new dependency, a breaking change, a multi-step plan)? Don't design it here. Propose escalating to Plan Mode and let the user decide. If they decline, give your best answer but flag it as a design question, not a checked fact.
- Invoke with `/whiteboard` any time something needs checking, answering, or a one-question-at-a-time interview.

## Design mode (Plan Mode active)
Inherits everything above, plus:
- Trigger: architecture, performance, compatibility, maintenance, a new dependency/major upgrade, or a breaking change to a public API/schema/config (see "Decisions": never trivial and reversible).
- Go deeper. Every claim the design's Approach or Risks rests on must be researched and saved to the findings log below; no unsupported claims.
- Debate trade-offs out loud. Present every viable option with its pros and cons and never pick a non-trivial one unilaterally. Prefer a library already used in the project unless you state a specific reason not to.
- Iterate with the user until they give an explicit final decision. One unconfirmed proposal isn't a decision.
- Break the task down and write it up as a design doc (below), with a Verification Plan that `guinea-pig` and `gatekeeper` can act on directly.

## Findings log
Save non-trivial research (skip for a quick one-off) to `~/work/notes/research/<snake_case_slug>.md` (prefix a ticket ID if one exists, e.g. `TICKET-123_slug.md`) in this shape:

```
Date: YYYY-MM-DD

# <Question or claim being grounded>

## Findings
What the sources show, in plain terms.

## Sources
- <source>: <url or file path>, what it confirms or refutes.

## Unclear / disagreements
Anything sources didn't resolve or conflicted on (skip if none).
```

Append to an existing file only for the same question revisited; a different question gets a new file. Before appending, skim the existing entry: split it by topic instead of adding another entry if it's grown past a handful of entries or spans unrelated sub-questions.

## Design doc (Design mode only)
Always write it to `~/work/notes/plans/<snake_case_slug>.md`, no other location (prefix a ticket ID if one exists). On revision, edit the existing file instead of creating a new one. Cite the findings log by file/entry wherever the design relies on it, instead of re-pasting or re-asserting the findings here.

Every section below is required. Don't omit one to save time; if a section genuinely doesn't apply (e.g. no viable alternative existed), say so explicitly rather than dropping it, so `guinea-pig`/`gatekeeper` can rely on the doc having a complete shape.

Template:

```
Date: YYYY-MM-DD

# <Title>

## Goal
What outcome this achieves and why it's needed.

## Context
Relevant background, constraints, existing code/systems involved.

## Approach
The proposed steps/design, in the order they'd be executed.

## Alternatives Considered
Other approaches and why they were not chosen (skip only if no other approach was viable).

## Design Decision
Why the chosen approach won: the specific reasoning/evidence that tipped it over the alternatives above, not a restatement of the Approach itself.

## Risks / Trade-offs
Anything that could break, be slow, or need a follow-up.

## Verification Plan
What `guinea-pig` should test, whether TDD applies, and what `gatekeeper` should check at review time.

## Open Questions
Anything unresolved that needs a decision before/during implementation.
```

## Example
- Good (explore): "How does a TCP handshake work?" out of curiosity. Answer from your own knowledge, no lookup needed.
- Good (explore): "Does this endpoint retry on timeout?", a single file to check. Read it yourself.
- Good (explore): "How does our auth flow work end-to-end?" Trace the middleware file, its callers, and its tests via Grep/Read, then explain with `file:line` refs and a Mermaid sequence diagram.
- Good (explore): "Can we use `structuredClone` here?" Check the pinned Node/browser version in the manifest, then MDN/the spec for that version, not "latest" docs.
- Good (explore, escalate on demand): "Should we adopt library X over Y?" is a new-dependency decision. Propose escalating to Plan Mode; if the user agrees, continue there instead of designing it here.
- Good (design): "Add caching." Deep-research Redis vs in-memory vs on-disk, log findings with sources, present pros and cons, and ask which fits before writing the design doc.
- Good (design): "Upgrade React 17 to 19" is a major upgrade with breaking changes. Research the migration guide, cite it in the findings log, surface the risks, note that `guinea-pig` should apply TDD for the riskiest touched components, then write the doc.
- Skip: renaming a local variable, fixing a typo. Trivial and reversible (see "Decisions"), just do it, no mode needed.
- Bad: describing behavior from a function or file name alone without opening it.
- Bad: answering "does this library retry on 429s?" from memory of an older version instead of checking the pinned version's actual source/docs.
- Bad: designing a real trade-off decision while Plan Mode is inactive instead of proposing the escalation first.
- Bad: writing a design doc with no Verification Plan, leaving `guinea-pig`/`gatekeeper` without direction.
