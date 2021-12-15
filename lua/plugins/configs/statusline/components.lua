local M = {}
-- if show short statusline on small screens
local shortline = true
local lsp = require("feline.providers.lsp")

M.git = {
	git_branch = {
		provider = "git_branch",
		icon = " 🐯 ",
		hl = {
			-- fg = "gray",
			bg = "#3d59a1",
		},
		right_sep = { "block", "slant_right" },
	},

	git_diff_added = {
		provider = "git_diff_added",
		icon = "  ",
		hl = {
			fg = "#45b97c",
		},
	},

	git_diff_changed = {
		provider = "git_diff_changed",
		icon = "  ",
		hl = {
			fg = "#dea32c",
		},
	},
	git_diff_removed = {
		provider = "git_diff_removed",
		icon = "  ",
		hl = {
			fg = "#f15b6c",
		},
	},
}

M.lsp = {
	progress = {
		provider = function()
			local Lsp = vim.lsp.util.get_progress_messages()[1]
			if Lsp then
				local msg = Lsp.message or ""
				local percentage = Lsp.percentage or 0
				local title = Lsp.title or ""
				local spinners = {
					"",
					"",
					"",
				}

				local success_icon = {
					"",
					"",
					"",
				}

				local ms = vim.loop.hrtime() / 1000000
				local frame = math.floor(ms / 120) % #spinners

				if percentage >= 70 then
					return string.format(" %%<%s %s %s (%s%%%%) ", success_icon[frame + 1], title, msg, percentage)
				else
					return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
				end
			end
			return ""
		end,
		enabled = shortline or function(winid)
			return vim.api.nvim_win_get_width(winid) > 80
		end,
		hl = { fg = "green" },
	},

	diagnostic_errors = {
		provider = "diagnostic_errors",
		enabled = function()
			return lsp.diagnostics_exist("Error")
		end,
		icon = "  ",
		hl = {
			fg = "red",
		},
	},

	diagnostic_warnings = {
		provider = "diagnostic_warnings",
		enabled = function()
			return lsp.diagnostics_exist("Warning")
		end,
		icon = "  ",
		hl = {
			fg = "#dea32c",
		},
	},

	diagnostic_hints = {
		provider = "diagnostic_hints",
		enabled = function()
			return lsp.diagnostics_exist("Hint")
		end,
		icon = "  ",
		hl = {
			fg = "#009ad6",
		},
	},

	diagnostic_info = {
		provider = "diagnostic_info",
		enabled = function()
			return lsp.diagnostics_exist("Information")
		end,
		icon = "  ",
		hl = {
			fg = "#009ad6",
		},
	},

	client1 = {
		-- provider = 'lsp_client_names',
		provider = function()
			local clients = {}

			for _, client in pairs(vim.lsp.buf_get_clients(0)) do
				clients[#clients + 1] = client.name
			end

			return table.concat(clients, ","), "🦁"
		end,
		enabled = shortline or function(winid)
			return vim.api.nvim_win_get_width(winid) > 70
		end,
		left_sep = "  ",
		-- right_sep = {
		--   str = 'vertical_bar_thin',
		--   hl = {
		--     fg = 'gray',
		--   }
		-- },
		hl = {
			fg = "gray",
		},
	},

	client2 = {
		provider = function()
			if next(vim.lsp.buf_get_clients()) ~= nil then
				return "🦁 LSP "
			else
				return ""
			end
		end,
		enabled = shortline or function(winid)
			return vim.api.nvim_win_get_width(winid) > 70
		end,
		left_sep = " ",
		-- right_sep = {
		--   str = 'vertical_bar_thin',
		--   hl = {
		--     fg = 'gray',
		--   }
		-- },
		hl = {
			fg = "gray",
		},
	},
}

M.info = {
	icon1 = {
		provider = " 🐻 ",
		enabled = shortline or function(winid)
			return vim.api.nvim_win_get_width(winid) > 90
		end,
		hl = {
			-- fg = "gray",
			bg = "#3d59a1",
		},
		left_sep = "slant_left",
	},

	file_encoding = {
		provider = "file_encoding",
		-- hl = {
		--    fg = "gray",
		-- },
		hl = {
			-- fg = "gray",
			bg = "#3d59a1",
		},
		right_sep = "block",
	},
	icon2 = {
		provider = " 🐨",
		enabled = shortline or function(winid)
			return vim.api.nvim_win_get_width(winid) > 90
		end,
		hl = {
			-- fg = "gray",
			bg = "#3d59a1",
		},
		left_sep = "slant_left",
	},

	position = {
		provider = "position",
		hl = {
			-- fg = "gray",
			bg = "#3d59a1",
		},
	},

	icon3 = {
		provider = "🐼",
		enabled = shortline or function(winid)
			return vim.api.nvim_win_get_width(winid) > 90
		end,
		hl = {
			-- fg = "gray",
			bg = "#3d59a1",
		},
	},

	position_percent = {
		provider = function()
			local current_line = vim.fn.line(".")
			local total_line = vim.fn.line("$")

			if current_line == 1 then
				return " Top "
			elseif current_line == vim.fn.line("$") then
				return " Bot "
			end
			local result, _ = math.modf((current_line / total_line) * 100)
			return " " .. result .. "%% "
		end,

		enabled = shortline or function(winid)
			return vim.api.nvim_win_get_width(winid) > 90
		end,
		hl = {
			-- fg = "gray",
			bg = "#3d59a1",
		},
	},
}

M.python = {
	provider = function()
		local utils = require("plugins.configs.statusline.utils")
		if vim.bo.filetype == "python" then
			local venv = os.getenv("CONDA_DEFAULT_ENV")
			if venv then
				return string.format(" 🍀(%s)", utils.env_cleanup(venv))
			end
			venv = os.getenv("VIRTUAL_ENV")
			if venv then
				return string.format(" 🍀(%s)", utils.env_cleanup(venv))
			end
			return ""
		end
		return ""
	end,

	hl = {
		fg = "green",
	},
}

return M