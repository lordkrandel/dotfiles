call plug#begin('~/.config/nvim/plugins')
    Plug 'lervag/file-line' " open files on correct line
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }   " fuzzy file finder
    Plug 'junegunn/fzf.vim' " fuzzy file finder
    Plug 'nvim-lua/plenary.nvim' " lua library for coroutines
    Plug 'nvim-telescope/telescope.nvim' " GUI for list selection
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " parser generator in VIM
    Plug 'nvim-treesitter/nvim-treesitter-refactor' " Refactor tools for treesitter
    Plug 'folke/trouble.nvim' " show file diagnostics linting errors
    Plug 'nvim-tree/nvim-web-devicons' " integrate with emoticons
    Plug 'nvim-treesitter/playground' " show the parsing tree of the file
    Plug 'neovim/nvim-lspconfig' " easily configure LSPs
    Plug 'tpope/vim-fugitive' " git integration
    Plug 'kylechui/nvim-surround' " surround sections with characters
    Plug 'samoshkin/vim-mergetool' " easier mergetool
    Plug 'christianrondeau/vim-base64' " base64 tool
    Plug 'Everblush/everblush.vim' " colorscheme
    Plug 'tpope/vim-commentary'
    Plug 'meatballs/vim-xonsh'
call plug#end()

set number
set relativenumber

" Mouse
set mouse=a
set mousemodel=extend

" Line ending and wrap
set nowrap
set whichwrap+=<,>,[,]

set clipboard=unnamedplus

" default tab settings
set expandtab
set shiftwidth=4

set listchars=eol:$,tab:>-,extends:>,precedes:<
set list

set splitright

" colorscheme
colorscheme everblush

let g:cfg = "~/.config/nvim"
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
""let g:netrw_fastbrowse = 2

set laststatus=2
set statusline=%{expand('%:p')}\ %m%=%{getcwd()}

nnoremap <A-1>      :exe 'e ' . g:cfg . '/init.vim'<CR>
nnoremap <A-2>      :e ~/.bashrc<CR>
nnoremap <A-3>      :e ~/.config/kitty/kitty.conf<CR>
nnoremap <A-4>      :e ~/.config/i3/config<CR>
nnoremap <A-5>      :e ~/.bash_aliases<CR>
nnoremap <A-6>      :e ~/notes.txt<CR>
nnoremap <A-7>      :silent! cd ~/work/odoo<CR>:e ~/work/odoo<CR>
nnoremap <A-8>      :silent! cd ~/work/enterprise<CR>:e ~/work/enterprise<CR>

nnoremap <A-left>   <C-o>
nnoremap <A-right>  <C-i>
nnoremap <C-s>      :w<CR>
nnoremap <C-y>      <C-r>
nnoremap <C-t>      :tabnew<CR>
nnoremap -          :noh<CR>
nnoremap <A-r>      :exe 'source ' . g:cfg . '/init.vim'<CR>
nnoremap <C-e>      :e %:h<CR>
nnoremap <leader>a  gg0VG$<cr>
nnoremap <leader>yf :let @+ = expand("%:p")<cr>
nnoremap <leader>yn :let @+ = expand("%:p") . ':' . line('.')<cr>

" Deletion
nnoremap x          "_x
nnoremap <S-x>      "_dd
vnoremap x          "_x

" Sub
nnoremap <C-h>      :%s/\v//gc<left><left><left><left>
vnoremap <C-h>      :s/\v//gc<left><left><left><left>
vnoremap /          /\%V

" Selection
vnoremap <S-down>   <down>
vnoremap <S-up>     <up>
nnoremap <S-down>   v<down>
nnoremap <S-up>     v<up>
nnoremap <S-left>   v<left>
nnoremap <S-right>  v<right>
vnoremap <S-down>   <down>
vnoremap <S-up>     <up>
vnoremap <S-left>   <left>
vnoremap <S-right>  <right>
vnoremap <C-left>   b
vnoremap <leader>/  :Commentary<cr>

" Duplicate buffer
nnoremap <leader>xml :exe '!xmllint --format ' . expand("%:p") . ' \| xclip -sel clip'<cr>gg0vGPi<bs><esc>

nnoremap <leader>fh <cmd>Telescope oldfiles<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fo <cmd>Telescope find_files cwd=~/work/odoo<cr>
nnoremap <leader>fe <cmd>Telescope find_files cwd=~/work/enterprise<cr>
nnoremap <leader>go <cmd>Telescope live_grep cwd=~/work/odoo<cr>
nnoremap <leader>ge <cmd>Telescope live_grep cwd=~/work/enterprise<cr>
inoremap <expr> !file fzf#vim#complete("rg --files --hidden --no-ignore --null ~/work <Bar> xargs --null realpath --relative-to ~")

nnoremap <leader>f  BvEy:!firefox <C-r>+<cr>

command! BufOnly execute '%bdelete|edit #|normal `"'

let g:mergetool_layout = 'bmr'
let g:mergetool_prefer_revision = 'local'
let g:file_line_crosshairs = 0

lua << EOF

    vim.api.nvim_set_hl(0, "TelescopeNormal", {bg="#222222"})
    local opts = { noremap=true, silent=true }

    -- NetRW setup -------------------------------------------------
    vim.g.netrw_banner=0
    vim.g.netrw_keepdir=1
    vim.g.netrw_list_hide="\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"
    vim.g.netrw_sort_options="i"

    -- Other -------------------------------------------------------
    require("nvim-surround").setup({})
    require("telescope").setup({cwd = '/home/odoo', extensions = {}})

    -- Trouble -----------------------------------------------------
    require("trouble").setup({
        mode = "document_diagnostics"
    })
    vim.keymap.set("n", "<leader>t", function() require("trouble").toggle() end)

    -- Configure LSPs ----------------------------------------------
    lspconfig = require('lspconfig')
    lspconfig.ruff_lsp.setup {
        init_options = { settings = { args = {
            "--select", "ALL",
            "--ignore", "SIM114,RSE102,COM812,I001,PERF,E501,B018,D100,Q,D,C901,"
                        .. "PLR,ANN,N,PT,UP031,FBT,B,SLF001,RET502,RET503,EM101,"
                        .. "TID252,SIM102,SIM108,S,ERA001,RUF012,TRY002,TRY003,"
                        .. "TRY300,PIE790,E741,RUF005,RET,DTZ,FIX,TD,ARG,TRY400,"
                        .. "UP009,T201,PTH123"
        }}}
    }
    lspconfig.pylsp.setup {
        on_attach = custom_attach,
        settings = { pylsp = { plugins = {
                pylint = { 
                    enabled = true,
                    args = {
                        "--disable=R,W0104,W0106,W0201,W0221,W0212,W0222,W0223,W0511,"
                               .. "W0613,W0621,W0631,W0640,W0642,W0703,W0707,E0203,"
                               .. "E0401,E1133,E1101,E1128,E1136,C0325,C0102,C0103,"
                               .. "C0111,C0301,C0302,C0330,C0411,I1101,E0012,E0611,"
                               .. "C0209",
                        "--max-line-length=105",
                    }
                },
                mccabe = { enabled = false },
        }
    }}}

EOF

nnoremap <leader>h  :e `=Hook()`<CR>
function! Hook(folder='$HOME/work')
    let l:command = 'cd ' . a:folder . ' && ocli hook name'
    let l:name = system(l:command)
    return l:name
endfunction

nnoremap <leader>it :call Compile()<CR>
function! Compile()
    let l:command = '. ~/work/.venv/bin/activate && cd ~/work/documentation && make && firefox ~/work/documentation/_build/html/applications/finance/fiscal_localizations/italy.html --new-tab'
    let l:ret = system(l:command)
    return l:ret
endfunction
