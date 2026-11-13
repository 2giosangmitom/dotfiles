--- Nerd Font icons shared across the config, in the style of AstroNvim:
--- PascalCase names grouped by prefix (`Diagnostic*`, `Git*`, `Dap*`...).
--- File type and LSP kind icons come from mini.icons instead.
local M = {}

---@enum (key) config.IconName
local icons = {
	-- Diagnostics
	DiagnosticError = "󰅜",
	DiagnosticWarn = "󰀦",
	DiagnosticInfo = "",
	DiagnosticHint = "󰛨",
	-- Git status
	GitBranch = "󰘬",
	GitAdd = "󰐖",
	GitChange = "󰏬",
	GitDelete = "󰍵",
	GitRenamed = "󰜴",
	GitUntracked = "󰞋",
	GitIgnored = "󰨓",
	GitStaged = "󰸞",
	GitUnstaged = "󰧞",
	GitConflict = "󰘭",
	-- Git gutter signs: thin bars for changed lines, edge bars for deleted ones
	GitSignAdd = "▎",
	GitSignChange = "▎",
	GitSignDelete = "▁",
	GitSignTopDelete = "▔",
	GitSignChangeDelete = "▎",
	GitSignUntracked = "┆",
	-- Debugging
	Debugger = "",
	DapBreakpoint = "",
	DapBreakpointCondition = "",
	DapBreakpointRejected = "",
	DapLogPoint = ".>",
	DapStopped = "󰁕",
	-- Files and folders
	FileModified = "●",
	FileNew = "󰐖",
	FileReadOnly = "",
	FileUnnamed = "󰞋",
	FolderClosed = "󰉋",
	FolderOpen = "󰝰",
	FolderEmpty = "󰉋",
	FolderEmptyOpen = "󰝰",
	FolderSymlink = "󰉋",
	-- Folds and arrows
	FoldClosed = "󰍟",
	FoldOpened = "󰍝",
	ArrowRight = "󰜴",
	-- Packages (mason.nvim) and plugins (:Pack)
	PackageInstalled = "󰗠",
	PackagePending = "󰜮",
	PackageUninstalled = "",
	PluginLoaded = "",
	PluginInactive = "",
	PluginUpdate = "󰜷",
	PluginBreaking = "󰀦",
	-- General
	Buffer = "󰈙",
	Check = "󰗠",
	Code = "󰅩",
	Search = "󰍉",
	Settings = "󰒓",
	Test = "󰂓",
}

--- Get an icon by name, optionally followed by `padding` spaces.
---@param name config.IconName
---@param padding? integer
---@return string
function M.get(name, padding)
	return icons[name] .. string.rep(" ", padding or 0)
end

return M
