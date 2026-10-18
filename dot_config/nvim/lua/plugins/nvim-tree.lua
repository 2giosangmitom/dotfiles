vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("plugins.mini-icons")

vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-tree.lua" },
})

require("nvim-tree").setup({})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
