vim.pack.add({
  { src = "https://github.com/ibhagwan/fzf-lua" },
})

vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "Live grep" })
