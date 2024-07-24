call plug#begin('~/.config/nvim/plugins')
    Plug 'Everblush/everblush.vim' " colorscheme
    Plug 'christianrondeau/vim-base64' " base64 tool
    Plug 'folke/trouble.nvim' " show file diagnostics linting errors
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }   " fuzzy file finder
    Plug 'junegunn/fzf.vim' " fuzzy file finder
    Plug 'kylechui/nvim-surround' " surround sections with characters
    Plug 'lervag/file-line' " open files on correct line
    Plug 'neovim/nvim-lspconfig' " easily configure LSPs
    Plug 'nvim-lua/plenary.nvim' " lua library for coroutines
    Plug 'nvim-telescope/telescope.nvim' " GUI for list selection
    Plug 'nvim-tree/nvim-web-devicons' " integrate with emoticons
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " parser generator in VIM
    Plug 'nvim-treesitter/nvim-treesitter-refactor' " Refactor tools for treesitter
    Plug 'nvim-treesitter/playground' " show the parsing tree of the file
    Plug 'samoshkin/vim-mergetool' " easier mergetool
    Plug 'tpope/vim-commentary' " Comment selected lines
    Plug 'tpope/vim-fugitive' " git integration
call plug#end()

set number
set relativenumber

" Mouse
set mouse=a
set mousemodel=extend

" Line ending and wrap
set nowrap
set whichwrap+=<,>,[,]
set colorcolumn=101

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

nnoremap <A-1>      :exe 'e ~/projects/dotfiles/.config/nvim/init.vim'<CR>
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
vnoremap #          :Commentary<cr>

" Duplicate buffer
nnoremap <leader>xml :exe '!xmllint --format ' . expand("%:p") . ' \| xclip -sel clip'<cr>gg0vGPi<bs><esc>

" Quickfix next and prev
nnoremap <C-j> :cn<CR>
nnoremap <C-k> :cp<CR>

nnoremap <leader>fh <cmd>Telescope oldfiles<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fp <cmd>Telescope find_files cwd=~/projects/odev<cr>
nnoremap <leader>fo <cmd>Telescope find_files cwd=~/work/odoo<cr>
nnoremap <leader>fe <cmd>Telescope find_files cwd=~/work/enterprise<cr>
nnoremap <leader>go <cmd>Telescope live_grep cwd=~/work/odoo<cr>
nnoremap <leader>ge <cmd>Telescope live_grep cwd=~/work/enterprise<cr>
inoremap <expr> !file fzf#vim#complete("rg --files --hidden --no-ignore --null ~/work <Bar> xargs --null realpath --relative-to ~")

nnoremap <leader>f  BvEy:!firefox --new-tab "<C-r>+"<cr>

command! BufOnly execute '%bdelete|edit #|normal `"'

let g:mergetool_layout = 'bmr'
let g:mergetool_prefer_revision = 'local'
let g:file_line_crosshairs = 0
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

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

    -- Format diagnostic -------------------------------------------
    local function fmt(diagnostic)
        if diagnostic.code then
            return ("[%s] %s"):format(diagnostic.code, diagnostic.message)
        end
        return diagnostic.message
    end

    local function sign_define(args)
        vim.fn.sign_define(args.name, {
            texthl = args.name,
            text = args.text,
            numhl = ''
        })
    end

    -- Configure LSPs ----------------------------------------------
    lspconfig = require('lspconfig')
    lspconfig.ruff_lsp.setup {
        init_options = { settings = { args = {
            "--select", "ALL",
            "--preview",
            "--ignore", "ANN,B,C901,COM812,D,E501,E741,EM101,ERA001,FBT,I001,N,PD,"
                        .. "PERF,PIE790,PLR,PT,Q,RET502,RET503,RSE102,RUF001,RUF012,"
                        .. "S,SIM102,SIM108,SLF001,TID252,UP031,TRY002,TRY003,TRY300,"
                        .. "UP038,E713,SIM117,PGH003,RUF005,RET,DTZ,FIX,TD,ARG,TRY400,"
                        .. "TRY200,C408,PLW2901,PTH,EM102,INP001,CPY001,UP006,UP007,"
                        .. "E266,PIE808,FA100,FA102"
        }}}
    }
EOF

nnoremap <leader>h  :e `=Hook()`<CR>
function! Hook(folder='$HOME/work/odoo')
    let l:command = 'cd ' . a:folder . ' && $HOME/projects/ocli.sh hook name'
    let l:name = system(l:command)
    return l:name
endfunction
