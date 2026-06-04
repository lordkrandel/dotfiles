-- wrapping
vim.opt.wrap = false
vim.opt.isfname = vim.tbl_filter(function(item)
    return item ~= ":"
end, vim.opt.isfname:get())
vim.opt.whichwrap:append("<,>,[,]")

-- tab settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Mouse
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- where to split
vim.opt.splitright = true

-- VISUAL ------------------------------------

-- line stuff
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "121"
vim.opt.cursorline = true
vim.opt.listchars = "eol:$,tab:>-,lead:·,space:·,extends:>,precedes:<"
vim.opt.list = true

-- set highlight line
vim.api.nvim_set_hl(0, "LineNr", {fg = "#AA7777"})
vim.api.nvim_set_hl(0, "CursorLineNr", {fg = "#EEEEEE"})

-- where to put statusline
vim.opt.laststatus = 2

-- Setup theme --------------------------------------------------
require("catppuccin").setup({flavour = "mocha"})
vim.cmd.colorscheme("catppuccin")

-- Set statusbar -----------------------------------------------
require("satellite").setup()
require('lualine').setup({
    sections = {
        lualine_c = {
            {
                'filename',
                path = 1,
                fmt = function(name)
                    -- remove fugitive:// and write the branch name instead
                    if name:match('^fugitive://') then
                        local sha = name:match('%.git//(%x+)/')
                        local rel_path = name:gsub('^fugitive://.-%.git//.-/', '')
                        if sha then
                            local result = vim.fn.FugitiveExecute({'name-rev', '--name-only', sha})
                            local ref_name = (result and result.stdout and result.stdout[1]) or sha
                            ref_name = ref_name:gsub('\n', ''):gsub('%^0', ''):gsub('tags/', '')
                            return ref_name .. ' > ' .. rel_path
                        end
                    end
                    return name
                end
            }
        }
    }
})

-- surround with quotes?  do `ysiw"`
require("nvim-surround").setup()

-- delete buffer on window close
vim.cmd('command! BufOnly execute \'%bdelete|edit #|normal `"')

