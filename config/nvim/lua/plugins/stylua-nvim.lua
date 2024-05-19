return {
	"ckipp01/stylua-nvim",
	config = function()
		require("stylua-nvim").setup({})
		vim.keymap.set("n", "<C-f>", ':lua require("stylua-nvim").format_file()<CR>', { silent = true })
	end,
}
