local M = {}

M.status = {
  -- probably switch it back, keep it for a while.
  aerial = false,

  plenary = true,
  filetype = true,
  devicons = true,
  blankline = true,
  treesitter = true,
  gitsigns = true,

  -- statueline
  heirline = true,
  -- lsp stuff
  lspconfig = true,
  lspinstaller = true,

  -- TODO: remove it or config it
  -- matchup = true,
  cmp = true,
  autopairs = true,
  comment = true,
  lf = true,
  -- telescope stuff
  telescope = true,
  fzf = true,
  project = true,
  -- colorscheme
  tokyonight = true,
  kanagawa = true,

  which_key = true,
  terminal = true,
  antovim = true,
  colorizer = true,
  undotree = true,
  wildfire = true,
  surround = true,
  -- markdown stuff
  markdown_preview = true,
  table_mode = true,
  markdown_toc = true,
  bullets = true,

  vimtex = true,
  scrollview = true,
  suda = true,
}

return M
