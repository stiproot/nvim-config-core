local M = {}

function M.setup()
	-- Indicate first time installation
	local packer_bootstrap = false

	-- packer.nvim configuration
	local conf = {
		profile = {
			enable = true,
			threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
		},
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "rounded" })
			end,
		},
	}

	-- Check if packer.nvim is installed
	-- Run PackerCompile if there are changes in this file
	local function packer_init()
		local fn = vim.fn
		local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
		if fn.empty(fn.glob(install_path)) > 0 then
			packer_bootstrap = fn.system({
				"git",
				"clone",
				"--depth",
				"1",
				"https://github.com/wbthomason/packer.nvim",
				install_path,
			})
			vim.cmd([[packadd packer.nvim]])
		end
		vim.cmd("autocmd BufWritePost plugins.lua source <afile> | PackerCompile")
	end

	-- Plugins
	local function plugins(use)
		use({ "wbthomason/packer.nvim" })

		use({ "nvim-lua/plenary.nvim", module = "plenary" })

		use("szw/vim-maximizer")

		use({
			"numToStr/Comment.nvim",
			config = function()
				require("config.comment").setup()
			end,
		})

		use("nvim-tree/nvim-web-devicons")

		-- Autocompletion
		use({
			"hrsh7th/nvim-cmp",
			config = function()
				require("config.nvim-cmp").setup()
			end,
			requires = {
				"hrsh7th/cmp-buffer", -- source for text in buffer
				"hrsh7th/cmp-path", -- source for file system paths
			},
		}) -- completion plugin

		-- Managing & installing lsp servers, linters & formatters

		use({
			"williamboman/mason.nvim",
			config = function()
				require("config.lsp.mason").setup()
			end,
		})

		-- bridges gap b/w mason & lspconfig
		use({
			"williamboman/mason-lspconfig.nvim",
			after = "mason.nvim",
			config = function()
				require("config.lsp.mason-lspconfig").setup()
			end,
		})

		-- bridges gap b/w mason & null-ls
		use({
			"jayp0521/mason-null-ls.nvim",
			after = "mason.nvim",
			config = function()
				require("config.lsp.mason-null-ls").setup()
			end,
		})

		-- Configuring lsp servers
		-- easily configure language servers
		use({
			"neovim/nvim-lspconfig",
			after = "mason-lspconfig.nvim",
			config = function()
				require("config.lsp.nvim-lspconfig").setup()
			end,
		})

		-- for autocompletion
		use("hrsh7th/cmp-nvim-lsp")

		-- use({
		-- 	"glepnir/lspsaga.nvim",
		-- 	config = function()
		-- 		require("config.lsp.lspsaga").setup()
		-- 	end,
		-- 	branch = "main",
		-- 	requires = {
		-- 		{ "nvim-tree/nvim-web-devicons" },
		-- 		{ "nvim-treesitter/nvim-treesitter" },
		-- 	},
		-- }) -- enhanced lsp uis

		use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
		use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion

		-- formatting & linting
		use({
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require("config.lsp.null-ls").setup()
			end,
		}) -- configure formatters & linters

		-- treesitter configuration
		use({
			"nvim-treesitter/nvim-treesitter",
			config = function()
				require("config.treesitter").setup()
			end,
			run = function()
				local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
				ts_update()
			end,
		})

		-- Notification
		-- use({
		-- 	"rcarriga/nvim-notify",
		-- 	event = "VimEnter",
		-- 	config = function()
		-- 		vim.notify = require("notify")
		-- 	end,
		-- })

		-- Bootstrap Neovim
		if packer_bootstrap then
			print("Restart Neovim required after installation!")
			require("packer").sync()
		end
	end

	-- Init and start packer
	packer_init()
	local packer = require("packer")
	packer.init(conf)
	packer.startup(plugins)
end

return M
