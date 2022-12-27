local treesitter_opts = {
	ensure_installed = { "help", "python", "c", "cpp", "cmake", "make", "cuda", "dockerfile", "lua", "vim", "bash", "yaml", "bibtex", "latex", "markdown" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	ignore_install = {},
	highlight = {
		enable = true, -- false will disable the whole extension
		additional_vim_regex_highlighting = true,
		use_languagetree = true,
		-- disable = { "latex" },
	},

  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ha'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['hf'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['hc'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']]'] = '@function.outer',
        [']c'] = '@class.outer',
      },
      goto_next_end = {
        [']['] = '@function.outer',
        [']C'] = '@class.outer',
      },
      goto_previous_start = {
        ['[['] = '@function.outer',
        ['[c'] = '@class.outer',
      },
      goto_previous_end = {
        ['[]'] = '@function.outer',
        ['[C'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

treesitter_configs.setup(treesitter_opts)
