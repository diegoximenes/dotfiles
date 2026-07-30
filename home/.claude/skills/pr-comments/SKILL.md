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
2. Present: reviewer, file:line, the comment (quoted or condensed), your
   analysis, and a concrete proposed change.
3. Ask with AskUserQuestion: "Address" or "Skip for now".
4. Skip: record it and move on.
5. Address: implement the change, show the diff, then ask: "Commit",
   "Rework" (take feedback and iterate), or "Discard and skip" (revert).
6. On commit approval: commit only the files changed for this thread,
   with a short imperative message describing the fix.
7. Move to the next thread.

## Rules

- Never reply to threads, resolve threads, or comment on GitHub.
- Never push during the loop.
- One thread at a time; do not batch analyses or fixes.

## Wrap-up

- Summarize: addressed threads (with their commits), skipped threads.
- Offer to push the commits to the PR branch; push only if approved.
