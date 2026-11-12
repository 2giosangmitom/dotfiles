-- Language tooling: Mason, completion, LSP, formatting and linting.

-- Mason
do
	vim.pack.add({
		{ src = "https://github.com/mason-org/mason.nvim" },
		{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	})

	require("mason").setup({
		ui = {
			icons = {
				package_installed = require("config.icons").get("PackageInstalled"),
				package_pending = require("config.icons").get("PackagePending"),
				package_uninstalled = require("config.icons").get("PackageUninstalled"),
			},
		},
	})

	local lang = require("config.lang")

	-- Install LSP servers declared by language specs.
	require("mason-lspconfig").setup({
		ensure_installed = lang.list("servers"),
		automatic_enable = false, -- Servers are enabled explicitly in plugins/lsp.lua
	})

	-- Install formatters, linters and debuggers declared by language specs.
	local registry = require("mason-registry")
	registry.refresh(function()
		for _, name in ipairs(lang.list("tools")) do
			local ok, pkg = pcall(registry.get_package, name)
			if not ok then
				vim.notify("Mason package not found: " .. name, vim.log.levels.WARN)
			elseif not pkg:is_installed() and not pkg:is_installing() then
				pkg:install()
			end
		end
	end)
end

-- Completion
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
})

require("blink.cmp").setup({
	keymap = { preset = "super-tab" },
	fuzzy = { implementation = "lua" },
	completion = {
		menu = {
			scrollbar = false,
			draw = {
				columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
				-- Kind icons from mini.icons, so they match the rest of the UI.
				components = {
					kind_icon = {
						text = function(ctx)
							return (MiniIcons.get("lsp", ctx.kind)) .. ctx.icon_gap
						end,
						highlight = function(ctx)
							return select(2, MiniIcons.get("lsp", ctx.kind))
						end,
					},
					kind = {
						highlight = function(ctx)
							return select(2, MiniIcons.get("lsp", ctx.kind))
						end,
					},
				},
			},
		},
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
	},
	signature = { enabled = true },
	sources = {
		default = function()
			local sources = { "lsp", "path", "buffer", "snippets" }
			if Config.has_local("sqmeow.nvim") then
				table.insert(sources, "sqmeow")
			end
			return sources
		end,
		providers = {
			sqmeow = { name = "Sqmeow", module = "sqmeow.completion.blink" },
		},
	},
})

-- LSP
do
	vim.pack.add({
		{ src = "https://github.com/neovim/nvim-lspconfig" },
		{ src = "https://github.com/b0o/SchemaStore.nvim" },
	})

	local lang = require("config.lang")
	local servers = lang.list("servers")

	vim.lsp.config("*", {
		capabilities = require("blink.cmp").get_lsp_capabilities(),
	})

	require("config.lsp").setup()

	lang.setup()

	-- Server options live in after/lsp/<server>.lua.
	vim.lsp.enable(servers)
end

-- Formatting
do
	vim.pack.add({
		{ src = "https://github.com/stevearc/conform.nvim" },
	})

	local conform = require("conform")

	conform.setup({
		formatters_by_ft = require("config.lang").map("formatters"),
		default_format_opts = { lsp_format = "fallback" },
		-- Toggle globally with <leader>uf, or per buffer with `vim.b.disable_autoformat`.
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 1000 }
		end,
	})

	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

	vim.keymap.set({ "n", "x" }, "<leader>cf", function()
		conform.format()
	end, { desc = "Format" })

	vim.keymap.set("n", "<leader>uf", function()
		vim.g.disable_autoformat = not vim.g.disable_autoformat
		vim.notify("Format on save " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
	end, { desc = "Toggle format on save" })
end

-- Linting
do
	vim.pack.add({
		{ src = "https://github.com/mfussenegger/nvim-lint" },
	})

	local lint = require("lint")

	lint.linters_by_ft = require("config.lang").map("linters")

	-- Some linters (e.g. oxlint) read the file from disk, so lint on read and write.
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
		group = vim.api.nvim_create_augroup("user_lint", { clear = true }),
		callback = function()
			lint.try_lint()
		end,
	})
end
