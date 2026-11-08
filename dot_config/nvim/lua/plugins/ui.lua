-- Appearance: colorscheme, icons, statusline, tabline, indent guides, notifications, markdown rendering.

-- Colorscheme
vim.opt.rtp:prepend(vim.fn.expand("~/Workspace/sqmeow.nvim"))
vim.opt.rtp:prepend(vim.fn.expand("~/Workspace/nightfall.nvim"))
vim.cmd("colorscheme deeper-night")

-- Icons
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.icons" },
})

require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()

-- UI components
vim.pack.add({
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
})

-- Statusline
do
	vim.pack.add({
		{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	})

	local icons = require("config.icons").diagnostics

	-- File type icon from mini.icons.
	local function file_icon()
		local name = vim.api.nvim_buf_get_name(0)
		if name == "" or not _G.MiniIcons then
			return "", nil
		end
		return MiniIcons.get("file", name)
	end

	require("lualine").setup({
		options = {
			theme = "auto",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = { statusline = { "NvimTree" } },
		},
		sections = {
			lualine_b = {
				{ "b:gitsigns_head", icon = "" },
				{
					"diff",
					-- Reuse gitsigns' hunk counts instead of lualine running its own git diff.
					source = function()
						local status = vim.b.gitsigns_status_dict
						if status then
							return { added = status.added, modified = status.changed, removed = status.removed }
						end
					end,
				},
				{
					"diagnostics",
					symbols = {
						error = icons.Error .. " ",
						warn = icons.Warn .. " ",
						info = icons.Info .. " ",
						hint = icons.Hint .. " ",
					},
				},
			},
			lualine_c = {
				{
					function()
						return (file_icon())
					end,
					color = function()
						return (select(2, file_icon()))
					end,
					padding = { left = 1, right = 0 },
				},
				"filename",
			},
		},
	})
end

-- Tabline
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.tabline" },
})

require("mini.tabline").setup()

-- Indent guides
vim.pack.add({
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
})

require("ibl").setup({
	indent = { char = "│", tab_char = "│" },
	scope = { show_start = false, show_end = false },
})

-- LSP progress
vim.pack.add({
	{ src = "https://github.com/j-hui/fidget.nvim" },
})

require("fidget").setup()

-- Markdown rendering
vim.pack.add({
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})

require("render-markdown").setup({
	-- LSP hover floats are nofile buffers; show them as raw text.
	overrides = {
		buftype = {
			nofile = { enabled = false },
		},
	},
})
