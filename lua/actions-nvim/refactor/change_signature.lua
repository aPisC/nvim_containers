return function()
	-- Change method signature - use LSP if available
	vim.notify("Change signature - use LSP code action if available", vim.log.levels.INFO)
	vim.lsp.buf.code_action({
		context = {
			only = { "refactor.rewrite.changeSignature" },
			diagnostics = {},
		},
	})
end
