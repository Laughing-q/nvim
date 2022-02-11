------------------------------------------------------------------------------------
-- ██╗      █████╗ ██╗   ██╗ ██████╗ ██╗  ██╗██╗███╗   ██╗ ██████╗        ██████╗ --
-- ██║     ██╔══██╗██║   ██║██╔════╝ ██║  ██║██║████╗  ██║██╔════╝       ██╔═══██╗--
-- ██║     ███████║██║   ██║██║  ███╗███████║██║██╔██╗ ██║██║  ███╗█████╗██║   ██║--
-- ██║     ██╔══██║██║   ██║██║   ██║██╔══██║██║██║╚██╗██║██║   ██║╚════╝██║▄▄ ██║--
-- ███████╗██║  ██║╚██████╔╝╚██████╔╝██║  ██║██║██║ ╚████║╚██████╔╝      ╚██████╔╝--
-- ╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝        ╚══▀▀═╝ --
------------------------------------------------------------------------------------

local core_modules = {
	"autocmds",
	"options",
	"mappings",
}
pcall(require, "impatient")

for _, module in ipairs(core_modules) do
	local ok, err = pcall(require, module)
	if not ok then
		error("Error loading " .. module .. "\n\n" .. err)
	end
end

-- colorscheme
local colorscheme = "kanagawa"
-- plugin global settings
require("plugins.configs.global").setup(colorscheme)

local ok, _ = pcall(require, colorscheme)
if ok then
	vim.cmd("colorscheme " .. colorscheme)
end
