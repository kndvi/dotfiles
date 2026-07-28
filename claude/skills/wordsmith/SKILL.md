---
name: wordsmith
description: Compose human-facing documentation, including READMEs, guides, changelogs, release notes, customer-facing docs, and internal engineering docs (runbooks, architecture notes, onboarding). Use only when explicitly asked, as the final step after the work is done and approved.
---

# wordsmith

<guidelines>
- Trigger: the work is done, the user has explicitly approved it, and they've explicitly asked for docs. Never write docs proactively or pre-emptively.
- Structure, tone, and detail should suit docs meant for people, not code comments and not the design doc.
- Match the audience. Customer-facing docs stay free of internal jargon and implementation detail, framed around what the reader can do or expects. Engineering docs (runbooks, architecture notes, onboarding) can assume technical context and go into internals.
- Verify claims against the current code/behavior before writing, not just the original design doc. Implementation can drift from the plan during Build/Verify/Review.
- A doc covering this already exists? Update it in place instead of creating a parallel or duplicate doc.
- No existing doc to extend? Follow the project's existing conventions for location and naming (e.g. root `README.md`, `CHANGELOG.md`, a `docs/` folder) instead of inventing a new structure.
- Match the style and heading conventions of existing docs in the repo instead of a fresh style each time.
- No strong existing convention to match? Default to flowing prose for narrative sections (overview, motivation, explanation); reserve bullet/numbered lists for genuinely discrete items (steps, parameters, options).
</guidelines>

<examples>
<example>Good: user says "looks good, update the README" after a merge-ready change. Write the README section now.</example>
<example>Good: user approves the code and separately asks for a CHANGELOG entry. Write in a tone/format suited to that changelog, not a copy of the design doc.</example>
<example>Good: user asks for release notes for the new feature. Write for the customer, describing what changed for them, not the internal implementation.</example>
<example>Good: user asks for a runbook after shipping a new service. Write for an on-call engineer, assuming technical context and covering internals the customer-facing docs wouldn't.</example>
<example>Good: the design doc said the API returns JSON, but Build switched it to protobuf. Check the actual code before documenting the response format, don't trust the design doc.</example>
<example>Good: repo already has a `docs/api.md`. New endpoint needs documenting there, add a section to that file instead of creating `docs/new-api.md`.</example>
<example>Bad: adding a "Usage" section to the README mid-feature, before the user asked or approved.</example>
<example>Bad: writing customer-facing release notes with internal function/module names instead of user-visible behavior.</example>
<example>Bad: writing a new doc in a style/heading format that doesn't match the rest of the repo's docs.</example>
</examples>
