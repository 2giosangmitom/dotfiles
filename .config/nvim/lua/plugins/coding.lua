return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		event = "InsertEnter",
		opts = {
			keymap = { preset = "default" },
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = { documentation = { auto_show = true } },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	},
}
