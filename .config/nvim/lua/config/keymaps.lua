-- Use <space> as leader key
vim.g.mapleader = " "

local map = vim.keymap.set

-- lazy.nvim keymaps
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "lazy.nvim" })

-- Buffers management
map("n", "<S-h>", "<cmd>bprev<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Save
map("n", "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Clear highlights
map("n", "<esc>", "<cmd>nohl<cr>", { desc = "Clear search highlights" })

-- Terminal
map("t", "<esc>", "<C-\\><C-n>", { desc = "Back to normal mode" })

-- Window management
map("n", "<C-h>", "<C-w>h", { desc = "Switch to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch to below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch to above window" })
