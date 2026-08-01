---
name: wordsmith
description: Write and edit human-facing prose (READMEs, guides, changelogs, release notes, runbooks, design docs) and fix wording/grammar/clarity in existing text. Used directly when explicitly asked, and by `whiteboard` to draft its design doc. Keep sentences short and direct; narrative prose for higher-level sections, explicit and precise for technical detail.
---

# wordsmith

`<guidelines>`
- Trigger: only when explicitly asked to write, edit, or fix prose (a new doc, an edit, a proofread, a wording/grammar/clarity fix) — or when `whiteboard` calls it to draft a design doc. Not gated on code being done or approved. Never write or restructure docs proactively.
- Write for people, not as code comments. Keep sentences short and direct: say the plain thing first, add nuance only if it changes what the reader should do or believe.
- Split registers: narrative, flowing prose for higher-level sections (overview, motivation, summary); explicit and precise for technical detail (names, values, steps, parameters, versions). Don't blur the two.
- Match the audience. Customer-facing docs stay free of internal jargon and implementation detail; engineering docs (runbooks, design docs) can assume technical context and cover internals.
- Verify claims against the current code/behavior before writing, not just an existing doc or plan — implementation drifts while it's being built.
- Editing existing text: fix clarity, grammar, and wording while preserving the author's structure, meaning, and voice. Don't add content or restructure unless asked.
- Fit the repo: update an existing doc in place rather than duplicating it, and match the location, naming, and heading conventions already in use. No strong convention? Default to prose, reserving lists for genuinely discrete items (steps, parameters, options).
`</guidelines>`

`<examples>`
`<example>`Good: user says "update the README" after a merge-ready change. Write it now — prose work isn't gated on the code being "done."`</example>`
`<example>`Good: release notes for a new feature. Write for the customer, describing user-visible behavior, not the internal implementation.`</example>`
`<example>`Good: runbook after shipping a service. Write for an on-call engineer, assuming technical context and covering internals the customer docs wouldn't.`</example>`
`<example>`Good: user pastes a paragraph to fix the grammar. Correct grammar and wording only; keep the structure and meaning intact.`</example>`
`<example>`Good: the design doc said the API returns JSON but the code switched to protobuf. Check the current code before documenting the response format.`</example>`
`<example>`Bad: adding a "Usage" section to the README mid-feature without being asked.`</example>`
`<example>`Bad: asked to fix grammar, but rewriting an already-clear sentence to sound more sophisticated.`</example>`
`</examples>`
