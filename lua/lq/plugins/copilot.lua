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
			branch = "canary",
			dependencies = {
				{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
				{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
			},
			build = "make tiktoken", -- Only on MacOS or Linux
			opts = {
				debug = false, -- Enable debug logging (same as 'log_level = 'debug')
				log_level = "info", -- Log level to use, 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
				proxy = nil, -- [protocol://]host[:port] Use this proxy
				allow_insecure = false, -- Allow insecure server connections

				model = "gpt-4o", -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).
				agent = "copilot", -- Default agent to use, see ':CopilotChatAgents' for available agents (can be specified manually in prompt via @).
				context = nil, -- Default context to use (can be specified manually in prompt via #).
				temperature = 0.1, -- GPT result temperature

				question_header = "## User ", -- Header to use for user questions
				answer_header = "## Copilot ", -- Header to use for AI answers
				error_header = "## Error ", -- Header to use for errors
				separator = "───", -- Separator to use in chat

				chat_autocomplete = true, -- Enable chat autocompletion (when disabled, requires manual `mappings.complete` trigger)
				show_folds = true, -- Shows folds for sections in chat
				show_help = true, -- Shows help message as virtual lines when waiting for user input
				auto_follow_cursor = true, -- Auto-follow cursor in chat
				auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
				insert_at_end = false, -- Move cursor to end of buffer when inserting text
				clear_chat_on_new_prompt = false, -- Clears chat on every new prompt
				highlight_selection = true, -- Highlight selection in the source buffer when in the chat window
				highlight_headers = true, -- Highlight headers in chat, disable if using markdown renderers (like render-markdown.nvim)

				history_path = vim.fn.stdpath("data") .. "/copilotchat_history", -- Default path to stored history
				callback = nil, -- Callback to use when ask response is received
				no_chat = false, -- Do not write to chat buffer and use chat history (useful for using callback for custom processing)

				-- default prompts
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
						prompt = "> /COPILOT_GENERATE\n\nPlease add documentation comments to the selected code.",
					},
					Tests = {
						prompt = "> /COPILOT_GENERATE\n\nPlease generate tests for my code.",
					},
					Commit = {
						prompt = "> #git:staged\n\nWrite commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
					},
				},
				selection = function(source)
          local select = require("CopilotChat.select")
					return select.visual(source) or select.line(source)
				end,

				-- default window options
				window = {
					layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace'
					width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
					height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
					-- Options below only apply to floating windows
					relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
					border = "single", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
					row = nil, -- row position of the window, default is centered
					col = nil, -- column position of the window, default is centered
					title = "Copilot Chat", -- title of chat window
					footer = nil, -- footer of chat window
					zindex = 1, -- determines if window is on top or below other floating windows
				},

				-- default mappings
				mappings = {
					complete = {
						insert = "<C-k>",
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
