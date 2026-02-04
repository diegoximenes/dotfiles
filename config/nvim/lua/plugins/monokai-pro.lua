return {
	"loctvl842/monokai-pro.nvim",
	config = function()
		require("monokai-pro").setup({
			filter = "classic",
			override_palette = function(filter)
				return {
					background = "#1c1c1c",
					dimmed3 = "#7c8287", -- related to comments
				}
			end,
		})
		vim.cmd([[colorscheme monokai-pro]])
	end,
}
