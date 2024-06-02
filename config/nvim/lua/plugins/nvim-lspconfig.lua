local function readDictionaryFile(file)
	local dict = {}
	for line in io.lines(file) do
		table.insert(dict, line)
	end
	return dict
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local opts = { noremap = true, silent = true }
		vim.keymap.set("n", "<C-q>", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
		vim.keymap.set("n", "<C-[>", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
		vim.keymap.set("n", "<C-]>", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

		local on_attach = function(_, bufnr)
			-- Enable completion triggered by <c-x><c-o>
			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

			vim.keymap.set("n", "<C-b>", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
			vim.keymap.set("n", "<C-f>", "<cmd>lua vim.lsp.buf.format{ async = true }<CR>", opts)
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		capabilities["offsetEncoding"] = "utf-16"

		local flags = {
			debounce_text_changes = 150,
		}

		local lspconfig = require("lspconfig")

		local lsps_with_default_config = {
			"gopls",
			"jsonls",
			"tsserver",
			"metals",
			"yamlls",
			"vimls",
			"dockerls",
			"solidity_ls",
			"terraformls",
			"tflint", -- it does not search for .tflint.hcl in parent directories
			"golangci_lint_ls",
			"sqlls",
			"bufls",
			"marksman",
			"ruff_lsp", -- when it is fixed use "ruff" instead of "ruff_lsp" in the future
		}
		for _, lsp in ipairs(lsps_with_default_config) do
			lspconfig[lsp].setup({
				on_attach = on_attach,
				flags = flags,
				capabilities = capabilities,
			})
		end

		lspconfig["clangd"].setup({
			on_attach = on_attach,
			flags = flags,
			capabilities = capabilities,
			filetypes = {
				"c",
				"cpp",
				"objc",
				"objcpp",
				"cuda",
			},
		})

		lspconfig["ltex"].setup({
			on_attach = on_attach,
			flags = flags,
			capabilities = capabilities,
			filetypes = {
				"gitcommit",
				"markdown",
				"plaintex",
				"tex",
				"en_us",
			},
			settings = {
				ltex = {
					language = "en-US",
					dictionary = {
						["en-US"] = readDictionaryFile(vim.env.HOME .. "/.config/nvim/spell/en.utf-8.add"),
					},
				},
			},
		})

		lspconfig["lua_ls"].setup({
			on_init = function(client)
				local path = client.workspace_folders[1].name
				if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
					return
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							-- Depending on the usage, you might want to add additional paths here.
							-- "${3rd}/luv/library"
							-- "${3rd}/busted/library",
						},
						-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
						-- library = vim.api.nvim_get_runtime_file("", true)
					},
				})
			end,
			settings = {
				Lua = {},
			},
		})

		lspconfig["diagnosticls"].setup({
			on_attach = on_attach,
			flags = flags,
			capabilities = capabilities,

			filetypes = {
				"sh",
				"markdown",
			},
			init_options = {
				filetypes = {
					sh = "shellcheck",
					markdown = "markdownlint",
				},
				formatFiletypes = {
					sh = "shfmt",
					markdown = "prettier",
				},
				linters = {
					markdownlint = {
						command = "markdownlint",
						isStderr = true,
						debounce = 100,
						args = {
							"--stdin",
							"--disable",
							"MD013",
						},
						offsetLine = 0,
						offsetColumn = 0,
						sourceName = "markdownlint",
						securities = {
							undefined = "warning",
						},
						formatLines = 1,
						formatPattern = {
							"^stdin:(\\d+)(?:\\s|:(\\d+)\\s)(.*)$",
							{
								line = 1,
								column = 2,
								message = 3,
							},
						},
					},
					shellcheck = {
						command = "shellcheck",
						debounce = 100,
						args = {
							"--format=gcc",
							"-",
						},
						offsetLine = 0,
						offsetColumn = 0,
						sourceName = "shellcheck",
						formatLines = 1,
						formatPattern = {
							"^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
							{
								line = 1,
								column = 2,
								message = 4,
								security = 3,
							},
						},
						securities = {
							error = "error",
							warning = "warning",
							note = "info",
						},
					},
				},
				formatters = {
					prettier = {
						command = "prettier",
						args = {
							"--stdin-filepath",
							"%filepath",
						},
					},
					shfmt = {
						command = "shfmt",
						args = {
							"-i",
							"2",
							"-bn",
							"-ci",
							"-sr",
						},
					},
				},
			},
		})
	end,
}
