------------------------------------------------------------------------------------
-- ██╗      █████╗ ██╗   ██╗ ██████╗ ██╗  ██╗██╗███╗   ██╗ ██████╗        ██████╗ --
-- ██║     ██╔══██╗██║   ██║██╔════╝ ██║  ██║██║████╗  ██║██╔════╝       ██╔═══██╗--
-- ██║     ███████║██║   ██║██║  ███╗███████║██║██╔██╗ ██║██║  ███╗█████╗██║   ██║--
-- ██║     ██╔══██║██║   ██║██║   ██║██╔══██║██║██║╚██╗██║██║   ██║╚════╝██║▄▄ ██║--
-- ███████╗██║  ██║╚██████╔╝╚██████╔╝██║  ██║██║██║ ╚████║╚██████╔╝      ╚██████╔╝--
-- ╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝        ╚══▀▀═╝ --
------------------------------------------------------------------------------------

vim.g.mapleader = " "
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ import = "lq/plugins" }, {
	defaults = { lazy = true },
})

-- colorscheme
local colorscheme = "kanagawa"
local ok, _ = pcall(require, colorscheme)
if ok then
	vim.cmd("colorscheme " .. colorscheme)
end
