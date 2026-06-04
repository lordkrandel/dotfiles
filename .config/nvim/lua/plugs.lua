vim.call('plug#begin')
local Plug = vim.fn['plug#']

	-- visual
	-- ------------------------------
	-- colorscheme
    Plug 'catppuccin/nvim'
	-- highlight
	Plug 'Pocco81/HighStr.nvim'
	-- emoticons
	Plug 'nvim-tree/nvim-web-devicons'
	-- scrollbar
	Plug 'lewis6991/satellite.nvim'
	-- statusline
	Plug 'nvim-lualine/lualine.nvim'

	-- editing ----------------------
	-- comment selected lines
	Plug 'tpope/vim-commentary'
    -- surround sections with characters
	Plug 'kylechui/nvim-surround'

	-- flow -------------------------
	-- open files on correct line with like "file.vim:2138"
	Plug 'lervag/file-line'
	-- FZF in VIM to search files
	Plug 'ibhagwan/fzf-lua'

	-- tools ------------------------
	-- git integration
	Plug 'tpope/vim-fugitive'
	-- Open folders as buffers
	Plug 'stevearc/oil.nvim'
	-- base64 tool
	Plug 'christianrondeau/vim-base64'

	-- LSP --------------------------
	-- lua library for coroutines
	Plug 'nvim-lua/plenary.nvim'
    Plug "Vimjas/vim-python-pep8-indent"

    -- Terminal ---------------------
    Plug 'willothy/flatten.nvim'

vim.call('plug#end')
