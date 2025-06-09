-- Set leader key to <Space>
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

-- Save current buffer
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save current buffer", silent = true, remap = true })

-- Lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy", silent = true, remap = true })

-- Clear search highlights
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear highlights", silent = true, remap = true })
