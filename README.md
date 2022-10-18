# Quests for Rebuild EQ

## Preparing for ProjectEQ Merging

First, to prepare for remote pulls:
```
git remote add peq git@github.com:ProjectEQ/projecteqquests.git
git fetch peq
git checkout -b peq-master peq/master
git checkout master
git checkout main
```

Then, to pull down latest of changes from peq's master:
```
git checkout main
git merge master --allow-unrelated-histories
```