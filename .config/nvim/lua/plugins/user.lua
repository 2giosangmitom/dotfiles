return {
  {
    "2giosangmitom/nightfall.nvim",
    dir = "~/Workspace/nightfall.nvim/",
    opts = {},
  },

  {
    "folke/tokyonight.nvim",
    enabled = false,
  },

  {
    "catppuccin",
    enabled = false,
  },

  {
    "stevearc/overseer.nvim",
    opts = {
      templates = { "builtin", "build_cpp", "run_bin" },
    },
  },

  {
    "saghen/blink.cmp",
    opts = {
      keymap = { preset = "super-tab" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
      },
    },
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      preset = "classic",
    },
  },
}
