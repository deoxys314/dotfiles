# Changing branch names in Git

This covers both local and remote:

```shell
git branch -m old_branch new_branch         # Rename branch locally
git push origin :old_branch                 # Delete the old branch
git push --set-upstream origin new_branch   # Push the new branch,
                                            # set local branch to track the new remote
```

[source](https://gist.github.com/lttlrck/9628955)

And deleting a branch locally:

```shell
git branch -d old_branch
```
