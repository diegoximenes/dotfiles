return {
	"smoka7/hop.nvim",
	config = function()
		require("hop").setup({})
		vim.api.nvim_set_keymap("n", "<Leader>w", ":HopWord<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "<Leader>l", ":HopLine<CR>", { noremap = true })
	end,
}
