return {
	{
		"github/copilot.vim",
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
			event = "VeryLazy",
			branch = "main",
			dependencies = {
				{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
				{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
			},
			build = "make tiktoken", -- Only on MacOS or Linux
			opts = {
				debug = false, -- Enable debug logging (same as 'log_level = 'debug')
				log_level = "info", -- Log level to use, 'trace', 'debug', 'info', 'warn', 'error', 'fatal'copCopilotC-Nvim/CopilotChat.nvio
				proxy = nil, -- [protocol://]host[:port] Use this proxy
				allow_insecure = false, -- Allow insecure server connections

				-- model = "gpt-4o", -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).
        model = "claude-sonnet-4",
				agent = "copilot", -- Default agent to use, see ':CopilotChatAgents' for available agents (can be specified manually in prompt via @).
				context = nil, -- Default context to use (can be specified manually in prompt via #).
				temperature = 0.1, -- GPT result temperature

				question_header = "# Laughing-q ", -- Header to use for user questions
				answer_header = "## Copilot ", -- Header to use for AI answers
				error_header = "## Error ", -- Header to use for errors
				separator = "───", -- Separator to use in chat

				chat_autocomplete = true, -- Enable chat autocompletion (when disabled, requires manual `mappings.complete` trigger)
				auto_insert_mode = true, -- Automatically enter insert mode when opening window and on new prompt
				insert_at_end = false, -- Move cursor to end of buffer when inserting text
				clear_chat_on_new_prompt = false, -- Clears chat on every new prompt

				history_path = vim.fn.stdpath("data") .. "/copilotchat_history", -- Default path to stored history
				callback = nil, -- Callback to use when ask response is received
				no_chat = false, -- Do not write to chat buffer and use chat history (useful for using callback for custom processing)

				selection = function(source)
					local select = require("CopilotChat.select")
					return select.visual(source) or select.line(source)
				end,
				prompts = {
					Explain = {
						prompt = "> /COPILOT_EXPLAIN\n\nWrite an explanation for the selected code as paragraphs of text.",
					},
					Review = {
						prompt = "> /COPILOT_REVIEW\n\nReview the selected code.",
						-- see config.lua for implementation
					},
					Fix = {
						prompt = "> /COPILOT_GENERATE\n\nThere is a problem in this code. Rewrite the code to show it with the bug fixed.",
					},
					Optimize = {
						prompt = "> /COPILOT_GENERATE\n\nOptimize the selected code to improve performance and readability.",
					},
					Docs = {
						prompt = "> /COPILOT_GENERATE\n\nPlease add documentation comments to the selected code, and please use Google-Style docstring if it's a function.",
					},
					Tests = {
						prompt = "> /COPILOT_GENERATE\n\nPlease generate tests for my code.",
					},
					Commit = {
						prompt = "> #git:staged\n\nWrite commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
					},
				},

				-- default mappings
				mappings = {
					complete = {
						insert = "", -- mapping to empty string disables default completion so it reuse the copilot one
					},
					close = {
						normal = "Q",
						insert = "<C-c>",
					},
					reset = {
						normal = "<C-r>",
						insert = "<C-r>",
					},
					submit_prompt = {
						normal = "<CR>",
						insert = "<C-s>",
					},
					-- toggle_sticky = {
					-- 	detail = "Makes line under cursor sticky or deletes sticky line.",
					-- 	normal = "gr",
					-- },
					accept_diff = {
						normal = "<C-y>",
						insert = "<C-y>",
					},
					-- jump_to_diff = {
					-- 	normal = "gj",
					-- },
					-- quickfix_diffs = {
					-- 	normal = "gq",
					-- },
					-- yank_diff = {
					-- 	normal = "gy",
					-- 	register = '"',
					-- },
					-- show_diff = {
					-- 	normal = "gd",
					-- },
					-- show_system_prompt = {
					-- 	normal = "gp",
					-- },
					-- show_user_selection = {
					-- 	normal = "gs",
					-- },
				},
			},
			-- See Commands section for default commands if you want to lazy load on them
		},
	},
}
