-- Set leader key to <Space>
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

-- Save current buffer
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save current buffer", silent = true, remap = true })

-- Lazy
map("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "Lazy", silent = true, remap = true })

-- Clear search highlights
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear highlights", silent = true, remap = true })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Quick fix
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quick fix" })
