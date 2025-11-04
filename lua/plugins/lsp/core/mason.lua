local M = {}

M.dependencies = {
	"williamboman/mason.nvim",
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	"williamboman/mason-lspconfig.nvim",
}

local mason_config = {}

local function tool_installer_config(opts)
	return {
		ensure_installed = vim.tbl_filter(function(package)
			return opts.mason_install[package]
		end, vim.tbl_keys(opts.mason_install or {})),
		auto_update = false,
		run_on_start = true,
		start_delay = 3000,
	}
end

local mason_lspconfig = { ensure_installed = {}, automatic_installion = true }

function M.setup(lsp_opts)
	require("mason").setup(mason_config)
	require("mason-tool-installer").setup(tool_installer_config(lsp_opts))
	require("mason-lspconfig").setup({ mason_lspconfig })
end

function M.reload(lsp_opts)
	local Promise = require("promise")
	return Promise._then(vim.tbl_map(function(package)
		return Promise.new(function(resolve)
			local Package = require("mason-core.package")
			local registry = require("mason-registry")

			if not lsp_opts.mason_install[package] then
				return resolve()
			end
			if registry.is_installed(package) then
				return resolve()
			end

			vim.notify("[Mason] Installing package " .. package, "info")
			local package_name, version = Package.Parse(package)
			local pkg = registry.get_package(package_name)
			local handle = pkg:install({ version = version })

			local callback = function()
				if not handle.package:is_installed() then
					vim.notify("[Mason] Failed to install package " .. package_name, "error")
				else
					vim.notify("[Mason] Installed package " .. package_name, "info")
				end
				resolve()
			end

			if handle:is_closed() then
				callback()
			else
				handle:once("closed", callback)
			end
		end)
	end, vim.tbl_keys(lsp_opts.mason_install or {})))
end

return setmetatable({
	"williamboman/mason.nvim",
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	"williamboman/mason-lspconfig.nvim",
	{
		"neovim/nvim-lspconfig",
		opts = {
			modules = { tool_installer = "core.mason" },
			mason_install = {},
		},
	},
}, { __index = M })
