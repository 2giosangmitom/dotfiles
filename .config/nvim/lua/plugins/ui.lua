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
          -- Mode
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })

          -- Git info
          local git = MiniStatusline.section_git({ trunc_width = 40 })

          -- Diagnostics
          local diagnostics = function()
            local diags = vim.diagnostic.get(0)
            if vim.tbl_isempty(diags) then return "" end

            -- Count diagnostics by severity
            local counts = {}
            for _, d in ipairs(diags) do
              counts[d.severity] = (counts[d.severity] or 0) + 1
            end

            local severity = vim.diagnostic.severity
            local levels = { "ERROR", "WARN", "INFO", "HINT" }

            local signs = {
              ERROR = " ",
              WARN = " ",
              INFO = "󰋼 ",
              HINT = "󰌵 ",
            }

            local hl_groups = {
              ERROR = "%#DiagnosticError#",
              WARN = "%#DiagnosticWarn#",
              INFO = "%#DiagnosticInfo#",
              HINT = "%#DiagnosticHint#",
            }

            local parts = {}
            for _, level in ipairs(levels) do
              local count = counts[severity[level]]
              if count then table.insert(parts, hl_groups[level] .. signs[level] .. count .. "%#StatusLine#") end
            end

            return table.concat(parts, " ")
          end

          -- File info
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })

          -- Search count
          local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

          -- Location
          local location = function()
            local line = vim.fn.line(".")
            local col = vim.fn.charcol(".")
            return string.format("%3d:%-2d", line, col)
          end

          -- DAP status
          local dap_status = function()
            local dap = require("dap")
            if dap.status() == "" then return "" end
            return "  " .. dap.status()
          end

          -- Tabsize
          local tabsize = function() return "󰌒 " .. vim.bo.tabstop end

          -- Diff
          local diff = MiniStatusline.section_diff({ trunc_width = 80, icon = "" })

          -- Filename
          local filename = MiniStatusline.section_filename({ trunc_width = 40 })

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { string.upper(mode) } },
            "%<",
            { hl = mode_hl .. "B", strings = { git } },
            "%<",
            { hl = mode_hl .. "C", strings = { filename } },
            { hl = mode_hl .. "C", strings = { diff } },
            { hl = mode_hl .. "C", strings = { diagnostics() } },
            "%=",
            { hl = mode_hl .. "C", strings = { search } },
            { hl = mode_hl .. "C", strings = { dap_status() } },
            { hl = mode_hl .. "C", strings = { fileinfo } },
            "%<",
            { hl = mode_hl .. "B", strings = { tabsize() } },
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
