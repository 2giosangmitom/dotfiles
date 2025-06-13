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
        "vue",
        "typst",
        "c",
        "cpp",
        "markdown",
        "vim",
        "vimdoc",
        "yaml",
        "json",
        "rust",
        "bash",
      })
    end,
  },
}
