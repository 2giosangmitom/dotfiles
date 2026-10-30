vim.pack.add({
	{ src = "https://github.com/smart-splits-nvim/smart-splits.nvim" },
})

local smart_splits = require("smart-splits")
smart_splits.setup()

-- Move between windows
vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Go to right window" })

-- Resize windows (accepts a count, e.g. 10<C-Left>)
vim.keymap.set("n", "<C-Left>", smart_splits.resize_left, { desc = "Resize window left" })
vim.keymap.set("n", "<C-Down>", smart_splits.resize_down, { desc = "Resize window down" })
vim.keymap.set("n", "<C-Up>", smart_splits.resize_up, { desc = "Resize window up" })
vim.keymap.set("n", "<C-Right>", smart_splits.resize_right, { desc = "Resize window right" })

-- Swap buffers between windows
vim.keymap.set("n", "<leader><leader>h", smart_splits.swap_buf_left, { desc = "Swap buffer left" })
vim.keymap.set("n", "<leader><leader>j", smart_splits.swap_buf_down, { desc = "Swap buffer down" })
vim.keymap.set("n", "<leader><leader>k", smart_splits.swap_buf_up, { desc = "Swap buffer up" })
vim.keymap.set("n", "<leader><leader>l", smart_splits.swap_buf_right, { desc = "Swap buffer right" })
