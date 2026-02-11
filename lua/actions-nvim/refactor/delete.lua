return function()
	-- Safe delete - delete symbol and its usages via LSP if supported
	-- Otherwise just delete the current line
	local params = vim.lsp.util.make_position_params()
	params.context = {
		includeDeclaration = true,
	}

	vim.lsp.buf_request(0, "textDocument/references", params, function(err, result, _, _)
		if err or not result or #result == 0 then
			-- No references found, just delete current line
			vim.api.nvim_del_current_line()
			return
		end

		-- Ask for confirmation if there are references
		vim.ui.select({ "Yes", "No" }, {
			prompt = string.format("Delete symbol and %d reference(s)?", #result),
		}, function(choice)
			if choice == "Yes" then
				-- Delete all references (in reverse order to preserve line numbers)
				table.sort(result, function(a, b)
					if a.range.start.line == b.range.start.line then
						return a.range.start.character > b.range.start.character
					end
					return a.range.start.line > b.range.start.line
				end)

				for _, ref in ipairs(result) do
					local bufnr = vim.uri_to_bufnr(ref.uri)
					vim.api.nvim_buf_set_text(
						bufnr,
						ref.range.start.line,
						ref.range.start.character,
						ref.range["end"].line,
						ref.range["end"].character,
						{}
					)
				end
			end
		end)
	end)
end
