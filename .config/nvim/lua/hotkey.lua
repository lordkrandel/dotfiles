vim.keymap.set("v", "^", ":s/\\s\\+$//e<CR>:noh<CR>", {
    desc = "Remove trailing whitespace in selection and clear highlight",
    silent = true,
})

-- History move
map.n("<A-left>", "<C-o>")
map.n("<A-right>", "<C-i>")

-- Multiline Comment
map.v("#", ":Commentary<cr>")

-- Fast save
map.n("<C-s>", ":w<CR>")

-- Select all
map.n("<C-a>", "gg0VG$<cr>")

-- Remove search highlight
map.n("-", ":noh<CR>")

-- Reload config
map.n("<A-r>",
    ":exe 'source " .. config .. "/nvim/init.lua'<CR>"
)

-- Increment / decrement
map.n("<C-up>", "<C-a>")
map.n("<C-down>", "<C-x>")

-- Open link in browser
map.v("<leader>link", '"+y:silent !~/bin/librewolf/librewolf.AppImage --new-tab <C-r>+<cr>')

-- Copy filename
map.n("<leader>yf", ":let @+ = expand('%:p')<cr>")
-- Copy filename at line
map.n("<leader>yn", ":let @+ = expand('%:p') . ':' . line('.')<cr>")

-- Numpad Enter
map.n("<kEnter>", "<Enter>")
map.i("<kEnter>", "<Enter>")
map.v("<kEnter>", "<Enter>")

-- Deletion to null buffer
map.n("x", "_x")
map.n("<S-x>", '"_dd')
map.v("x", '"_x')

-- Replace with Ctrl-h, also on visual mode
map.n("<C-h>", ":%s/\\v//gc<left><left><left><left>")
map.v("<C-h>", ":s/\\v//gc<left><left><left><left>")

-- Selection
map.v("<S-down>",   "<down>")
map.v("<S-up>",     "<up>")
map.n("<S-down>",   "v<down>")
map.n("<S-up>",     "v<up>")
map.n("<S-left>",   "v<left>")
map.n("<S-right>",  "v<right>")
map.v("<S-down>",   "<down>")
map.v("<S-up>",     "<up>")
map.v("<S-left>",   "<left>")
map.v("<S-right>",  "<right>")
map.v("<C-left>",   "b")

-- Quickfix next and prev
map.n("<C-j>", ":cn<CR>")
map.n("<C-k>", ":cp<CR>")

-- Markdown preview with glow
map.n('<leader>md', ':silent !rio -e glow % -p<CR>')
