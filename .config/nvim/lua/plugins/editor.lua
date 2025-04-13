return {
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		dependencies = {
			"echasnovski/mini.icons",
		},
		init = function()
			require("fzf-lua").register_ui_select()
		end,
		keys = {
			{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
		},
		opts = {
			prompt = " ",
			files = { cwd_prompt = false },
			winopts = {
				width = 0.8,
				height = 0.8,
				row = 0.5,
				col = 0.5,
				preview = {
					scrollchars = { "┃" },
				},
			},
		},
	},
	{
		"echasnovski/mini.sessions",
		keys = {
			{
				"<leader>ss",
				function()
					MiniSessions.select()
				end,
				desc = "Select session to read",
			},
			{
				"<leader>sd",
				function()
					MiniSessions.select("delete")
				end,
				desc = "Select session to delete",
			},
			{
				"<leader>sl",
				function()
					MiniSessions.read()
				end,
				desc = "Restore last session",
			},
			{
				"<leader>sw",
				function()
					MiniSessions.write(vim.fn.input({ prompt = "Session name: ", default = "" }))
				end,
				desc = "Write session",
			},
		},
		opts = {},
	},
	{
		"echasnovski/mini.splitjoin",
		keys = {
			{ "gS", desc = "Toggle splitjoin" },
		},
		opts = {},
	},
	{
		"echasnovski/mini.diff",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			view = {
				style = "sign",
				signs = {
					add = "▎",
					change = "▎",
					delete = "",
				},
			},
		},
	},
	{
		"echasnovski/mini-git",
		cmd = "Git",
		main = "mini.git",
		opts = {},
	},
	{
		"kylechui/nvim-surround",
		version = "^3.0.0",
		event = "VeryLazy",
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"typescript",
				"javascript",
				"jsdoc",
				"html",
				"vue",
				"css",
				"cpp",
        "nix",
        "bash",
			},
			additional_vim_regex_highlighting = false,
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
