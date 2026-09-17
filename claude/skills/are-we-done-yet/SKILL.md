---
name: are-we-done-yet
description: Owns the plan file structure - load whenever entering plan mode, and for any other multi-file or multi-step work whose plan will outlive a single context window. Not for one-line fixes or single-file changes.
---

# Plan file structure

Extend the existing plan file. Do not create a second document.

## Sections, in order

- `## Context` - why this change is happening: the problem or need, what prompted it, the
  intended outcome.
- `## Decisions taken` - settled choices and the reason for each. No alternatives considered,
  no back-and-forth - record the conclusion, not the path taken to it.
- `## Changes` - numbered, per-file. Name existing functions and utilities to reuse.
- `## Acceptance criteria` - checkable statements about observable behavior, agreed before
  writing code. Not a restatement of a task:
  - Good: "`./install` run twice leaves exactly one symlink per target"
  - Bad: "update the install script"
  - A criterion nobody can check is not a criterion.
- `## Out of scope` - what was deliberately left out, and why.
- `## Validation` - a checklist, added once implementation starts and kept current as work
  lands. Tick an item when it has been verified, not when it has been written.

The plan file is the artifact that survives compaction. Progress recorded only in the
conversation is lost when the window rolls, so update the file, not just the todo list.
