setlocal spell
setlocal textwidth=80
setlocal formatoptions+=ro

" from: https://codeberg.org/scy/dotfiles/commit/da1ae8379388f4c9fda3479e8146f548e48b761c

" When creating a new line (using i_<CR>, o or O) from a line which is a list
" item, make the new line a list item, too. However, Vim's default Markdown
" plugin defines list items as "comments" and sets the "f" flag (:h
" format-comments) which would only insert the indentation in the new line, not
" the "comment" marker itself. Therefore we define our own comments.
" We also define comment markers for task list items (those starting with
" `* [ ]`), so that creating a new line when already on a task will make the
" next line a task as well. If the current line was a checked-off task (i.e.
" `* [x]`), then the new one will be a non-checked-off one. To do that, we cheat
" a bit and define checked-off tasks as the "start" of a multi-line comment and
" tell Vim that the "middle" part is supposed to be the Markdown for an
" unchecked list item.
" Note that all of this only works for bullet point lists, not numbered ones.
setlocal comments=sb:*\ [x],mb:*\ [\ ],eb:*\ [\ ],sb:-\ [x],mb:-\ [\ ],eb:-\ [\ ],sb:+\ [x],mb:+\ [\ ],eb:+\ [\ ],b:*\ [\ ],b:-\ [\ ],b:*,b:-,b:+,n:>
