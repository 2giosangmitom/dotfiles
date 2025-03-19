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
      ensure_installed = { "sqlfluff" },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sql = { "sqlfluff" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sql = { "sqlfluff" },
      },
      formatters = {
        sqlfluff = {
          args = { "fix", "--dialect=ansi", "-" },
          require_cwd = false,
        },
      },
    },
  },
}
