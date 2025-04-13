return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
      cmdline = { enabled = false },
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = true },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ timeout_ms = 500, lsp_format = "fallback" }) end,
        desc = "Format",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = { "igorlfs/nvim-dap-view", "williamboman/mason.nvim" },
    keys = {
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
        desc = "Breakpoint Condition",
      },
      {
        "<leader>db",
        function() require("dap").toggle_breakpoint() end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function() require("dap").continue() end,
        desc = "Run/Continue",
      },
      {
        "<leader>da",
        function() require("dap").continue({ before = vim.fn.input("Run with args") }) end,
        desc = "Run with Args",
      },
      {
        "<leader>dC",
        function() require("dap").run_to_cursor() end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dg",
        function() require("dap").goto_() end,
        desc = "Go to Line (No Execute)",
      },
      {
        "<leader>di",
        function() require("dap").step_into() end,
        desc = "Step Into",
      },
      {
        "<leader>dj",
        function() require("dap").down() end,
        desc = "Down",
      },
      {
        "<leader>dk",
        function() require("dap").up() end,
        desc = "Up",
      },
      {
        "<leader>dl",
        function() require("dap").run_last() end,
        desc = "Run Last",
      },
      {
        "<leader>do",
        function() require("dap").step_out() end,
        desc = "Step Out",
      },
      {
        "<leader>dO",
        function() require("dap").step_over() end,
        desc = "Step Over",
      },
      {
        "<leader>dP",
        function() require("dap").pause() end,
        desc = "Pause",
      },
      {
        "<leader>dr",
        function() require("dap").repl.toggle() end,
        desc = "Toggle REPL",
      },
      {
        "<leader>ds",
        function() require("dap").session() end,
        desc = "Session",
      },
      {
        "<leader>dt",
        function() require("dap").terminate() end,
        desc = "Terminate",
      },
      {
        "<leader>dw",
        function() require("dap.ui.widgets").hover() end,
        desc = "Widgets",
      },
    },
    config = function()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      local signs = {
        DapBreakpoint = { "", "DiagnosticInfo" },
        DapBreakpointCondition = { "", "DiagnosticInfo" },
        DapBreakpointRejected = { "", "DiagnosticError" },
        DapLogPoint = { "󰛿", "DiagnosticInfo" },
        DapStopped = { "󰁕", "DiagnosticWarn", "DapStoppedLine" },
      }

      for sign, icon in pairs(signs) do
        vim.fn.sign_define(sign, { text = icon[1], texthl = icon[2], linehl = icon[3], numhl = icon[3] })
      end

      -- Config adapters
      local dap = require("dap")
      local dv = require("dap-view")
      dap.listeners.before.attach["dap-view-config"] = function()
        dv.open()
      end
      dap.listeners.before.launch["dap-view-config"] = function()
        dv.open()
      end
      dap.listeners.before.event_terminated["dap-view-config"] = function()
        dv.close()
      end
      dap.listeners.before.event_exited["dap-view-config"] = function()
        dv.close()
      end

      dap.adapters["codelldb"] = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}", },
        },
      }

      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            name = 'LLDB: Launch',
            type = 'codelldb',
            request = 'launch',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            console = 'integratedTerminal',
          },
        }
      end
    end,
  },
  {
    "igorlfs/nvim-dap-view",
    opts = {
      winbar = {
        default_section = "scopes",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        bash = { "bash" },
      }

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          if vim.opt_local.modifiable:get() then lint.try_lint() end
        end,
      })
    end,
  },
}
