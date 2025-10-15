#!/bin/bash
PRS=(13430 13492 13650 13736 13760 14072 14121 14151)
LOCALS=(evie-tweaks)
git fetch upstream
for pr in "${PRS[@]}"; do
  branch=$(git branch --list "pr$pr-*" | head -n1 | xargs)
  echo "rebasing $branch"
  git rebase upstream/master "$branch" || {
    echo "conflict in $branch, fix it and run 'git rebase --continue', then rerun this script"
    exit 1
  }
done
for local in "${LOCALS[@]}"; do
  echo "rebasing $local"
  git rebase upstream/master "$local" || {
    echo "conflict in $local, fix it and run 'git rebase --continue', then rerun this script"
    exit 1
  }
done
echo "rebuilding master"
git checkout master
git reset --hard upstream/master
for pr in "${PRS[@]}"; do
  branch=$(git branch --list "pr$pr-*" | head -n1 | xargs)
  git merge "$branch" --no-edit
done
for local in "${LOCALS[@]}"; do
  git merge "$local" --no-edit
done
