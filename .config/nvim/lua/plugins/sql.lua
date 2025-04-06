vim.lsp.config.sqruff = {
  cmd = { "sqruff", "lsp" },
  filetypes = { "sql" },
}

vim.lsp.enable({ "sqruff" })

return {
  {
    "kndndrj/nvim-dbee",
    cmd = "Dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      require("dbee").install("curl")
    end,
    opts = {},
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "sqruff" },
    },
  },
}
