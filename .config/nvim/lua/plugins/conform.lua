return {
  "stevearc/conform.nvim",
  cmd = "ConformInfo",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      markdown = { "prettierd" },
    },
  },
  dependencies = {
    "mason-org/mason.nvim",
  },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ lsp_format = "fallback" })
      end,
      desc = "Format code",
    },
  },
}
