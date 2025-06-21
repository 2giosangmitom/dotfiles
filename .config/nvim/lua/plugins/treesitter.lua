return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "lua",
        "javascript",
        "typescript",
        "vue",
        "typst",
        "c",
        "cpp",
        "markdown",
        "markdown_inline",
        "vim",
        "vimdoc",
        "yaml",
        "json",
        "rust",
        "bash",
        "python",
        "css",
        "scss",
        "html",
        "cmake",
      })
    end,
  },
}
