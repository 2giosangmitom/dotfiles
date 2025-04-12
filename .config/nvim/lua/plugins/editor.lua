return {
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		dependencies = {
			"echasnovski/mini.icons",
		},
		init = function()
			vim.ui.select = function(...)
				require("fzf-lua").register_ui_select()
				return vim.ui.select(...)
			end
		end,
		keys = {
			{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
		},
		opts = {},
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
}
