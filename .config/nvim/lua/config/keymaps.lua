-- Use <space> as leader key
vim.g.mapleader = " "

local map = vim.keymap.set

-- lazy.nvim keymaps
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "lazy.nvim" })

-- Buffers management
map("n", "<S-h>", "<cmd>bprev<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Save
map("n", "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Clear highlights
map("n", "<esc>", "<cmd>nohl<cr>", { desc = "Clear search highlights" })
