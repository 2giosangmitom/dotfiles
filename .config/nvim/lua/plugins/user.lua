return {
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          settings = {
            formatterMode = "typstyle",
          },
        },
      },
    },
  },
}
