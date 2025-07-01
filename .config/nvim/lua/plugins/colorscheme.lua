return {
  {
    "2giosangmitom/nightfall.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
    },
    config = function(_, opts)
      require("nightfall").setup(opts)
      vim.cmd("colorscheme nightfall")
    end,
  },
}
