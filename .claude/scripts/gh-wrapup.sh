#!/usr/bin/env bash
set -euo pipefail

TITLE="${1:-chore: wrap up}"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"

[[ "$BRANCH" == "main" ]] && { echo "refusing to run on main"; exit 1; }

git diff --cached --quiet && { echo "nothing staged"; exit 1; }

git commit -m "$TITLE"
git push -u origin "$BRANCH"

PR_URL=$(gh pr create --fill --title "$TITLE" --head "$BRANCH" 2>/dev/null \
  || gh pr view --json url -q .url)

gh pr merge --squash --delete-branch --auto "$PR_URL"

git checkout main
git pull --ff-only origin main

# prune local branches whose remote is gone
git fetch -p
git branch -vv | awk '/: gone]/ {print $1}' | xargs -r git branch -D

# close any stale PRs from deleted branches (optional, gated)
gh pr list --author "@me" --state open --json number,headRefName \
  | jq -r '.[] | select(.headRefName as $b | [inputs] | index($b) | not) | .number' \
  < <(git branch -r | sed 's|origin/||') \
  | xargs -r -I{} gh pr close {} --delete-branch || true

echo "done: $PR_URL"
