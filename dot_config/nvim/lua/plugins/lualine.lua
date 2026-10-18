vim.pack.add({
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
})

require("lualine").setup({
  options = {
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { statusline = { "NvimTree" } },
  },
})
