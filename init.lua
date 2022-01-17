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

-- plugin global settings
require("plugins.configs.global").setup()
-- colorscheme
local colorscheme = "kanagawa"
-- set barbar highlight for kanagawa
if colorscheme == "kanagawa"  then
  vim.api.nvim_exec(
    [[
    hi BufferCurrent guibg=#363646
    hi BufferCurrentSign guibg=#363646
    hi BufferCurrentMod guibg=#363646
    hi BufferCurrentMod guifg=#E5AB0E
  ]],
    false
  )
end

local ok, _ = pcall(require, colorscheme)
if ok then
	vim.cmd("colorscheme " .. colorscheme)
end
-- vim.notify("this is a test")
-- vim.lsp.set_log_level("debug")

