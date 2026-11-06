local map = vim.keymap.set

-- Clear search highlight on <Esc>
map({ "n", "i", "s" }, "<Esc>", function()
	vim.cmd("nohlsearch")
	return "<Esc>"
end, { expr = true, desc = "Escape and clear search highlight" })

-- Indent and keep the selection, so it can be repeated
map("x", "<", "<gv", { desc = "Indent left" })
map("x", ">", ">gv", { desc = "Indent right" })
map("x", "<Tab>", ">gv", { desc = "Indent right" })
map("x", "<S-Tab>", "<gv", { desc = "Indent left" })

-- Move lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<CR>==", { desc = "Move line up" })
map("i", "<A-j>", "<Esc><cmd>move .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc><cmd>move .-2<CR>==gi", { desc = "Move line up" })
map("x", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", { desc = "Move selection down" })
map("x", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", { desc = "Move selection up" })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>edit #<CR>", { desc = "Switch to alternate buffer" })
map("n", "<leader>bo", function()
	local current = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current and vim.bo[buf].buflisted and not vim.bo[buf].modified then
			vim.api.nvim_buf_delete(buf, {})
		end
	end
end, { desc = "Delete other buffers" })
