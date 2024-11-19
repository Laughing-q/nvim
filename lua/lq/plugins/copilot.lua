return {
	{
		"github/copilot.vim",
		-- cmd = "Copilot",
		lazy = false,
		config = function()
			vim.keymap.set("i", "<C-K>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
			})
			vim.g.copilot_no_tab_map = false
		end,
	},
	{
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			cmd = "CopilotChatOpen",
			branch = "canary",
			dependencies = {
				{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
				{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
			},
			build = "make tiktoken", -- Only on MacOS or Linux
			opts = {
				-- See Configuration section for options
			},
			-- See Commands section for default commands if you want to lazy load on them
		},
	},
}
