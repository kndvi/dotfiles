---
name: are-we-done-yet
description: Defines "done" before implementation starts, then tracks it during. Use for multi-file or multi-step work, or any task whose plan will outlive a single context window. Not for one-line fixes or single-file changes.
---

# Acceptance criteria and validation

Extend the existing plan file. Do not create a second document.

## Before implementation

Add an `## Acceptance criteria` section. Each criterion is a checkable statement about
observable behavior, not a restatement of a task:

- Good: "`./install` run twice leaves exactly one symlink per target"
- Bad: "update the install script"

Agree these before writing code. A criterion nobody can check is not a criterion.

## During implementation

Add a `## Validation` checklist and keep it current as work lands. Tick an item when it has
been verified, not when it has been written.

The plan file is the artifact that survives compaction. Progress recorded only in the
conversation is lost when the window rolls, so update the file, not just the todo list.

## Model

Once the plan is approved and the remaining work is mechanical, suggest the user run
`/model sonnet` - one line, then carry on without waiting for it. Suggest it early: the
prompt cache is model-scoped, so a late switch re-reads the whole conversation uncached and
can cost more than it saves. Say nothing while the work still turns on genuine design
judgment.
