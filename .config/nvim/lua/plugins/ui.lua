return {
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },
  {
    "echasnovski/mini.tabline",
    event = { "BufNewFile", "BufReadPost" },
    dependencies = { "echasnovski/mini.icons" },
    opts = {},
  },
  {
    "echasnovski/mini.statusline",
    event = "VeryLazy",
    opts = {
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local location = function()
            local line = vim.fn.line(".")
            local col = vim.fn.charcol(".")
            return string.format("%3d:%-2d", line, col)
          end

          return MiniStatusline.combine_groups({
            { hl = mode_hl,                  strings = { string.upper(mode) } },
            "%<",
            { hl = "MiniStatuslineFilename", strings = { vim.fn.expand("%:t") } },
            "%=",
            { hl = mode_hl, strings = { location() } },
          })
        end,
      },
    },
  },
  {
    "echasnovski/mini.icons",
    opts = {},
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      quickfile = { enabled = true },
    },
  },
}
