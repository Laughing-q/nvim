return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		config = function()
			require("lq.configs.cmp")
		end,
		dependencies = {
			{
				-- snippet plugin
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				config = function()
					require("luasnip").config.set_config({
						history = true,
						updateevents = "TextChanged,TextChangedI",
					})

					require("luasnip/loaders/from_vscode").lazy_load()
					require("luasnip/loaders/from_vscode").lazy_load({
						paths = { "~/codes/ultralytics-snippets/" },
						include = { "python" },
					})
				end,
			},

			-- cmp sources plugins
			{
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
			},
		},
	},
}
