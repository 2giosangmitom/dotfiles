-- Appearance: colorscheme, icons, statusline, tabline, indent guides, notifications, markdown rendering.

-- Local plugins under development (~/Workspace). Missing checkouts are skipped.
Config.add_local("sqmeow.nvim")
Config.add_local("nightfall.nvim")

-- Colorscheme (falls back to the built-in default if nightfall is unavailable)
if not pcall(vim.cmd.colorscheme, "deeper-night") then
	vim.cmd.colorscheme("default")
end

-- Icons
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.icons" },
})

require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()

-- UI components (required by sqmeow.nvim)
vim.pack.add({
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
})

-- Statusline
do
	vim.pack.add({
		{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	})

	local icons = require("config.icons")

	--- File type icon and highlight for the current buffer, from mini.icons.
	---@return string icon
	---@return string? hl
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
				{ "b:gitsigns_head", icon = icons.get("GitBranch") },
				{
					"diff",
					symbols = {
						added = icons.get("GitAdd", 1),
						modified = icons.get("GitChange", 1),
						removed = icons.get("GitDelete", 1),
					},
					-- Reuse gitsigns' hunk counts instead of lualine running its own git diff.
					source = function()
						local status = vim.b.gitsigns_status_dict
						if status then
							return { added = status.added, modified = status.changed, removed = status.removed }
						end
					end,
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
				{
					"filename",
					symbols = {
						modified = icons.get("FileModified"),
						readonly = icons.get("FileReadOnly"),
						unnamed = icons.get("FileUnnamed"),
						newfile = icons.get("FileNew"),
					},
				},
			},
			-- Built-in diagnostics summary with the sign icons from
			-- config/diagnostics.lua. It carries its own highlights, so it sits in a
			-- plain section.
			lualine_x = { vim.diagnostic.status, "encoding", "fileformat", "filetype" },
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

-- LSP progress and notifications
vim.pack.add({
	{ src = "https://github.com/j-hui/fidget.nvim" },
})

require("fidget").setup({
	progress = {
		display = { done_icon = require("config.icons").get("Check") },
	},
	notification = {
		-- Show vim.notify() messages in fidget's corner window too.
		override_vim_notify = true,
		window = { winblend = 0, border = "none" },
	},
})

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
