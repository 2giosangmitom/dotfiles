return {
  -- {
  --   "2giosangmitom/nightfall.nvim",
  --   dir = "~/Workspace/nightfall.nvim/",
  --   priority = 1000,
  --   opts = {},
  -- },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        denols = {
          mason = false,
        },
        html = {},
        cssls = {},
      },
    },
  },

  {
    "williamboman/mason.nvim",
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

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "nix", "just" } },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        nix = { "nixfmt" },
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.component_separators = { left = "", right = "" }
      opts.options.section_separators = { left = "", right = "" }
    end,
  },

  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
    },
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  {
    "stevearc/overseer.nvim",
    opts = {
      templates = { "builtin", "user.cpp_build", "user.c_build" },
    },
  },
}
