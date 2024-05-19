return {
	"loctvl842/monokai-pro.nvim",
	config = function()
		require("monokai-pro").setup({
			filter = "classic",
			overridePalette = function(filter)
				return {
					background = "#1c1c1c",
					dimmed3 = "#7c8287", -- related to comments
				}
			end,
		})
		vim.cmd([[colorscheme monokai-pro]])
	end,
}
