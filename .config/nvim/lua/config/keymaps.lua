vim.g.mapleader = " "

vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "Save current buffer" })
vim.keymap.set("n", "<Esc>", "<cmd>nohl<cr>", { desc = "Clear highlights" })
