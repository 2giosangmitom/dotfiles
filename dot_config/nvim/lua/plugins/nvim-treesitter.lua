vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

require("nvim-treesitter").install({
	"python",
	"lua",
	"rust",
	"javascript",
	"typescript",
	"jsdoc",
	"json",
	"markdown",
	"markdown_inline",
	"yaml",
	"java",
})

-- Enable highlighting for filetypes with an installed parser.
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})
