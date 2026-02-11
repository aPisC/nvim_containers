return function()
	local helpers = require("actions.refactor._helpers")
	local mode = vim.fn.mode()

	if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
		vim.notify("Extract variable requires visual selection", vim.log.levels.WARN)
		return
	end

	-- Capture WHILE in visual mode
	local range = helpers.get_visual_selection()
	local selected_text = helpers.get_selected_text()
	local indent = helpers.get_line_indent(0, range.start_row)

	if selected_text == "" then
		vim.notify("No text selected", vim.log.levels.WARN)
		return
	end

	-- Exit visual mode before UI
	vim.cmd('normal! ' .. vim.api.nvim_replace_termcodes('<Esc>', true, false, true))

	vim.ui.input({ prompt = "Variable name: " }, function(var_name)
		if not var_name or var_name == "" then
			return
		end

		-- Get the filetype to determine variable declaration syntax
		local ft = vim.bo.filetype
		local declaration = ""

		if ft == "lua" then
			declaration = "local " .. var_name .. " = " .. selected_text
		elseif ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
			declaration = "const " .. var_name .. " = " .. selected_text
		elseif ft == "python" then
			declaration = var_name .. " = " .. selected_text
		elseif ft == "java" or ft == "scala" or ft == "kotlin" then
			declaration = "var " .. var_name .. " = " .. selected_text
		else
			declaration = var_name .. " = " .. selected_text
		end

		-- Replace selected text with variable reference
		vim.api.nvim_buf_set_text(0, range.start_row, range.start_col, range.end_row, range.end_col, { var_name })

		-- Insert variable declaration above
		vim.api.nvim_buf_set_lines(0, range.start_row, range.start_row, false, { indent .. declaration })
	end)
end
