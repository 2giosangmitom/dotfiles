return {
  {
    "2giosangmitom/nightfall.nvim",
    dir = "~/Workspace/nightfall.nvim/",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
    config = function(_, opts)
      require("nightfall").setup(opts)
      vim.cmd("colorscheme nightfall")
    end,
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
