---
name: citation-needed
description: Sourcing discipline for external research - libraries, APIs, specs, standards, docs. Use before citing anything that isn't code in this repo, when checking a dependency's behavior or version, or when sources disagree.
---

# Sourcing

Open the source before citing it. Search the web, then fetch the actual page with
`WebFetch`. Never describe a page you have not opened. A search-result snippet is not a source
and neither is another model's summary of one.

## Source tier

1. The artifact itself - the installed code in `node_modules`/`site-packages`/the vendored copy,
   the lockfile, the spec text, a real API response. For a question about *behavior*, this
   outranks every prose source below.
2. Official docs or changelog, for the version actually pinned - not "latest".
3. A maintainer speaking in the repo: an issue, PR, or commit message.
4. A reputable third-party write-up.
5. A blog or forum post. Last, and never load-bearing on its own.

Documentation hosts move: `docs.claude.com/en/docs/claude-code/*` now redirects to
`code.claude.com/docs/en/*`. Follow the redirect and cite the URL actually read.

## Confidence

Rate the claim separately from the source - a tier-1 source can still be read wrong:

- `confirmed` - two independent sources agree, or it was verified by running it
- `single-source` - one source, not contradicted
- `contested` - sources disagree. Give the competing readings; never silently pick one
- `unverified` - no source opened. Say this rather than rounding up

Carry the pair on any claim a decision rests on: "connection pooling is per-process
(docs, confirmed)". A tier-5 source at `single-source` never carries a decision on its own.

Keep what a source says separate from inference drawn from it, and label the inference.
Never invent a citation, quotation, or statistic - "I couldn't find support for this" is a
good answer.
