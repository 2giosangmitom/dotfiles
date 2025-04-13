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
	{
		"echasnovski/mini.indentscope",
		event = "VeryLazy",
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "lazy" },
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
		opts = {
			symbol = "│",
			options = { try_as_border = true },
		},
	},
}
