return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		{ "nvim-telescope/telescope-ui-select.nvim" },
	},
	build = "make tiktoken", -- Only on MacOS or Linux
	opts = {
		model = "claude-3.7-sonnet",
		sticky = "#buffer",
	},
	keys = {
		{ "<leader>c", "<cmd>CopilotChatOpen<cr>", mode = "n", desc = "Open Copilot Chat" },
		{ "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "Explain Code with Copilot Chat" },
		{ "<leader>cc", "<cmd>CopilotChatReview<cr>", mode = "v", desc = "Review Code with Copilot Chat" },
		{ "<leader>cf", "<cmd>CopilotChatFix<cr>", mode = "v", desc = "Fix Code with Copilot Chat" },
		{ "<leader>cr", "<cmd>CopilotChatRefactor<cr>", mode = "v", desc = "Refactor Code with Copilot Chat" },
		{ "<leader>cd", "<cmd>CopilotChatDoc<cr>", mode = "v", desc = "Document Code with Copilot Chat" },
	},
}
