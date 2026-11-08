vim.pack.add({
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})

require("render-markdown").setup({
	-- LSP hover floats are nofile buffers; show them as raw text.
	overrides = {
		buftype = {
			nofile = { enabled = false },
		},
	},
})
