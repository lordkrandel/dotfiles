-- Shortcuts for my own `ocli` Odoo tool
map.t('<leader>ow', 'nvim -p `ocli path workspace`<CR>')
map.t('<leader>oh', 'nvim -p `ocli path hook`<CR>')

-- Show the github url for the current file
local function Gh()
    local Path = require "plenary.path"
    local current_path = vim.fn.expand('%:p')
    local current_folder = vim.fn.expand('%:p:h')
    local branch = vim.fn.systemlist('cd ' .. current_folder .. ' && git branch --show-current')[1]
    local relpath = Path:new(current_path):make_relative(universe)
    local pack = vim.split(relpath, '/')
    local root = pack[1]
    local rest = table.concat({unpack(pack, 2)}, '/')
    local win = vim.api.nvim_get_current_win()
    local lineno = vim.api.nvim_win_get_cursor(win)[1]
    local gh = 'https://github.com/odoo/' .. root .. '/tree/' .. branch .. '/' .. rest .. '#L' .. lineno
    print(gh)
    vim.fn.setreg("+", gh)
end
vim.keymap.set('n', '<C-g>', Gh)

-- Sort imports with ruff
map.n('<leader>fi', '<cmd>silent !ruff check --select I,RUF022 --fix %<cr>')
