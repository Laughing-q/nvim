local M = {}

M.status = {
  plenary = true,
  filetype = true,
  devicons = true,
  blankline = true,
  treesitter = true,
  gitsigns = true,

  -- statueline
  feline = false,
  heirline = true,
  -- lsp stuff
  lspconfig = true,
  lspinstaller = true,
  null_ls = false,

  -- TODO: remove it or config it
  -- matchup = true,
  cmp = true,
  autopairs = true,
  dashboard = false,
  comment = true,
  nvimtree = false,
  lf = true,
  -- telescope stuff
  telescope = true,
  fzf = true,
  project = true,
  -- colorscheme
  tokyonight = true,
  kanagawa = true,

  -- bufferline
  bufferline = false,

  which_key = true,
  terminal = true,
  antovim = true,
  colorizer = true,
  undotree = true,
  aerial = false,
  wildfire = true,
  surround = true,
  rnvimr = false,
  -- markdown stuff
  markdown_preview = true,
  table_mode = true,
  markdown_toc = true,
  bullets = true,

  vimtex = true,
  flash = false,
  scrollview = true,
  dap = false,
  suda = true,
}

return M
