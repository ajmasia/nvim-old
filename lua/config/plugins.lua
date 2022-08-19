local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- core plugins
	use("goolord/alpha-nvim")
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
	use("kyazdani42/nvim-web-devicons")
	use("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp and treesitter
	use("nvim-lualine/lualine.nvim")
	use("SmiteshP/nvim-gps")
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("numToStr/Comment.nvim")
	use("folke/which-key.nvim")
	use("rcarriga/nvim-notify")
	use({
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		module = "persistence",
		config = function()
			require("persistence").setup()
		end,
	})
	use({ "kyazdani42/nvim-tree.lua", commit = "f183c7f31197ae499c3420341fb8b275636a49b8" })
	use("ahmedkhalf/project.nvim")
	-- use("lewis6991/impatient.nvim")
	use({
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		setup = function()
			vim.g.indent_blankline_char = "¦"
			vim.g.indent_blankline_filetype_exclude = {
				"help",
				"terminal",
				"dashboard",
				"packer",
				"LspInfo",
				"LspInstallInfo",
				"Trouble",
			}
			vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
			vim.g.indent_blankline_show_current_context = true
		end,
	})
	use({
		"tpope/vim-surround",
		keys = { "c", "d", "y" },
		-- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
		setup = function()
			vim.o.timeoutlen = 500
		end,
	})
	use("antoinemadec/FixCursorHold.nvim") -- This is needed to fix lsp doc highlight
	use("br1anchen/nvim-colorizer.lua")
	use("natecraddock/sessions.nvim")
	use("natecraddock/workspaces.nvim")
	-- use({ "feline-nvim/feline.nvim", branch = "develop" })
	-- use("findango/vim-mdx")
	-- use("sheerun/vim-polyglot")
	use("jxnblk/vim-mdx-js")

	-- colorschemas
	use("lunarvim/colorschemes") -- A bunch of colorschemes you can try out
	use("navarasu/onedark.nvim")
	use("folke/tokyonight.nvim")

	-- comletion plugins
	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-emoji")
	use("hrsh7th/cmp-nvim-lua")
	-- TODO: extract cmp-tabnine config to an external file
	use({
		"tzachar/cmp-tabnine",
		config = function()
			local tabnine = require("cmp_tabnine.config")
			tabnine:setup({
				max_lines = 1000,
				max_num_results = 20,
				sort = true,
				run_on_every_keystroke = true,
				snippet_placeholder = "..",
				ignored_file_types = {
					-- default is not to ignore
					-- uncomment to ignore in lua:
					-- lua = true
				},
			})
		end,
		run = "./install.sh",
		requires = "hrsh7th/nvim-cmp",
	})

	-- snippets
	use("L3MON4D3/LuaSnip") --snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	-- LSP
	use("neovim/nvim-lspconfig") -- enable LSP
	use("williamboman/nvim-lsp-installer") -- simple to use language server installer
	use("tamago324/nlsp-settings.nvim") -- language server settings defined in json for
	use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters
	use("filipdutescu/renamer.nvim")
	use("simrat39/symbols-outline.nvim")
	use("ray-x/lsp_signature.nvim")
	use("b0o/SchemaStore.nvim")
	use({
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
		config = function()
			require("trouble").setup({
				signs = {
					error = "",
					warning = "",
					hint = "",
					information = "",
					other = "",
				},
			})
		end,
	})
	-- use("github/copilot.vim")
	use("RRethy/vim-illuminate")

	-- Telescope
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-media-files.nvim")
	use("nvim-telescope/telescope-ui-select.nvim")
	use("nvim-telescope/telescope-file-browser.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use({ "p00f/nvim-ts-rainbow", commit = "c6c26c4def0e9cd82f371ba677d6fc9baa0038af" })
	use("nvim-treesitter/playground")
	use("windwp/nvim-ts-autotag")
	use("romgrk/nvim-treesitter-context")
	use("mizlan/iswap.nvim")

	-- git
	use("lewis6991/gitsigns.nvim")
	use("f-person/git-blame.nvim")
	use("https://github.com/rhysd/conflict-marker.vim")
	use("tpope/vim-fugitive")
	use({ "sindrets/diffview.nvim", evet = "BufRead" })
	use("akinsho/git-conflict.nvim") -- https://github.com/akinsho/git-conflict.nvim

	-- Terminal
	use("akinsho/toggleterm.nvim")

	-- markdown
	-- use({
	-- 	"iamcco/markdown-preview.nvim",
	-- 	run = "cd app && npm install",
	-- 	setup = function()
	-- 		vim.g.mkdp_filetypes = { "markdown" }
	-- 	end,
	-- 	ft = { "markdown" },
	-- })
	use({
		"jakewvincent/mkdnflow.nvim",
		rocks = "luautf8", -- Ensures optional luautf8 dependency is installed
		config = function()
			require("mkdnflow").setup({})
		end,
	})

	use("lalitmee/browse.nvim")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
