return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("telescope").setup({
			defaults = {
				dynamic_preview_title = true,
				layout_strategy = "vertical",
				layout_config = {
					vertical = {
						preview_cutoff = 0,
					},
				},
			},
		})
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<C-i>", builtin.lsp_definitions, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-g>", builtin.lsp_type_definitions, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-n>", builtin.lsp_references, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-y>", builtin.lsp_implementations, { noremap = true, silent = true })
	end,
}
