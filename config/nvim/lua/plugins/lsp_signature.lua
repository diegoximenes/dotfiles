return {
	"ray-x/lsp_signature.nvim",
	config = function()
		require("lsp_signature").setup({
			doc_lines = 0,
		})
	end
}
