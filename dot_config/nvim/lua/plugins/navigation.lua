-- Moving around: pickers, file explorer, windows and buffers.

-- Fuzzy finder
do
	vim.pack.add({
		{ src = "https://github.com/ibhagwan/fzf-lua" },
	})

	local fzf = require("fzf-lua")

	fzf.setup({
		"border-fused", -- One rounded frame around the list and preview
		fzf_colors = true, -- Derive fzf colors from the colorscheme
		defaults = {
			file_icons = "mini",
			git_icons = true,
		},
		winopts = {
			width = 0.87,
			height = 0.80,
			row = 0.5,
			col = 0.5,
			preview = {
				layout = "flex",
				flip_columns = 120, -- Stack the preview below the list in narrow windows
				horizontal = "right:55%",
				vertical = "down:50%",
				scrollbar = false,
			},
		},
		fzf_opts = {
			["--info"] = "inline-right",
			["--pointer"] = "▌",
			["--marker"] = "▍",
			["--separator"] = "─",
			["--gutter"] = " ", -- fzf draws "▌" on every row by default
			["--no-scrollbar"] = true, -- The frame already bounds the list
		},
		keymap = {
			fzf = {
				true, -- Keep the default binds
				["ctrl-q"] = "select-all+accept", -- Send all results to the quickfix list
			},
		},
		files = { cwd_prompt = false },
		grep = { rg_glob = true }, -- `foo -- *.lua` filters live grep by glob
	})

	-- Size vim.ui.select (code actions, etc.) to its items instead of the full picker.
	fzf.register_ui_select(function(_, items)
		-- Border, prompt and separator take 4 rows.
		local height = math.floor(math.min(vim.o.lines * 0.8 - 10, #items + 4) + 0.5)
		return { winopts = { width = 0.5, height = height, row = 0.4 } }
	end)

	local map = vim.keymap.set
	map("n", "<leader>ff", fzf.files, { desc = "Find files" })
	map("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
	map("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
	map("n", "<leader>fw", fzf.grep_cword, { desc = "Grep word under cursor" })
	map("x", "<leader>fw", fzf.grep_visual, { desc = "Grep selection" })
	map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
	map("n", "<leader>fh", fzf.helptags, { desc = "Help pages" })
	map("n", "<leader>fk", fzf.keymaps, { desc = "Keymaps" })
	map("n", "<leader>fd", fzf.diagnostics_document, { desc = "Document diagnostics" })
	map("n", "<leader>fD", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })
	map("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "Document symbols" })
	map("n", "<leader>fS", fzf.lsp_live_workspace_symbols, { desc = "Workspace symbols" })
	map("n", "<leader>f.", fzf.resume, { desc = "Resume last picker" })
end

-- File explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
})

require("nvim-tree").setup({})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Window navigation
do
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
end

-- Buffer removal
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.bufremove" },
})

vim.keymap.set("n", "<leader>bd", function()
	require("mini.bufremove").delete()
end, { desc = "Delete buffer" })
