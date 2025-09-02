require("config.options")
require("config.keymaps")
require("config.autocmds")

vim.pack.add({
	"https://github.com/2giosangmitom/nightfall.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/romgrk/barbar.nvim",
	"https://github.com/kylechui/nvim-surround",
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
	"https://github.com/folke/which-key.nvim",
	"https://github.com/nvim-mini/mini.indentscope",
	"https://github.com/j-hui/fidget.nvim",
	"https://github.com/jellydn/hurl.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

vim.cmd("colorscheme nightfall")

-- conform.nvim
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		markdown = { "prettierd" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		vue = { "prettierd" },
		sql = { "sqruff" },
	},
})
vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format code" })

-- mason.nvim
require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = { "clangd", "lua_ls", "vue_ls", "prismals", "vtsls" },
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
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		},
	},
})

-- blink.cmp
require("blink.cmp").setup({
	keymap = { preset = "super-tab" },
	sources = {
		default = { "lsp", "buffer", "snippets", "path" },
	},
	signature = { enabled = true },
})

-- nvim-treesitter
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- which-key.nvim
require("which-key").setup({
	preset = "helix",
})

-- mini.indentscope
require("mini.indentscope").setup({
	symbol = "│",
})

-- fidget.nvim
require("fidget").setup()

-- hurl.nvim
require("hurl").setup()
vim.keymap.set({ "v", "n" }, "<leader>hr", ":HurlRunner<cr>", { desc = "Hurl Runner" })

-- nvim-surround
require("nvim-surround").setup()

-- barbar.nvim
vim.keymap.set("n", "H", "<cmd>BufferPrevious<cr>", { desc = "Move to previous buffer" })
vim.keymap.set("n", "L", "<cmd>BufferNext<cr>", { desc = "Move to next buffer" })
