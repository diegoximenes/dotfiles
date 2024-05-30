return {
	"andymass/vim-matchup",
	config = function()
		vim.g.matchup_matchparen_offscreen = {}
		vim.api.nvim_set_keymap("n", "<Leader>m", "<plug>(matchup-]%)", { noremap = true })
		vim.api.nvim_set_keymap("n", "<Leader>M", "<plug>(matchup-[%)", { noremap = true })
	end,
}
