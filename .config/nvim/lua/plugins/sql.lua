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
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sql = { "sqruff" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sql = { "sqruff" },
      },
      formatters = {
        sqruff = {
          args = { "fix", "--force", "-" },
          require_cwd = false,
        },
      },
    },
  },
}
