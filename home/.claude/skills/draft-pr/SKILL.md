---
name: draft-pr
description: Create a draft PR following Diego's conventions - "Resolves NIT-XXXX" first line, brief description, no testing-plan section, changelog file in changelog/
argument-hint: <NIT-ticket> [base-branch]
disable-model-invocation: true
---

# Create a draft PR

Open a draft pull request for the current branch, following the conventions
below. Arguments: $ARGUMENTS (a Linear ticket like NIT-1234 and optionally a
base branch).

## Inputs

- Linear ticket: take it from the arguments. If missing, ask the user
  (they may answer "none", in which case omit the Resolves line).
- Base branch: from the arguments; otherwise the repo's default branch.

## Preconditions

Stop and report (instead of acting) if any of these fail:

- The current branch is not the base/default branch.
- The branch has commits ahead of the base.
- The working tree is clean.

## Changelog

If the repo has a `changelog/` directory and the branch diff does not
already touch it:

1. Draft a brief changelog entry (a few lines, no padding), matching the
   naming pattern of the existing files in that directory
   (e.g. `<username>-<topic>.md`).
2. Show it and ask whether to include it.
3. If accepted, commit it (commit requires the user's approval, as always).

## Compose

From the branch's commits and diff, draft:

- Title: short and imperative.
- Body:
  - First line: `Resolves NIT-XXXX`.
  - Then a brief description of what changed and why.
  - Never include a testing-plan / test-plan section.
  - No padding sections; keep the whole body short.

## Approve and create

1. Show the user: title, full body, base branch, and the exact commands
   that will run. Proceed only on explicit approval.
2. Push the branch (`git push -u origin <branch>`), then:
   `gh pr create --draft --base <base> --title <title> --body <body>`
3. Report the PR URL.

Do not add reviewers or labels, and do not mark the PR ready for review
unless the user asks.
