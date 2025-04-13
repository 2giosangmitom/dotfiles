return {
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {},
	},
	{
		"echasnovski/mini.tabline",
		event = { "BufNewFile", "BufReadPost" },
		dependencies = { "echasnovski/mini.icons" },
		opts = {},
	},
	{
		"echasnovski/mini.statusline",
		event = "VeryLazy",
		opts = {},
	},
	{
		"echasnovski/mini.icons",
		opts = {},
	},
}
