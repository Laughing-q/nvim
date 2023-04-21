local present, nvimtree = pcall(require, "nvim-tree")

if not present then
   return
end

-- globals must be set prior to requiring nvim-tree to function
local g = vim.g

-- g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names
-- g.nvim_tree_git_hl = 1
-- g.nvim_tree_highlight_opened_files = 0
--
-- g.nvim_tree_show_icons = {
--    folders = 1,
--    files = 1,
--    git = 1,
--    folder_arrows = 1,
-- }

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end


  -- Default mappings not inserted as:
  --  remove_keymaps = true
  --  OR
  --  view.mappings.custom_only = true


  -- Mappings migrated from view.mappings.list
  --
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
  vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
  vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
  vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
  vim.keymap.set('n', 'j', api.node.navigate.parent_close, opts('Close Directory'))
  vim.keymap.set('n', '<S-CR>', api.node.navigate.parent_close, opts('Close Directory'))
  vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
  vim.keymap.set('n', 'J', api.node.navigate.sibling.first, opts('First Sibling'))
  vim.keymap.set('n', 'L', api.node.navigate.sibling.last, opts('Last Sibling'))
  vim.keymap.set('n', '<BS>', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
  vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
  vim.keymap.set('n', 'T', api.fs.create, opts('Create'))
  vim.keymap.set('n', 'd', api.fs.cut, opts('Cut'))
  vim.keymap.set('n', 'D', api.fs.remove, opts('Delete'))
  vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
  vim.keymap.set('n', 'c', api.fs.rename_sub, opts('Rename: Omit Filename'))
  vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
  vim.keymap.set('n', 'yy', api.fs.copy.node, opts('Copy'))
  vim.keymap.set('n', 'yn', api.fs.copy.filename, opts('Copy Name'))
  vim.keymap.set('n', 'yp', api.fs.copy.relative_path, opts('Copy Relative Path'))
  vim.keymap.set('n', 'ya', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
  vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
  vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
  vim.keymap.set('n', 'h', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', 's', api.node.run.system, opts('Run System'))
  vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
  vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))

end

g.nvim_tree_icons = {
   default = "",
   symlink = "",
   git = {
      deleted = "",
      ignored = "◌",
      renamed = "➜",
      staged = "✓",
      unmerged = "",
      unstaged = "✗",
      untracked = "★",
   },
   folder = {
      default = "",
      empty = "",
      empty_open = "",
      open = "",
      symlink = "",
      symlink_open = "",
      arrow_open = "",
      arrow_closed = "",
   },
}

local options = {
   filters = {
      dotfiles = true,
      custom = {"__pycache__"},
      exclude = {},
   },
   disable_netrw = true,
   hijack_netrw = true,
   hijack_cursor = true,
   hijack_unnamed_buffer_when_opening = false,
   update_cwd = true,
   update_focused_file = {
      enable = true,
      update_cwd = false,
   },
   view = {
      side = "left",
      width = 30,
   },
   git = {
      enable = true,
      ignore = false,
   },
   diagnostics = {
     enable = false,
   },
   actions = {
      open_file = {
         resize_window = true,
      },
   },
   renderer = {
      indent_markers = {
         enable = false,
      },
      root_folder_label = true,
   },
   on_attach = on_attach
}

nvimtree.setup(options)
