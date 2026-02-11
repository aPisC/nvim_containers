return function()
	-- local efm = vim.lsp.get_active_clients({ name = 'efm', bufnr = vim.api.nvim_get_current_buf() })

	-- if vim.tbl_isempty(efm) then
	-- else
	--   vim.lsp.buf.({ name = 'efm' })
	-- end
	--
	local lspconfig = require("lspconfig")
	local efm_modules = vim.tbl_get(lspconfig, "efm", "manager", "config", "settings", "languages", vim.bo.filetype)
		or {}
	local has_efm_formatter = vim.tbl_filter(function(module)
		return module.formatCommand
	end, efm_modules)[1] ~= nil

	if has_efm_formatter then
		vim.lsp.buf.format({ name = "efm" })
	else
		vim.lsp.buf.format()
	end
end

