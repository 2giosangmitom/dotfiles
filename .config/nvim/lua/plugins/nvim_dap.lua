return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<F5>", function() require("dap").continue() end, desc = "Continue" },
    },
    config = function()
      vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("BreakpointRejected", { text = " ", texthl = "DiagnosticError" })
    end,
  },
}
