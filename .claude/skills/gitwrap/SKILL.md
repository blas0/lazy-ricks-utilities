---
name: gitwrap
description: Preserve unfinished Git working state, synchronize a feature branch with its remote base, and safely restore staged, tracked, and untracked changes. Use when the user asks to update, rebase, or merge a dirty feature branch without losing local work.
user-invocable: true
disable-model-invocation: true
---

# Gitwrap

Stash unfinished work, sync the feature branch with its remote base, restore the work. One repository, no lost changes.

## Scope

This skill acts on one repository: the one containing the directory it was invoked from. It never takes a repo path as a target and never touches a sibling checkout.

```bash
repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -n "$repo_root" ] || { echo "not a git repository"; exit 1; }
[ "$repo_root" = "$PWD" ] || echo "SUBDIR-INVOCATION: pwd=$PWD root=$repo_root"
```

Empty `repo_root` stops the run. Do not look for another checkout.

Git finds `.git` by walking upward, so running this from a subdirectory binds it to the enclosing repository. If the two paths differ, say so and confirm that repository is the target before stashing, fetching, rebasing, or merging. In a monorepo that is the difference between syncing one package and rewriting the whole tree.

Run every later command with `$repo_root` as the working directory.

## Rules

- Stay inside `$repo_root`. The one exception is the worktree option, which writes to a single sibling path with approval.
- Inspect before mutating.
- Commits are not stashed. They stay reachable through the feature branch. A stash holds index and working-tree changes, so say so accurately.
- Stash untracked files with `-u`. Add `-a` only when the user asks and knows it sweeps in ignored files, which may be large or secret.
- Never `git reset --hard`, `git clean`, `git push --force`, or a destructive checkout.
- Rebase only private history. If someone else may have based work on the branch, merge the base instead or ask.
- Never pop a stash this run did not create.
- Stop on conflicts. Report the conflicted paths and the continue-or-abort choice. Discard neither side.
- Do not push, open a PR, or merge a PR unless the user asks for that. "Sync this branch" authorizes the local rebase or merge, nothing on the remote.

## Preflight

```bash
git status --short --branch
git branch --show-current
git worktree list
git remote -v
git remote show origin
git symbolic-ref --quiet --short refs/remotes/origin/HEAD   # the base
```

If the symbolic ref is missing, use the base the user named or ask. Do not assume `main`.

Stop and ask when:

- HEAD is detached.
- A merge, rebase, cherry-pick, or revert is in progress.
- The current branch is the remote default branch.
- The branch is shared and the user has not picked merge or rebase.
- Submodules or large generated files change what preservation means.

## Standard workflow: private branch

1. Record the stash tip:

```bash
stash_before="$(git rev-parse -q --verify refs/stash 2>/dev/null || true)"
```

2. Stash, untracked files included:

```bash
git stash push -u -m "gitwrap: <branch> before syncing <base>"
```

Check the exit status. On failure, stop and read `git status`. Do not fetch, rebase, restore, or drop anything.

3. Record the new tip:

```bash
stash_after="$(git rev-parse -q --verify refs/stash 2>/dev/null || true)"
```

A stash is new only when `stash_after` is non-empty and differs from `stash_before`. If nothing was stashed, restore nothing.

4. Fetch and rebase:

```bash
git fetch origin
git rebase origin/<base>
```

`git pull --ff-only origin <base>` cannot work here. A feature branch with its own commits has diverged, so there is nothing to fast-forward.

5. Restore by object ID, only if step 3 says a stash was created:

```bash
git stash apply --index "$stash_after"
```

`--index` keeps the staged versus unstaged split. `apply` before `drop` means a conflicted restore keeps the stash. Once the state is verified, drop that one reference:

```bash
git stash list --format='%gd %H'
git stash drop <matching-stash-ref>
```

6. Verify:

```bash
git status --short --branch
git log --oneline --decorate --graph -12
```

Run the repository's tests if the user asked for execution rather than instructions.

## Shared branch

If other people or agents have built on the branch, keep its published commits and merge instead:

```bash
git stash push -u -m "gitwrap: <branch> before merging <base>"
git fetch origin
git merge --no-edit origin/<base>
git stash apply --index "$stash_after"
```

Same guarded restore and drop as above. Tell the user this adds a merge commit when the histories diverge, and that the tradeoff buys them unrewritten shared commits.

## Worktree option

Use a worktree only when the user needs two checkouts at once. It stashes nothing and absorbs no dirty state.

```bash
git fetch origin
git worktree add "$(dirname "$repo_root")/$(basename "$repo_root")-<base>" <local-base-branch>
git -C "$(dirname "$repo_root")/$(basename "$repo_root")-<base>" pull --ff-only origin <base>
```

This is the only command here that writes outside `$repo_root`. The path must be a direct sibling, never an absolute path elsewhere, never inside another repository, never loose under `$HOME`. Show the resolved path and get approval first.

A branch cannot be checked out in two worktrees at once, so read `git worktree list` before adding. Do not invent or delete worktree paths without approval.

## Conflicts

Rebase conflict: run `git status` and offer both exits.

- Resolve, stage, `git rebase --continue`.
- `git rebase --abort` returns the branch to its exact pre-rebase state.

Stash-apply conflict: keep the stash, show the conflicted paths, resolve them as ordinary working-tree conflicts. No `git stash drop` until the result is verified.

## Pushing

- Branch never published: plain `git push`.
- Rebased branch that was published, and the user asks to update it: `git push --force-with-lease`, never `--force`.
- Shared branch: merge workflow, plain `git push`.

## Report

- Branch and base.
- Whether a stash was created, and whether it still exists.
- Rebased, merged, or unchanged.
- Conflicts, test results, leftover dirty files.
- Whether a push is needed. Do not push without authorization.
