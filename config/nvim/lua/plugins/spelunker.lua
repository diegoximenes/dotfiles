return {
	"kamykn/spelunker.vim",
	ft = { "gitcommit", "markdown", "plaintext", "tex", "en_us", "pt_br" },
	config = function()
		vim.g.spelunker_check_type = 0
		vim.g.enable_spelunker_vim_on_readonly = 1
		vim.g.spelunker_target_min_char_len = 1
		vim.g.spelunker_disable_account_name_checking = 0
		vim.g.spelunker_disable_backquoted_checking = 0
		vim.api.nvim_set_keymap("n", "ff", "<Plug>(spelunker-correct-from-list)", {})
	end,
}
