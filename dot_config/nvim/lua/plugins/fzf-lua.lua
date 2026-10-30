require("plugins.mini-icons")

vim.pack.add({
	{ src = "https://github.com/ibhagwan/fzf-lua" },
})

local fzf = require("fzf-lua")

fzf.setup({
	"border-fused", -- One rounded frame around the list and preview
	fzf_colors = true, -- Derive fzf colors from the colorscheme
	defaults = {
		file_icons = "mini",
		git_icons = true,
	},
	winopts = {
		width = 0.87,
		height = 0.80,
		row = 0.5,
		col = 0.5,
		preview = {
			layout = "flex",
			flip_columns = 120, -- Stack the preview below the list in narrow windows
			horizontal = "right:55%",
			vertical = "down:50%",
			scrollbar = false,
		},
	},
	fzf_opts = {
		["--info"] = "inline-right",
		["--pointer"] = "▌",
		["--marker"] = "▍",
		["--separator"] = "─",
		["--gutter"] = " ", -- fzf draws "▌" on every row by default
		["--no-scrollbar"] = true, -- The frame already bounds the list
	},
	keymap = {
		fzf = {
			true, -- Keep the default binds
			["ctrl-q"] = "select-all+accept", -- Send all results to the quickfix list
		},
	},
	files = { cwd_prompt = false },
	grep = { rg_glob = true }, -- `foo -- *.lua` filters live grep by glob
})

-- Size vim.ui.select (code actions, etc.) to its items instead of the full picker.
fzf.register_ui_select(function(_, items)
	-- Border, prompt and separator take 4 rows.
	local height = math.floor(math.min(vim.o.lines * 0.8 - 10, #items + 4) + 0.5)
	return { winopts = { width = 0.5, height = height, row = 0.4 } }
end)

local map = vim.keymap.set
map("n", "<leader>ff", fzf.files, { desc = "Find files" })
map("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
map("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
map("n", "<leader>fw", fzf.grep_cword, { desc = "Grep word under cursor" })
map("x", "<leader>fw", fzf.grep_visual, { desc = "Grep selection" })
map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
map("n", "<leader>fh", fzf.helptags, { desc = "Help pages" })
map("n", "<leader>fk", fzf.keymaps, { desc = "Keymaps" })
map("n", "<leader>fd", fzf.diagnostics_document, { desc = "Document diagnostics" })
map("n", "<leader>fD", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })
map("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "Document symbols" })
map("n", "<leader>fS", fzf.lsp_live_workspace_symbols, { desc = "Workspace symbols" })
map("n", "<leader>f.", fzf.resume, { desc = "Resume last picker" })
