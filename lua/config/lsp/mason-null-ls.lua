local m = {}

function m.setup()
	local mason_null_ls = require("mason-null-ls")

	mason_null_ls.setup({
		-- list of formatters & linters for mason to install
		ensure_installed = {
			"prettier", -- ts/js formatter
			"stylua", -- lua formatter
			"eslint_d", -- ts/js linter
		},
		-- auto-install configured formatters & linters (with null-ls)
		automatic_installation = true,
	})
end

return m
