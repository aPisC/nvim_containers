local M = {}

M.dependencies = {}

function M.setup(opts)

	if not opts.servers then
		return
	end

	-- setup LSP servers
	local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	local lspconfig = require("lspconfig")

	for server, server_config in pairs(opts.servers) do
		if type(server_config) == "function" then
			server_config = server_config()
		end
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			has_cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or {},
			server_config.capabilities or {}
		)

		for _, extend_capabilities in pairs(opts.extend_capabilities or {}) do
			capabilities = extend_capabilities(capabilities, server)
		end

		local on_attach = function(client, bufnr)
			if server_config.on_attach then
				server_config.on_attach(client, bufnr)
			end
			if capabilities.signature_help and capabilities.signature_help.enable then
				require("lsp_signature").on_attach(capabilities.signature_help, bufnr)
			end
			-- if capabilities.use_virtual_types then
			-- require("virtual-types").on_attach(client, bufnr)
			-- end
		end

		if server_config.lspDefaultCapabilities == false then
			capabilities = server_config.capabilities
		end

		local config = vim.tbl_deep_extend(
			"force",
			{},
			server_config,
			{ capabilities = capabilities, on_attach = on_attach }
		)

		local has_coq, coq = pcall(require, "coq")
		config = has_coq and coq.lsp_ensure_capabilities(config) or config

		lspconfig[server].setup(config)
	end

	-- Initialize EFM
	local efm_capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		has_cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or {},
		opts.efm.capabilities or {}
	)

	for _, extend_capabilities in pairs(opts.extend_capabilities or {}) do
		efm_capabilities = extend_capabilities(efm_capabilities, server)
	end

	local efm_on_attach = function(client, bufnr)
		if opts.efm.on_attach then
			opts.efm.on_attach(client, bufnr)
		end
		if efm_capabilities.signature_help and efm_capabilities.signature_help.enable then
			require("lsp_signature").on_attach(capabilities.signature_help, bufnr)
		end
		-- if capabilities.use_virtual_types then
		-- require("virtual-types").on_attach(client, bufnr)
		-- end
	end

	local efmls_config = {
		filetypes = vim.tbl_keys(opts.efm),
		settings = {
			rootMarkers = { ".git/" },
			languages = vim.tbl_map(function(lang_config)
				return vim.tbl_map(function(module)
					if type(module) == "function" then
						return module()
					end
					if type(module) == "string" then
						return require(module)
					end
					return module
				end, lang_config)
			end, opts.efm),
		},
		init_options = {
			documentFormatting = true,
			documentRangeFormatting = true,
		},
		capabilities = efm_capabilities,
		on_attach = efm_on_attach,
	}
	lspconfig.efm.setup(efmls_config)

end

function M.reload(config) 
  local Promise = require("promise")
	return Promise.new(function(resolve)
		if config.servers then
			for server, server_config in pairs(config.servers) do
				vim.defer_fn(function()
					pcall(function()
						vim.notify("Starting LSP server " .. server)
						require("lspconfig")[server].setup(server_config)
						vim.cmd("LspStart " .. server)
					end)
				end, 0)
			end
		end
		resolve()
	end)

end

return setmetatable({
	{
		"neovim/nvim-lspconfig",
		opts = {
			modules = { language_servers = "core.language_servers" },
		},
	},
}, { __index = M })

