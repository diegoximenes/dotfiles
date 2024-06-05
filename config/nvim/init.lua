-- mapleader must be set before lazy.nvim is loaded
vim.g.mapleader = ","

-- disable netrw since a different file explorer is used
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--------------------------------------------------------------------------------
--- plugins manager: lazy.nvim
--------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

--------------------------------------------------------------------------------
--- general
--------------------------------------------------------------------------------

vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.wrap = false -- don"t "break" long lines
vim.opt.clipboard = "unnamedplus" -- yank and paste also goes to clipboard
vim.opt.guicursor =
	"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175" -- blinking cursor
vim.opt.showmode = false -- don"t show the current mode, status line takes cares of it
vim.opt.completeopt = "longest,menuone" -- change rules in autocomplete
vim.opt.formatoptions = "troqj" -- add comment when creating line and current line is commented
-- scroll
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
-- show trailing spaces and tabs
vim.opt.list = true
vim.opt.listchars = "tab:>-,trail:-"
-- indentation
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
-- disable tmp files
vim.opt.writebackup = false
vim.opt.backup = false
vim.opt.swapfile = false

-- disable arrows
vim.keymap.set({ "n", "v" }, "<Up>", "<NOP>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Down>", "<NOP>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Left>", "<NOP>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Right>", "<NOP>", { noremap = true, silent = true })

--------------------------------------------------------------------------------
--- general autocmds
--------------------------------------------------------------------------------

-- set filetypes
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.en_us" },
	callback = function()
		vim.opt.filetype = "en_us"
	end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.pt_br" },
	callback = function()
		vim.opt.filetype = "pt_br"
	end,
})

-- template for new .sh files
vim.api.nvim_create_autocmd({ "BufNewFile" }, {
	pattern = { "*.sh", "*.bash" },
	command = "0r ~/.config/nvim/templates/skeleton.sh",
})

-- remove trailing spaces
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	callback = function()
		if vim.bo.filetype == "markdown" then
			return
		end
		local save_cursor = vim.fn.getpos(".")
		vim.cmd([[silent! %s/\s\+$//e]])
		vim.fn.setpos(".", save_cursor)
	end,
})

-- remove end blank lines
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	callback = function()
		local save_cursor = vim.fn.getpos(".")
		vim.cmd([[silent! %s#\($\n\s*\)\+\%$##]])
		vim.fn.setpos(".", save_cursor)
	end,
})

-- spell config
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "gitcommit", "markdown", "plaintext", "tex", "en_us" },
	callback = function()
		vim.opt.spell = true
		vim.opt.spelllang = "en_us"
	end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "pt_br" },
	callback = function()
		vim.opt.spell = true
		vim.opt.spelllang = "pt_br"
	end,
})

--------------------------------------------------------------------------------
--- general mappings
--------------------------------------------------------------------------------

-- previous tag
vim.api.nvim_set_keymap("n", "<C-m>", ":pop<CR>", { noremap = true })

-- previous location, to be used when tags are not applied to file navigation
vim.api.nvim_set_keymap("n", "<C-z>", "<C-o>", { noremap = true })

-- visual-block mode
vim.api.nvim_set_keymap("n", "<C-a>", "<C-v>", { noremap = true })

-- show full file path
vim.api.nvim_set_keymap("n", "<C-e>", ":echo expand('%:p')<CR>", { noremap = true })

-- reload file
vim.api.nvim_set_keymap("n", "<F5>", ":edit<CR>", { noremap = true })

-- change letter case
vim.api.nvim_set_keymap("n", "U", "~", { noremap = true })

-- tab navigation
vim.api.nvim_set_keymap("n", "O", ":tabp<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "P", ":tabn<CR>", { noremap = true })

-- window navigation
vim.api.nvim_set_keymap("n", "J", "<C-w>j", { noremap = true })
vim.api.nvim_set_keymap("n", "K", "<C-w>k", { noremap = true })
vim.api.nvim_set_keymap("n", "H", "<C-w>h", { noremap = true })
vim.api.nvim_set_keymap("n", "L", "<C-w>l", { noremap = true })

-- move window into a new tab
vim.api.nvim_set_keymap("n", "T", "<C-w>T", { noremap = true })

-- vim-matchup, go to begin/end of pair
vim.api.nvim_set_keymap("n", "M", "g%", { noremap = true })

-- spell
vim.api.nvim_set_keymap("n", "fa", "zg", { noremap = true })
vim.api.nvim_set_keymap("n", "fr", "zug", { noremap = true })
vim.api.nvim_set_keymap("n", "fo", "[s", { noremap = true })
vim.api.nvim_set_keymap("n", "fp", "]s", { noremap = true })

-- duplicate line
vim.api.nvim_set_keymap("n", "dl", ":t.<CR>", { noremap = true })

-- go to end of line
vim.api.nvim_set_keymap("n", "E", "g_", { noremap = true })
vim.api.nvim_set_keymap("v", "E", "g_", { noremap = true })
