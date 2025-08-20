require("config.options")
require("config.keymaps")
require("config.autocmds")

vim.pack.add({
	"https://github.com/2giosangmitom/nightfall.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/nvim-neo-tree/neo-tree.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/ibhagwan/fzf-lua",
})

vim.cmd("colorscheme nightfall")

-- conform.nvim
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		markdown = { "prettierd" },
	},
})
vim.keymap.set("n", "<leader>cf", function()
	require("conform").format()
end, { desc = "Format code" })

-- mason.nvim
require("mason").setup()

-- neo-tree.nvim
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle explorer" })
require("neo-tree").setup({
	filesystem = {
		window = {
			mappings = {
				["<F5>"] = "refresh",
				["l"] = "open",
			},
		},
	},
})

-- lualine.nvim
require("lualine").setup({
	extensions = { "neo-tree" },
})

-- fzf-lua
require("fzf-lua").setup({})
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files" })
