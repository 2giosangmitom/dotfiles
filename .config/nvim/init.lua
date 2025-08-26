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
	"https://github.com/echasnovski/mini.pairs",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
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
	require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format code" })

-- mason.nvim
require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = { "clangd", "lua_ls" },
})

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

-- mini.pairs
require("mini.pairs").setup()

-- lsp servers
local files = vim.fn.readdir("lsp")
for _, file in ipairs(files) do
	local server_name = file:gsub("%.lua$", "")
	local ok, opts = pcall(require, "lsp." .. server_name)
	if ok then
		vim.lsp.config(server_name, opts)
	else
		vim.notify("Failed to load LSP config: " .. file, vim.log.levels.ERROR)
	end
end

-- blink.cmp
require("blink.cmp").setup({})

-- nvim-treesitter
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "<filetype>" },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
