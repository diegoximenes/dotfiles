return {
	"luochen1990/rainbow",
	config = function()
		vim.g.rainbow_active = 1
		vim.g.rainbow_conf = {
			operators = "",
			guifgs = { "white", "darkorange3", "royalblue3", "seagreen3", "firebrick" },
		}
	end,
}
