local present, mason = pcall(require, "mason")

if not present then
  return
end

local options = {
  -- ensure_installed is not needed as automatic_installation is enabled
  -- then any lsp package you setup by lspconfig is going to get installed automatically!

  -- ensure_installed = { "lua" },
  automatic_installation = true,

  ui = {
    icons = {
      package_installed = " ",
      package_pending = " ",
      package_uninstalled = " 󰚌",
    },
    keymaps = {
      toggle_package_expand = "<CR>",
      install_package = "I",
      update_package = "u",
      check_package_version = "c",
      update_all_packages = "U",
      check_outdated_packages = "C",
      uninstall_package = "X",
    },
  },

  max_concurrent_installers = 10,
}

mason.setup(options)
