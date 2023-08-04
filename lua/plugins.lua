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
	return require("packer.util").float { border = "rounded" }
      end,
    },
  }

  -- Check if packer.nvim is installed
  -- Run PackerCompile if there are changes in this file
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
      }
      vim.cmd [[packadd packer.nvim]]
    end
    vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
  end

  -- Plugins
  local function plugins(use)
    use { "wbthomason/packer.nvim" }

    -- Load only when require
    use { "nvim-lua/plenary.nvim", module = "plenary" }

    -- Notification
    use {
      "rcarriga/nvim-notify",
      event = "VimEnter",
      config = function()
        vim.notify = require "notify"
      end,
    }

  	-- lsp
	  use {
	    "neovim/nvim-lspconfig",
	    opt = true,
	    event = "bufreadpre",
	    wants = { "cmp-nvim-lsp", "nvim-lsp-installer", "lsp_signature.nvim" },
	    config = function()
	      require("config.lsp").setup()
	    end,
	    requires = {
	      "williamboman/nvim-lsp-installer",
	      "ray-x/lsp_signature.nvim"
	    },
	  }

	use {
	  "hrsh7th/nvim-cmp",
	  event = "InsertEnter",
	  opt = true,
	  config = function()
	    require("config.cmp").setup()
	  end,
	  wants = { "LuaSnip" },
	  requires = {
	    "hrsh7th/cmp-buffer",
	    "hrsh7th/cmp-path",
	    "hrsh7th/cmp-nvim-lua",
	    "ray-x/cmp-treesitter",
	    --"hrsh7th/cmp-cmdline",
	    "saadparwaiz1/cmp_luasnip",
	    "hrsh7th/cmp-nvim-lsp",
	    {
	      "L3MON4D3/LuaSnip",
	      wants = "friendly-snippets",
	      config = function()
		require("config.luasnip").setup()
	      end,
	    },
	    "rafamadriz/friendly-snippets",
	  },
	  disable = false,
	}

   -- Bootstrap Neovim
    if packer_bootstrap then
      print "Restart Neovim required after installation!"
      require("packer").sync()
    end
  end

  -- Init and start packer
  packer_init()
  local packer = require "packer"
  packer.init(conf)
  packer.startup(plugins)
end

return M
