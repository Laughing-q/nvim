local component = require("lq.configs.heirline.components")

local statusline = {
	hl = { bg = "#1f2335" },
	component.Git,
	component.Python,
	component.Align,
  component.FileNameBlock,
	component.Align,
	component.Diagnostics,
	component.Space,
	component.Space,
	component.LSP,
	component.Treesitter,
	component.Ruler,
	-- component.ScrollBar,
}
require("heirline").setup({statusline=statusline})
