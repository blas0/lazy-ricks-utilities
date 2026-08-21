---
name: gitprune
description: Remove safely merged, stale, or superseded repository branches and worktrees while preserving unique work.
model: claude-opus-5
effort: high
user-invocable: true
---

`/goal` within `$CLAUDE_PROJECT_DIR`, use Git and the GitHub CLI to reconcile local repository state with `origin` and its pull requests.

Inspect and classify:

* local and remote branches
* attached and stale worktrees
* recently merged and open pull requests
* divergence from `origin/main`

Classify a branch or worktree as:

* **Merged:** `origin/main` already contains all of its commits.
* **Superseded:** a newer branch, pull request, or implementation already covers its work.
* **Stale:** it has no open pull request and no recent commits; it looks abandoned.
* **Active:** it holds unique unmerged work or backs an open pull request.

Fetch and prune remote references before deciding anything. Remove merged and superseded branches and worktrees locally and from `origin`. Never delete unique commits, dirty worktrees, or branches backing open pull requests.

When several branches carry the same unfinished work, move their unique commits onto the most current viable branch, confirm no commits were lost, then remove the redundant branches. Close their redundant pull requests; do not delete them.

Finish with:

* the repository checked out on `main`
* local `main` matching `origin/main`
* stale worktree metadata pruned
* no safely removable branches or worktrees left

Report what you removed, consolidated, preserved, or blocked, with the reason for anything you could not safely change.

`/loop` until you NEED a human to direct you further.
