local M = {}

M.dependencies = {}

M.setup = function() end
M.reload = function(opts)
	local Promise = require("promise")
	local plugins = vim.tbl_filter(function(plugin)
		return opts.plugins[plugin]
	end, vim.tbl_keys(opts.plugins or {}))
	if #plugins == 0 then
		return Promise.resolved()
	end

	local spec = require("lazy.core.plugin").Spec.new(plugins)
	local missing_plugins = vim.tbl_filter(function(plugin)
		local dir = plugin.dir
		local dirstat = vim.loop.fs_stat(dir)
		return not dirstat
	end, spec.plugins)
	if #missing_plugins == 0 then
		return Promise.resolved()
	end

	return Promise.new(function(resolve)
		vim.notify("Installing plugins " .. table.concat(plugins, ", "), "info")
		require("lazy")
			.install({ plugins = spec.plugins, wait = false, show = true, clear = false })._running
			:on("done", resolve)
	end)
end

return setmetatable({
	{
		"neovim/nvim-lspconfig",
		opts = {
			modules = { plugin_installer = "core.lazy_installer" },
		},
	},
}, { __index = M })

