return {
	"mbbill/undotree",
	config = function()
		vim.api.nvim_set_keymap("n", "<F7>", ":UndotreeToggle<CR>", { noremap = true })
	end,
}
