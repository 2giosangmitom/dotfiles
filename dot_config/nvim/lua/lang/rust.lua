vim.pack.add({
	{ src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("^9") },
})

-- rustaceanvim starts rust-analyzer itself, so it is not listed in `servers`.
-- It uses the toolchain's rust-analyzer from PATH, and finds Mason's codelldb for DAP.
-- Formatting falls back to rust-analyzer (rustfmt).
return {
	tools = { "codelldb" },
	parsers = { "rust" },
	setup = function()
		vim.g.rustaceanvim = {
			server = {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
				on_attach = function(_, buf)
					vim.keymap.set("n", "<leader>cR", function()
						vim.cmd.RustLsp("codeAction")
					end, { buffer = buf, desc = "Rust code action" })
					vim.keymap.set("n", "<leader>dR", function()
						vim.cmd.RustLsp("debuggables")
					end, { buffer = buf, desc = "Rust debuggables" })
				end,
				default_settings = {
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						check = { command = "clippy" },
					},
				},
			},
		}
	end,
}
