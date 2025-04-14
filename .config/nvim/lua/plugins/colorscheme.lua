return {
  {
    "2giosangmitom/nightfall.nvim",
    dir = "~/Workspace/nightfall.nvim/",
    lazy = false,
    priority = 1000,
    opts = {
      integrations = {
        fzf = { style = "borderless" },
      },
      highlight_overrides = {
        nightfall = function(colors)
          local utils = require("nightfall.utils.colors")

          return {
            MiniStatuslineModeNormal = { fg = colors.black, bg = colors.purple },
            MiniStatuslineModeInsert = { fg = colors.black, bg = colors.green },
            MiniStatuslineModeVisual = { fg = colors.black, bg = colors.blue },
            MiniStatuslineModeCommand = { fg = colors.black, bg = colors.cream },
            MiniStatuslineModeReplace = { fg = colors.black, bg = colors.coral },
            MiniStatuslineModeOther = { fg = colors.black, bg = colors.cyan },

            MiniStatuslineModeNormalB = { fg = colors.purple, bg = utils.lighten(colors.navy, 0.9) },
            MiniStatuslineModeInsertB = { fg = colors.green, bg = utils.lighten(colors.navy, 0.9) },
            MiniStatuslineModeVisualB = { fg = colors.blue, bg = utils.lighten(colors.navy, 0.9) },
            MiniStatuslineModeCommandB = { fg = colors.cream, bg = utils.lighten(colors.navy, 0.9) },
            MiniStatuslineModeReplaceB = { fg = colors.coral, bg = utils.lighten(colors.navy, 0.9) },
            MiniStatuslineModeOtherB = { fg = colors.cyan, bg = utils.lighten(colors.navy, 0.9) },
          }
        end,
      },
    },
    config = function(_, opts)
      require("nightfall").setup(opts)
      vim.cmd("colorscheme nightfall")
    end,
  },
}
