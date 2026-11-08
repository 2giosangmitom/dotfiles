-- Editing behavior: sensible defaults, text objects, git and syntax.

-- Basics
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.basics" },
})

require("mini.basics").setup()

-- Misc utilities
Config.later(function()
	local misc = require("mini.misc")
	misc.setup()
	misc.setup_restore_cursor()
	misc.setup_auto_root()

	vim.keymap.set("n", "<leader>z", function()
		misc.zoom()
	end, { desc = "Zoom current window" })
end)

-- Auto pairs
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.pairs" },
})

require("mini.pairs").setup()

-- Surround
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.surround" },
})

require("mini.surround").setup()

-- Git signs
vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("gitsigns").setup()

-- Treesitter
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

require("nvim-treesitter").install(require("config.lang").list("parsers"))

-- Enable highlighting for filetypes with an installed parser.
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

-- Key hints
Config.later(function()
	vim.pack.add({
		{ src = "https://github.com/nvim-mini/mini.clue" },
	})

	local clue = require("mini.clue")

	---@type table[]
	local leader_groups = {
		{ mode = "n", keys = "<Leader>b", desc = "+Buffer" },
		{ mode = "n", keys = "<Leader>c", desc = "+Code" },
		{ mode = "n", keys = "<Leader>d", desc = "+Debug" },
		{ mode = "n", keys = "<Leader>f", desc = "+Find" },
		{ mode = "n", keys = "<Leader>u", desc = "+UI" },
		{ mode = "x", keys = "<Leader>c", desc = "+Code" },
		{ mode = "x", keys = "<Leader>d", desc = "+Debug" },
		{ mode = "x", keys = "<Leader>f", desc = "+Find" },
	}

	clue.setup({
		triggers = {
			-- Leader
			{ mode = "n", keys = "<Leader>" },
			{ mode = "x", keys = "<Leader>" },
			-- Built-in completion
			{ mode = "i", keys = "<C-x>" },
			-- `g` and `z` keys
			{ mode = "n", keys = "g" },
			{ mode = "x", keys = "g" },
			{ mode = "n", keys = "z" },
			{ mode = "x", keys = "z" },
			-- Brackets
			{ mode = "n", keys = "[" },
			{ mode = "n", keys = "]" },
			-- Marks
			{ mode = "n", keys = "'" },
			{ mode = "n", keys = "`" },
			{ mode = "x", keys = "'" },
			{ mode = "x", keys = "`" },
			-- Registers
			{ mode = "n", keys = '"' },
			{ mode = "x", keys = '"' },
			{ mode = "i", keys = "<C-r>" },
			{ mode = "c", keys = "<C-r>" },
			-- Window commands
			{ mode = "n", keys = "<C-w>" },
		},
		clues = {
			leader_groups,
			clue.gen_clues.builtin_completion(),
			clue.gen_clues.g(),
			clue.gen_clues.marks(),
			clue.gen_clues.registers(),
			clue.gen_clues.windows(),
			clue.gen_clues.z(),
		},
		window = { delay = 300 },
	})
end)
