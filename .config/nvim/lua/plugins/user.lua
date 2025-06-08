return {
  {
    "2giosangmitom/nightfall.nvim",
    dir = "~/Workspace/nightfall.nvim/",
    opts = {
      transparent = true,
      dim_inactive = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nightfall",
    },
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
      },
    },
  },
  {
    "mikavilpas/yazi.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    keys = {
      {
        "-",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
    },
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
  },
  {
    "vyfor/cord.nvim",
    build = ":Cord update",
    event = "VeryLazy",
    opts = {},
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_pending = " ",
          package_installed = " ",
          package_uninstalled = " ",
        },
      },
    },
  },
}
