---
name: are-we-done-yet
description: Owns the plan file structure - load whenever entering plan mode, and for any other multi-file or multi-step work whose plan will outlive a single context window. Not for one-line fixes or single-file changes.
---

# Plan file structure

Extend the existing plan file. Do not create a second document.

## Sections, in order

- `## State` - one line, rewritten (never appended) each time work lands: what is done, what is
  next. This is the first thing read after a compaction.
- `## Context` - why this change is happening: the problem or need, what prompted it, the
  intended outcome.
- `## Decisions taken` - one sentence per decision, in the form: in the context of X, facing Y,
  we chose Z over W, to achieve Q, accepting D. Naming W is the point - it is what stops a
  settled alternative coming back after a compaction.
- `## Changes` - numbered, per-file. Name existing functions and utilities to reuse.
- `## Acceptance criteria` - checkable statements about observable behavior, agreed before
  writing code. One per shape that applies:
  - plain: "`GET /orders` returns results ordered by `created_at` descending"
  - on a trigger: "when the cursor is exhausted, the response omits `next_cursor`"
  - in a state: "while a migration is running against the table, writes return `503`, not a
    partial commit"
  - on failure: "if the cursor is malformed, the endpoint returns `400` with an error body,
    not a `500`"
  The failure shape is the one most often missing. Not a restatement of a task: "update the
  install script" is not a criterion, and a criterion nobody can check is not a criterion.
- `## Out of scope` - what was deliberately left out, and why.
- `## Validation` - how to verify each acceptance criterion end to end, written with the plan.
  It becomes a checklist once implementation starts; tick an item when it has been verified, not
  when it has been written.

The plan file is the artifact that survives compaction. Progress recorded only in the
conversation is lost when the window rolls, so update the file, not just the todo list.
