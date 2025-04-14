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
    dependencies = {
      "echasnovski/mini-git",
      "echasnovski/mini.diff",
    },
    opts = {
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local diagnostics = MiniStatusline.section_diagnostics({
            trunc_width = 75,
            icon = "",
            signs = { ERROR = " ", WARN = " ", INFO = "󰋼 ", HINT = "󰌵 " },
          })
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
          local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
          local location = function()
            local line = vim.fn.line(".")
            local col = vim.fn.charcol(".")
            return string.format("%3d:%-2d", line, col)
          end
          local dap_status = function()
            local dap = require("dap")
            if dap.status() == "" then return "" end
            return "  " .. dap.status()
          end
          local tabsize = function() return "󰌒 " .. vim.bo.tabstop end
          local diff = vim.b.minidiff_summary_string

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { string.upper(mode) } },
            "%<",
            { hl = "MiniStatuslineB", strings = { git } },
            "%<",
            { hl = "MiniStatuslineC", strings = { diagnostics } },
            { hl = "MiniStatuslineC", strings = { diff } },
            "%=",
            { hl = "MiniStatuslineC", strings = { search } },
            { hl = "MiniStatuslineC", strings = { dap_status() } },
            { hl = "MiniStatuslineC", strings = { fileinfo } },
            "%<",
            { hl = "MiniStatuslineB", strings = { tabsize() } },
            "%<",
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
    keys = {
      { "<leader>e", function() Snacks.explorer() end, desc = "Explorer" },
    },
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
      explorer = { enabled = true },
    },
  },
}
