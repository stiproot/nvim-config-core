local m = {}

function m.setup()
	local treesitter = require("nvim-treesitter.configs")

	treesitter.setup({
		highlight = {
			enable = true,
		},
		indent = { enable = true },
		-- enable autotagging (w/ nvim-ts-autotag plugin)
		autotag = { enable = true },
		-- ensure these language parsers are installed
		ensure_installed = {
			"json",
			"javascript",
			"typescript",
			"tsx",
			"yaml",
			"html",
			"css",
			"markdown",
			"markdown_inline",
			"svelte",
			"graphql",
			"bash",
			"lua",
			"vim",
			"dockerfile",
			"gitignore",
			"c_sharp",
		},
		-- auto install above language parsers
		auto_install = true,
	})
end

return m
