return function()
	-- Try to use LSP code action for organize imports
	local params = vim.lsp.util.make_range_params()
	params.context = {
		only = { "source.organizeImports" },
		diagnostics = {},
	}

	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
	if not result or vim.tbl_isempty(result) then
		vim.notify("No organize imports action available", vim.log.levels.INFO)
		return
	end

	for _, res in pairs(result) do
		if res.result then
			for _, action in ipairs(res.result) do
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
				end
			end
		end
	end
end
