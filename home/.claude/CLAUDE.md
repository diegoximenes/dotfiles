# Code comments

- Do not write comments that restate what the code does or narrate the change
  (e.g. "increment the counter", "call the API", "new helper function").
  The code itself documents that.
- Exception: genuinely complicated logic (non-obvious algorithms, subtle
  invariants) may get a brief explanatory comment.
- Never reference prior implementations in comments — no "the old X",
  "previously", "would have", "no longer", "now uses". This applies
  everywhere, including test doc comments explaining a regression guard:
  state the invariant in present tense instead.
- Do write comments for context that cannot be derived from the code:
  decision rationale (why this approach instead of alternatives), external
  constraints, workarounds for third-party bugs (with a link), gotchas.

# Git and GitHub

- Never create a git commit, push, or publish anything to GitHub (pull
  requests, releases, comments) without explicit authorization from the
  user in the current conversation.
- One authorization covers one action; it does not extend to later
  commits or pushes.
