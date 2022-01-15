local component = require("plugins.configs.heirline.components")
local statusline = { component.Git, component.Align, component.ScrollBar }
require("heirline").setup(statusline)
