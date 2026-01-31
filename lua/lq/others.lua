-- plugins here are not used
return {
	{
		"stevearc/aerial.nvim",
		cmd = "AerialToggle",
		config = function()
			require("lq.configs.aerial")
		end,
	},
}
