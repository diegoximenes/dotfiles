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
		local definitions = function()
			-- only shows file path, do not show file content in results pane
			return builtin.lsp_definitions({
				show_line = false,
			})
		end
		local type_definitions = function()
			-- only shows file path, do not show file content in results pane
			return builtin.lsp_type_definitions({
				show_line = false,
			})
		end
		local references = function()
			-- only shows file path, do not show file content in results pane
			return builtin.lsp_references({
				show_line = false,
			})
		end
		local implementations = function()
			-- only shows file path, do not show file content in results pane
			return builtin.lsp_implementations({
				show_line = false,
			})
		end

		vim.keymap.set("n", "<C-i>", definitions, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-g>", type_definitions, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-n>", references, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-y>", implementations, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-q>", diagnostics, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-s>", telescope.extensions.aerial.aerial, { noremap = true, silent = true })
	end,
}
