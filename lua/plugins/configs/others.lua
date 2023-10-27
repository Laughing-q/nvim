local M = {}

M.autopairs = function()
	local present1, autopairs = pcall(require, "nvim-autopairs")
	local present2, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")

	if not (present1 or present2) then
		return
	end

	autopairs.setup({
		ignored_next_char = string.gsub([[ [%w%%%[%.] ]], "%s+", ""),
	})

	local Rule = require("nvim-autopairs.rule")
	local npairs = require("nvim-autopairs")
	local cond = require("nvim-autopairs.conds")
	npairs.add_rule(Rule("**", "**", "markdown"))
	npairs.add_rule(Rule("$", "$", "tex"))
	npairs.add_rules(
		{
			Rule("'", "'", "python"):with_pair(cond.before_text_check("f")),
		}
		-- Rule("$", "$", 'tex')
		-- Rule("**", "**", "markdown")
	)
	-- not needed if you disable cmp, the above var related to cmp tooo! override default config for autopairs
	local cmp = require("cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

M.blankline = function()
	require("ibl").setup({
		indent = { char = "|" },
		enabled = true,
		exclude = {
			filetypes = {
				"help",
				"terminal",
				"dashboard",
				"packer",
				"lspinfo",
				"TelescopePrompt",
				"TelescopeResults",
			},
			buftypes = { "terminal" },
		},
		whitespace = {
			remove_blankline_trail = true,
		},
	})
end

M.colorizer = function()
	local present, colorizer = pcall(require, "colorizer")
	if present then
		colorizer.setup({ "*" }, {
			RGB = true, -- #RGB hex codes
			RRGGBB = true, -- #RRGGBB hex codes
			names = false, -- "Name" codes like Blue
			RRGGBBAA = false, -- #RRGGBBAA hex codes
			rgb_fn = false, -- CSS rgb() and rgba() functions
			hsl_fn = false, -- CSS hsl() and hsla() functions
			css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
			css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn

			-- Available modes: foreground, background
			mode = "background", -- Set the display mode.
		})
		vim.cmd("ColorizerReloadAllBuffers")
	end
end

M.comment = function()
	local present, nvim_comment = pcall(require, "Comment")
	if present then
		nvim_comment.setup({
			---Add a space b/w comment and the line
			padding = true,
			---Whether the cursor should stay at its position
			sticky = true,
			---Lines to be ignored while (un)comment
			ignore = nil,
			---LHS of toggle mappings in NORMAL mode
			toggler = {
				---Line-comment toggle keymap
				line = "<leader>c",
				---Block-comment toggle keymap
				block = "gbc",
			},
			---LHS of operator-pending mappings in NORMAL and VISUAL mode
			opleader = {
				---Line-comment keymap
				line = "<leader>c",
				---Block-comment keymap
				block = "gb",
			},
			---LHS of extra mappings
			extra = {
				---Add comment on the line above
				above = "gcO",
				---Add comment on the line below
				below = "gco",
				---Add comment at the end of line
				eol = "gcA",
			},
			---Enable keybindings
			---NOTE: If given `false` then the plugin won't create any mappings
			mappings = {
				---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
				basic = true,
				---Extra mapping; `gco`, `gcO`, `gcA`
				extra = false,
				---Extended mapping; `g>` `g<` `g>[count]{motion}` `g<[count]{motion}`
				extended = false,
			},
			---Function to call before (un)comment
			pre_hook = nil,
			---Function to call after (un)comment
			post_hook = nil,
		})
	end
end

M.luasnip = function()
	local present, luasnip = pcall(require, "luasnip")
	if not present then
		return
	end

	luasnip.config.set_config({
		history = true,
		updateevents = "TextChanged,TextChangedI",
	})

	require("luasnip/loaders/from_vscode").load({ paths = {} })
	require("luasnip/loaders/from_vscode").load()
end

M.scrollview = function()
	require("scrollview").setup({
		-- excluded_filetypes = { "nerdtree" },
		current_only = true,
		winblend = 75,
		base = "right",
		-- column = 80,
		signs_on_startup = { "search" }, -- search, diagnostic
		-- diagnostics_severities = { vim.diagnostic.severity.ERROR },
		search_symbol = "-",
	})
end

return M
