return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				ignored_next_char = string.gsub([[ [%w%%%[%.] ]], "%s+", ""),
			})
			local Rule = require("nvim-autopairs.rule")
			local npairs = require("nvim-autopairs")
			local cond = require("nvim-autopairs.conds")
			npairs.add_rules({
				Rule("'", "'", "python"):with_pair(cond.before_text_check("f")),
				Rule("$", "$", "tex"),
				Rule("**", "**", "markdown"),
			})
		end,
	},
}
