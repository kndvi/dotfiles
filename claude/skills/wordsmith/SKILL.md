---
name: wordsmith
description: Write and edit human-facing prose (READMEs, guides, changelogs, release notes, runbooks, findings logs, design docs) and fix wording/grammar/clarity in existing text. Used directly when explicitly asked, and by `whiteboard` to draft its findings log and design doc. Keep sentences short and direct; narrative prose for higher-level sections, explicit and precise for technical detail.
---

# wordsmith

`<guidelines>`
- Trigger: the user explicitly asks for writing or editing work (a new doc, an edit, a proofread, a wording/grammar/clarity fix) at any point in a task, not gated on code being done or approved. Also invoked by `whiteboard` to draft the prose for its findings log and design doc. Never write or restructure docs proactively without being asked.
- Structure, tone, and detail should suit docs meant for people, not code comments.
- Keep sentences short and direct. Say the plain thing first; add nuance only if it changes what the reader should do or believe.
- Narrative, flowing prose for higher-level sections (overview, motivation, goal, context, summary). Explicit and precise for technical sections (exact names, values, steps, parameters, versions). Don't blur the two registers by making technical detail vague or narrative sections overly clinical.
- Match the audience. Customer-facing docs stay free of internal jargon and implementation detail, framed around what the reader can do or expects. Engineering docs (runbooks, architecture notes, onboarding, findings logs, design docs) can assume technical context and go into internals.
- Verify claims against the current code/behavior before writing, not just an existing design doc or plan. Implementation can drift while it's being built and verified.
- Editing/fixing existing text rather than writing new content? Preserve the author's structure, meaning, and voice: fix clarity, grammar, and wording; don't add new content or restructure unless asked.
- A doc covering this already exists? Update it in place instead of creating a parallel or duplicate doc.
- No existing doc to extend? Follow the project's existing conventions for location and naming (e.g. root `README.md`, `CHANGELOG.md`, a `docs/` folder) instead of inventing a new structure.
- Match the style and heading conventions of existing docs in the repo instead of a fresh style each time.
- No strong existing convention to match? Default to flowing prose for narrative sections; reserve bullet/numbered lists for genuinely discrete items (steps, parameters, options).
`</guidelines>`

`<examples>`
`<example>`Good: user says "looks good, update the README" after a merge-ready change. Write the README section now.`</example>`
`<example>`Good: user approves the code and separately asks for a CHANGELOG entry. Write in a tone/format suited to that changelog, not a copy of the design doc.`</example>`
`<example>`Good: user asks for release notes for the new feature. Write for the customer, describing what changed for them, not the internal implementation.`</example>`
`<example>`Good: user asks for a runbook after shipping a new service. Write for an on-call engineer, assuming technical context and covering internals the customer-facing docs wouldn't.`</example>`
`<example>`Good: `whiteboard` finishes a Design mode session and needs the design doc written up. Draft the Goal/Context/Design Decision as narrative prose, and the Approach/Risks/Verification Plan with explicit, precise detail (exact steps, exact checks).`</example>`
`<example>`Good: user pastes a paragraph and asks to fix the grammar. Correct grammar/wording only, keep the structure and meaning exactly as the author intended.`</example>`
`<example>`Good: the design doc said the API returns JSON, but the actual implementation switched to protobuf. Check the current code before documenting the response format, don't trust the design doc.`</example>`
`<example>`Good: repo already has a `docs/api.md`. New endpoint needs documenting there, add a section to that file instead of creating `docs/new-api.md`.`</example>`
`<example>`Bad: adding a "Usage" section to the README mid-feature without the user asking for it.`</example>`
`<example>`Bad: asked to fix grammar, but rewriting an already-clear sentence into a more "sophisticated"-sounding one instead.`</example>`
`<example>`Bad: writing customer-facing release notes with internal function/module names instead of user-visible behavior.`</example>`
`<example>`Bad: writing a new doc in a style/heading format that doesn't match the rest of the repo's docs.`</example>`
`</examples>`
