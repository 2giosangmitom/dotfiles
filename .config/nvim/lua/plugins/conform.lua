return {
  "stevearc/conform.nvim",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cf",
      function() require("conform").format({ lsp_format = "fallback" }) end,
      desc = "Format code",
    },
  },
  dependencies = {
    "mason-org/mason.nvim",
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      markdown = { "prettierd" },
      html = { "prettierd" },
      css = { "prettierd" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      sql = { "sqruff" },
    },
  },
}
