require("config.options")
require("config.keymaps")

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
})

vim.cmd("colorscheme nightfall")

-- conform.nvim
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
	},
})
vim.keymap.set("n", "<leader>cf", function()
	require("conform").format()
end, { desc = "Format code" })

-- mason.nvim
require("mason").setup()

-- neo-tree.nvim
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle explorer" })
