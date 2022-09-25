local fn = vim.fn

local ensure_packer = function()
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

local packer_grp = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
vim.api.nvim_create_autocmd(
	{ "BufWritePost" },
	{ pattern = "packer.lua", command = "source <afile> | PackerSync", group = packer_grp }
)

local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
	snapshot_path = fn.stdpath("config") .. "/snapshots",
	max_jobs = 15,
})

-- Install your plugins here
return packer.startup(function(use)
	use("wbthomason/packer.nvim")

	-- A Bunch of Plugins use these
	use("kyazdani42/nvim-web-devicons")
	use("nvim-lua/plenary.nvim")
	use("nvim-lua/popup.nvim")

	-- LSP
	use("neovim/nvim-lspconfig")
	use("williamboman/mason.nvim")
	use("WhoIsSethDaniel/mason-tool-installer.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use("mfussenegger/nvim-jdtls")
	use("b0o/SchemaStore.nvim")
	use("folke/trouble.nvim")

	-- Autocomplete
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lua",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind.nvim",
		},
	})

	-- DAP
	use({
		"mfussenegger/nvim-dap",
		requires = {
			"rcarriga/nvim-dap-ui",
			"mfussenegger/nvim-dap-python",
			"leoluz/nvim-dap-go",
		},
	})
	use("mxsdev/nvim-dap-vscode-js")
	use({
		"microsoft/vscode-js-debug",
		opt = true,
		run = "npm install --legacy-peer-deps && npm run compile",
	})

	-- Testing
	use({
		"vim-test/vim-test",
		setup = function()
			vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>", { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>ta", ":TestSuite<CR>", { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>tv", ":TestVisit<CR>", { noremap = true, silent = true })
			vim.cmd([[let test#strategy = "neovim"]])
		end,
	})

	-- Snippets
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")

	-- Git
	use("lewis6991/gitsigns.nvim")
	use("sindrets/diffview.nvim")
	use({
		"f-person/git-blame.nvim",
		setup = function()
			vim.g.gitblame_enabled = false
		end,
	})

	-- Treesitter
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- Telescope
	use("nvim-telescope/telescope.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use("nvim-telescope/telescope-dap.nvim")

	-- UI Stuff
	use({
		"mbbill/undotree",
		setup = function()
			vim.keymap.set("n", "<leader>ut", ":UndotreeToggle<CR>", { noremap = true, silent = true })
		end,
	})
	use("lukas-reineke/indent-blankline.nvim")
	use("norcalli/nvim-colorizer.lua")
	use("kyazdani42/nvim-tree.lua")
	use("nvim-lualine/lualine.nvim")

	-- Editing Support
	use("windwp/nvim-autopairs")
	use("numToStr/Comment.nvim")
	use("windwp/nvim-ts-autotag")
	use({
		"nacro90/numb.nvim",
		config = function()
			require("numb").setup()
		end,
	})
	use("chaoren/vim-wordmotion")

	-- Note taking (Markdown)
	use({
		"jakewvincent/mkdnflow.nvim",
		config = function()
			require("mkdnflow").setup({})
		end,
		ft = { "markdown" },
	})
	use({ "mickael-menu/zk-nvim", ft = { "markdown" } })
	use({
		"AckslD/nvim-FeMaco.lua",
		config = function()
			require("femaco").setup()
		end,
		cmd = "FeMaco",
	})
	use({ "preservim/vim-markdown", ft = { "markdown" } })
	use({ "dhruvasagar/vim-table-mode", ft = { "markdown" } })
	use({ "mzlogin/vim-markdown-toc", ft = { "markdown" } })
	use({ "dkarter/bullets.vim", ft = { "markdown" } })
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
        ft = { "markdown" }
	})

	-- Better Performance
	use("lewis6991/impatient.nvim")
	use({
		"antoinemadec/FixCursorHold.nvim",
		run = function()
			vim.g.curshold_updatime = 100
		end,
	})

	-- Other Plugins
	use({
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				manual_mode = false,
			})
		end,
	})
	use({ "phaazon/hop.nvim", branch = "v2" })
	use("ThePrimeagen/harpoon")

	-- Colorschemes
	-- use("RRethy/nvim-base16")
	use("folke/tokyonight.nvim")

	-- Automatically set up your configuration after cloning packer.nvim
	if packer_bootstrap then
		print("Installing plugins, restart neovim after.")
		require("packer").sync()
	end
end)
