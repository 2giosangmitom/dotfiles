return {
  {
    "mason-org/mason.nvim",
    keys = {
      { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
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
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInstall", "LspUninstall" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "clangd",
      },
    },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
}
