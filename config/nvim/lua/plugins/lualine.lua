return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "powerline",
			},
			sections = {
				lualine_b = { "diff", "diagnostics" },
				lualine_c = {
					{
						"filename",
						path = 3,
					},
				},
				lualine_x = { "filetype" },
			},
		})
	end,
}
