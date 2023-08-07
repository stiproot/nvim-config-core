local m = {}

-- enable keybinds only for when lsp server available
function m.on_attach(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	vim.keymap.set("n", "gf", "<cmd>lspsaga lsp_finder<cr>", opts) -- show definition, references
	vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts) -- got to declaration
	vim.keymap.set("n", "gd", "<cmd>lspsaga peek_definition<cr>", opts) -- see definition and make edits in window
	vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts) -- go to implementation
	vim.keymap.set("n", "<leader>ca", "<cmd>lspsaga code_action<cr>", opts) -- see available code actions
	vim.keymap.set("n", "<leader>rn", "<cmd>lspsaga rename<cr>", opts) -- smart rename
	vim.keymap.set("n", "<leader>d", "<cmd>lspsaga show_line_diagnostics<cr>", opts) -- show  diagnostics for line
	vim.keymap.set("n", "<leader>d", "<cmd>lspsaga show_cursor_diagnostics<cr>", opts) -- show diagnostics for cursor
	vim.keymap.set("n", "[d", "<cmd>lspsaga diagnostic_jump_prev<cr>", opts) -- jump to previous diagnostic in buffer
	vim.keymap.set("n", "]d", "<cmd>lspsaga diagnostic_jump_next<cr>", opts) -- jump to next diagnostic in buffer
	vim.keymap.set("n", "k", "<cmd>lspsaga hover_doc<cr>", opts) -- show documentation for what is under cursor
	vim.keymap.set("n", "<leader>o", "<cmd>lsoutlinetoggle<cr>", opts) -- see outline on right hand side

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		vim.keymap.set("n", "<leader>rf", ":typescriptrenamefile<cr>") -- rename file and update imports
		vim.keymap.set("n", "<leader>oi", ":typescriptorganizeimports<cr>") -- organize imports (not in youtube nvim video)
		vim.keymap.set("n", "<leader>ru", ":typescriptremoveunused<cr>") -- remove unused variables (not in youtube nvim video)
	end
end

function m.setup()
	local lspconfig = require("lspconfig")
	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local typescript = require("typescript")

	-- used to enable autocompletion (assign to every lsp server config)
	local capabilities = cmp_nvim_lsp.default_capabilities()

	-- change the diagnostic symbols in the sign column (gutter)
	-- (not in youtube nvim video)
	local signs = { error = " ", warn = " ", hint = "ﴞ ", info = " " }
	for type, icon in pairs(signs) do
		local hl = "diagnosticsign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	-- configure html server
	lspconfig["html"].setup({
		capabilities = capabilities,
		on_attach = m.on_attach,
	})

	-- configure typescript server with plugin
	typescript.setup({
		server = {
			capabilities = capabilities,
			on_attach = m.on_attach,
		},
	})

	-- configure css server
	lspconfig["cssls"].setup({
		capabilities = capabilities,
		on_attach = m.on_attach,
	})

	-- configure tailwindcss server
	lspconfig["tailwindcss"].setup({
		capabilities = capabilities,
		on_attach = m.on_attach,
	})

	-- configure emmet language server
	lspconfig["emmet_ls"].setup({
		capabilities = capabilities,
		on_attach = m.on_attach,
		filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
	})

	-- configure omnisharp language server
	lspconfig["omnisharp"].setup({
		capabilities = capabilities,
		on_attach = m.on_attach,
		-- filetypes = { "cs" },
	})

	-- configure lua server (with special settings)
	lspconfig["lua_ls"].setup({
		capabilities = capabilities,
		on_attach = m.on_attach,
		settings = { -- custom settings for lua
			lua = {
				-- make the language server recognize "vim" global
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					-- make language server aware of runtime files
					library = {
						[vim.fn.expand("$vimruntime/lua")] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
				},
			},
		},
	})
end
