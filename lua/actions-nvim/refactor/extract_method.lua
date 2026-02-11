return function()
	-- Extract method/function from selected code
	vim.lsp.buf.code_action({
		context = {
			only = { "refactor.extract" },
			diagnostics = {},
		},
	})
end
