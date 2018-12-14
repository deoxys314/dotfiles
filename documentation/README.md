# Useful snippets

A collection of useful one-liners or the like which don't merit an entire file
to themselves.

## OSX battery

This one liner will extract the current battery level for use at the OSX command
line.

`(pmset -g batt | grep --color=never -o -E "[0-9]{1,3}%")`

Note: in tmux, you will have to add an extra `%` as the string is passed through
`date`.

## OSX change to current open Finder Window

```fish
function cdf
  set --local target (osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)')
  if test -n target
    echo "Changing directory to: $target"
    cd $target
  else
    echo "No Finder window found." >&2
    return 1
  end
end
```

Adapting this to other shell languages should be fairly easy.

## Git change remote URL

`git remote set url [remote name] [new url]`

## Git Bisect

1. Find a good commit, note the hash or tag or some identifier.
2. Find a bad commit, note the hash or tag or some identifier.
3. Enter bisect mode using `$ git bisect`.
4. Tell bisect the good pr bad commits with `$ git bisect good abcdef` and `$
   git bisect bad 123456`.
5. Then tell git which of each commit is good based with `$ git bisect
   good|bad`. Git will automatically narrow down the range for you.

## Changing branch names in Git

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

## Adding formatted text in a Windows Forms RichTextBox

Some overloaded extension methods which may be useful.

```c#
namespace ExtensionMethods {

    using System.Windows.Forms;
    using System.Drawing;

    public static class RichTextBoxExtensions {
        public static void AppendText(this RichTextBox box, string text, Color color) {
            box.SelectionStart = box.TextLength;
            box.SelectionLength = 0;

            box.SelectionColor = color;
            box.AppendText(text);
            box.SelectionColor = box.ForeColor;
        }

        public static void AppendText(this RichTextBox box, string text, FontStyle style) {
            box.SelectionStart = box.TextLength;
            box.SelectionLength = 0;

            box.SelectionFont = new Font(box.Font, style);
            box.AppendText(text);
            box.SelectionFont = new Font(box.Font, FontStyle.Regular);
        }

        public static void AppendText(this RichTextBox box, string text, Color color, FontStyle style) {
            box.SelectionStart = box.TextLength;
            box.SelectionLength = 0;

            box.SelectionColor = color;
            box.SelectionFont = new Font(box.Font, style);
            box.AppendText(text);
            box.SelectionFont = new Font(box.Font, FontStyle.Regular);
            box.SelectionColor = box.ForeColor;
        }
    }
}
```
