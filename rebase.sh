#!/bin/bash
PRS=(13430 13492 13650 13760 14073 14121 14151)
git fetch upstream
for pr in "${PRS[@]}"; do
  branch=$(git branch --list "pr$pr-*" | head -n1 | xargs)
  echo "rebasing $branch"
  git rebase upstream/master "$branch" || {
    echo "conflict in $branch, fix it and run `git rebase --continue`"
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
