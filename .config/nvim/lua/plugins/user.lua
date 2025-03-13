return {
  {
    "2giosangmitom/nightfall.nvim",
    dir = "~/Workspace/nightfall.nvim/",
    opts = {},
  },
  {
    "saghen/blink.cmp",
    opts = {
      keymap = { preset = "super-tab" },
    },
  },
  {
    "stevearc/overseer.nvim",
    opts = {
      templates = { "build_cpp" },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown", "latex", "typst" },
    dependencies = {
      "saghen/blink.cmp",
    },
  },
}
