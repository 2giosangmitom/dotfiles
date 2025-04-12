return {
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {},
	},
	{
		"echasnovski/mini.tabline",
		event = { "BufNewFile", "BufReadPost" },
		opts = {},
	},
	{
		"echasnovski/mini.statusline",
		event = "VeryLazy",
		opts = {},
	},
}
