vim.opt_local.spell = true
vim.opt_local.textwidth = 80
vim.opt_local.formatoptions:append{ 'r', 'o' }

-- When creating a new line (using i_<CR>, o or O) from a line which is a list
-- item, make the new line a list item, too. However, Vim's default Markdown
-- plugin defines list items as "comments" and sets the "f" flag (:h
-- format-comments) which would only insert the indentation in the new line,
-- not the "comment" marker itself. Therefore we define our own comments. We
-- also define comment markers for task list items (those starting with `*
-- [ ]`), so that creating a new line when already on a task will make the next
-- line a task as well. If the current line was a checked-off task (i.e. `*
-- [x]`), then the new one will be a non-checked-off one. To do that, we cheat
-- a bit and define checked-off tasks as the "start" of a multi-line comment
-- and tell Vim that the "middle" part is supposed to be the Markdown for an
-- unchecked list item.
-- Note that all of this only works for bullet point lists, not numbered ones.
local function c_opt(args)
    local flags = args[1]
    local str = args[2]
    return flags .. ':' .. str
end
-- Order matters on these
vim.opt_local.comments = {
    c_opt { 'sb', '* [x]' },
    c_opt { 'mb', '* [ ]' },
    c_opt { 'eb', '* [ ]' },
    c_opt { 'sb', '- [x]' },
    c_opt { 'mb', '- [ ]' },
    c_opt { 'eb', '- [ ]' },
    c_opt { 'sb', '+ [x]' },
    c_opt { 'mb', '+ [ ]' },
    c_opt { 'eb', '+ [ ]' },
    c_opt { 'b', '* [ ]' },
    c_opt { 'b', '- [ ]' },
    c_opt { 'b', '*' },
    c_opt { 'b', '-' },
    c_opt { 'b', '+' },
    c_opt { 'n', '>' },
}
