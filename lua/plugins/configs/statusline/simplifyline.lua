-- Initialize the components table
local component = require "plugins.configs.statusline.components"

local components = {
   active = {},
   inactive = {},
}

-- Initialize left, mid and right
table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.active, {})

components.active[1][1] = component.git.git_branch
components.active[1][2] = component.python
-- diffAdded
components.active[1][3] = component.git.git_diff_added
-- diffModfified
components.active[1][4] = component.git.git_diff_changed
-- diffRemove
components.active[1][5] = component.git.git_diff_removed
-- components.active[1][5] = component.python

-- lsp
components.active[2][1] = component.lsp.progress

components.active[3][1] = component.lsp.diagnostic_errors
components.active[3][2] = component.lsp.diagnostic_warnings
components.active[3][3] = component.lsp.diagnostic_hints
components.active[3][4] = component.lsp.diagnostic_info
components.active[3][5] = component.lsp.client1

-- info
-- components.active[3][6] = component.info.icon1
-- components.active[3][7] = component.info.file_encoding
components.active[3][6] = component.info.icon2
components.active[3][7] = component.info.position
components.active[3][8] = component.info.icon3

components.active[3][9] = component.info.position_percent

require("feline").setup {
   colors = {
      bg = "#1f2335",
   },
   components = components,
}
