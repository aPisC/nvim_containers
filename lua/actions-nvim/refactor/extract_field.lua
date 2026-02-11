return function()
	-- Extract field - create a class/instance field
	vim.notify("Extract field - use LSP code action if available", vim.log.levels.INFO)
	vim.lsp.buf.code_action({
		context = {
			only = { "refactor.extract.field" },
			diagnostics = {},
		},
	})
end
