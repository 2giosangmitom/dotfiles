local path = vim.fn.stdpath("data") .. "/lazy/"

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
									"${3rd}/luv/library",
									path .. "mini.sessions",
								},
							},
							codeLens = {
								enable = true,
							},
							completion = {
								callSnippet = "Replace",
							},
							doc = {
								privateName = { "^_" },
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
						},
					},
				},
				clangd = {
					cmd = {
						"/usr/bin/clangd",
						"--background-index",
						"--clang-tidy",
						"--completion-style=detailed",
						"--fallback-style=google",
					},
				},
				ts_ls = {
					init_options = {
						plugins = {
							{
								name = "@vue/typescript-plugin",
								location = "/usr/lib/node_modules/@vue/typescript-plugin/",
								languages = { "javascript", "typescript", "vue" },
							},
						},
					},
					filetypes = {
						"javascript",
						"typescript",
						"vue",
					},
				},
				volar = {},
			},
		},
		config = function(_, opts)
			local servers = opts.servers

			for server, server_opts in pairs(servers) do
				vim.lsp.enable(server)
				vim.lsp.config(server, server_opts)
			end
		end,
	},
}
