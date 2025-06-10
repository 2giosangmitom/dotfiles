return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    opts = {},
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
      require("nvim-treesitter").install({
        "lua",
        "javascript",
        "typescript",
        "c",
        "cpp",
        "markdown",
        "vim",
        "vimdoc",
      })
    end,
  },
}
