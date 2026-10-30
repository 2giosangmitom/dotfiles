return {
	servers = {
		dockerls = {},
		docker_compose_language_service = {},
	},
	tools = { "hadolint" },
	parsers = { "dockerfile", "yaml" },
	linters = { dockerfile = { "hadolint" } },
	setup = function()
		-- docker_compose_language_service attaches to this filetype only.
		vim.filetype.add({
			pattern = {
				["docker%-compose%.ya?ml"] = "yaml.docker-compose",
				["compose%.ya?ml"] = "yaml.docker-compose",
			},
		})
		vim.treesitter.language.register("yaml", "yaml.docker-compose")
	end,
}
