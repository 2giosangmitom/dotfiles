-- clangd reads compile_commands.json (e.g. from CMake's CMAKE_EXPORT_COMPILE_COMMANDS).
-- Formatting falls back to clangd, which applies the project's .clang-format.
return {
	servers = {
		clangd = {
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--function-arg-placeholders=false",
			},
		},
	},
	tools = { "codelldb" },
	parsers = { "c", "cpp" },
	setup = function()
		-- nvim-lspconfig's clangd on_attach defines the command, so map it on attach
		-- instead of overriding on_attach.
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("user_clangd", { clear = true }),
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.name == "clangd" then
					vim.keymap.set("n", "<leader>ch", "<Cmd>LspClangdSwitchSourceHeader<CR>", {
						buffer = args.buf,
						desc = "Switch source/header",
					})
				end
			end,
		})
	end,
	dap = function(dap)
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = { command = "codelldb", args = { "--port", "${port}" } },
		}

		local configurations = {
			{
				type = "codelldb",
				request = "launch",
				name = "Launch executable",
				program = function()
					return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
			},
			{
				type = "codelldb",
				request = "attach",
				name = "Attach to process",
				pid = require("dap.utils").pick_process,
				cwd = "${workspaceFolder}",
			},
		}
		dap.configurations.c = configurations
		dap.configurations.cpp = configurations
	end,
}
