return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = "<C-f>",
					next = "<C-r>",
					previous = "<C-e>", -- not working
					suggest = "<C-w>", -- not working
					dismiss = "<C-d>",
				},
			},
		})
	end,
}
