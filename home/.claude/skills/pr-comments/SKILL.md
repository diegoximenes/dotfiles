---
name: pr-comments
description: Walk through a PR's unresolved review comment threads one at a time - analyze each, ask whether to address or skip, commit each accepted fix after approval
argument-hint: <pr number or url>
disable-model-invocation: true
---

# Address unresolved PR review threads

Work through the unresolved review comment threads of a pull request,
strictly one thread at a time. Target PR: $ARGUMENTS
(if empty, use the current branch's PR via `gh pr view --json number,url`;
if there is none, ask the user).

## Setup

1. Determine owner, repo, and PR number (parse the URL if one was given,
   otherwise `gh repo view --json owner,name`).
2. Verify the local checkout is on the PR's head branch with a clean
   working tree. If not, stop and report instead of touching anything.
3. Fetch review threads with pagination and keep only `isResolved == false`:

   gh api graphql -f query='
     query($owner: String!, $repo: String!, $pr: Int!, $cursor: String) {
       repository(owner: $owner, name: $repo) {
         pullRequest(number: $pr) {
           reviewThreads(first: 100, after: $cursor) {
             pageInfo { hasNextPage endCursor }
             nodes {
               isResolved
               isOutdated
               path
               line
               comments(first: 50) {
                 nodes { author { login } body url }
               }
             }
           }
         }
       }
     }' -F owner=<owner> -F repo=<repo> -F pr=<number>

4. Tell the user how many unresolved threads were found.

## Per-thread loop

For each unresolved thread, in file/position order:

1. Read the referenced file and surrounding code (note if the thread is
   outdated relative to the current code).
2. End your turn with the analysis message and wait for the user's
   reply. This is the core deliverable of the skill. It must be the
   final text of your turn, with no tool call after it — do NOT use
   AskUserQuestion. Your extended thinking is invisible to the user;
   analysis that happens only in thinking has not been presented.
   Template:

   ### Thread N/M — `path:line` — @reviewer
   > The comment, quoted (condensed only if very long; note if the
   > thread is outdated).

   **Problem:** What issue the reviewer is raising, what the current
   code actually does, whether the concern is valid (and why), and its
   impact. A few sentences minimum.

   **Proposed change:** The concrete fix you would make.

   Address or skip?

3. Skip: record it and move on to the next thread's analysis.
4. Address: implement the change, then end your turn showing the diff
   and asking: commit, rework (tell me what to change), or discard and
   skip?
5. On commit approval: commit only the files changed for this thread,
   with a short imperative message describing the fix.
6. Move to the next thread.

## Rules

- Never reply to threads, resolve threads, or comment on GitHub.
- Never push during the loop.
- Never use AskUserQuestion in this skill; every question is plain text
  ending your turn.
- One thread at a time; do not batch analyses, questions, or fixes. Even
  when one fix would cover several threads, present each thread's
  analysis separately and ask about each separately (you may note the
  overlap in the Proposed change section).
- Do not track the loop with a todo list; the analysis messages are the
  progress display.

## Wrap-up

- Summarize: addressed threads (with their commits), skipped threads.
- Offer to push the commits to the PR branch; push only if approved.
