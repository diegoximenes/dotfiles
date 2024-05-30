return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim", "stevearc/aerial.nvim" },
	event = "LspAttach",
	config = function()
		local telescope = require("telescope")

		telescope.setup({
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

		telescope.load_extension("aerial")

		local builtin = require("telescope.builtin")
		local diagnostics = function()
			-- only shows diagnostics for the current file
			return builtin.diagnostics({
				bufnr = 0,
			})
		end

		vim.keymap.set("n", "<C-i>", builtin.lsp_definitions, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-g>", builtin.lsp_type_definitions, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-n>", builtin.lsp_references, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-y>", builtin.lsp_implementations, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-s>", telescope.extensions.aerial.aerial, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-q>", diagnostics, { noremap = true, silent = true })
	end,
}
