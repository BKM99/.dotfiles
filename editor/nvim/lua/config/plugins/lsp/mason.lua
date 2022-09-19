local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_1 then
	return
end

local servers = {
	"jsonls",
	"sumneko_lua",
	"clangd",
	"tsserver",
	"gopls",
	"html",
	"pyright",
	"rust_analyzer",
	"tailwindcss",
	"yamlls",
	"cssls",
	"eslint",
	"emmet_ls",
	"jdtls",
}

mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

mason_lspconfig.setup({
	ensure_installed = servers,
})

local mason_tool_installer_status_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
if not mason_tool_installer_status_ok then
	return
end

mason_tool_installer.setup({
    -- I'm using this tool for everything that's not an LSP
	ensure_installed = {
		"chrome-debug-adapter",
		"node-debug2-adapter",
		"delve",
		"debugpy",
		"black",
		"prettier",
		"stylua",
	},
	auto_update = false,
	run_on_start = true,
})

-- Upon completion of any mason-tool-installer initiated installation/update
-- a user event will be emitted named MasonToolsUpdateCompleted
vim.api.nvim_create_autocmd("User", {
	pattern = "MasonToolsUpdateCompleted",
	callback = function()
		vim.schedule(print("mason-tool-installer has finished"))
	end,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("config.plugins.lsp.lsp-functions").on_attach,
		capabilities = require("config.plugins.lsp.lsp-functions").capabilities,
	}

	if server == "sumneko_lua" then
		local sumneko_opts = require("config.plugins.lsp.lsp-custom-server.sumneko_lua")
		opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
	end

	if server == "pyright" then
		local pyright_opts = require("config.plugins.lsp.lsp-custom-server.pyright")
		opts = vim.tbl_deep_extend("force", pyright_opts, opts)
	end

	if server == "rust_analyzer" then
		local rust_opts = require("config.plugins.lsp.lsp-custom-server.rust")
		local rust_tools_status_ok, rust_tools = pcall(require, "rust-tools")
		if not rust_tools_status_ok then
			return
		end

		rust_tools.setup(rust_opts)
		goto continue
	end

	if server == "jsonls" then
		local jsonls_opts = require("config.plugins.lsp.lsp-custom-server.jsonls")
		opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	end

    if server == "tailwindcss" then
		local tailwindcss_opts = require("config.plugins.lsp.lsp-custom-server.tailwindcss")
		opts = vim.tbl_deep_extend("force", tailwindcss_opts, opts)
    end

	if server == "jdtls" then
		goto continue
	end

	lspconfig[server].setup(opts)
	::continue::
end
