vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
})

local icons = require("config.icons").diagnostics

-- File type icon from mini.icons, resolved at render time since mini.icons loads after this module.
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
