return function()
	-- Similar to extract variable but places at top of file/class
	local helpers = require("actions.refactor._helpers")
	local mode = vim.fn.mode()

	if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
		vim.notify("Extract constant requires visual selection", vim.log.levels.WARN)
		return
	end

	-- Capture WHILE in visual mode
	local range = helpers.get_visual_selection()
	local selected_text = helpers.get_selected_text()

	if selected_text == "" then
		vim.notify("No text selected", vim.log.levels.WARN)
		return
	end

	-- Exit visual mode before UI
	vim.cmd('normal! ' .. vim.api.nvim_replace_termcodes('<Esc>', true, false, true))

	vim.ui.input({ prompt = "Constant name: " }, function(const_name)
		if not const_name or const_name == "" then
			return
		end

		local ft = vim.bo.filetype
		local declaration = ""

		-- Format constant declaration based on filetype
		if ft == "lua" then
			declaration = "local " .. const_name:upper() .. " = " .. selected_text
		elseif ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
			declaration = "const " .. const_name:upper() .. " = " .. selected_text .. ";"
		elseif ft == "python" then
			declaration = const_name:upper() .. " = " .. selected_text
		elseif ft == "java" or ft == "scala" or ft == "kotlin" then
			declaration = "private static final " .. const_name:upper() .. " = " .. selected_text .. ";"
		else
			declaration = const_name:upper() .. " = " .. selected_text
		end

		-- Replace selected text with constant reference
		vim.api.nvim_buf_set_text(0, range.start_row, range.start_col, range.end_row, range.end_col, { const_name:upper() })

		-- Insert constant declaration at top of file (after imports/package)
		-- Find first non-comment, non-import line
		local insert_line = 0
		local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
		for i, line in ipairs(lines) do
			if not line:match("^%s*$")
				and not line:match("^%s*import ")
				and not line:match("^%s*package ")
				and not line:match("^%s*//")
				and not line:match("^%s*#")
				and not line:match("^%s*%-%-") then
				insert_line = i - 1
				break
			end
		end

		vim.api.nvim_buf_set_lines(0, insert_line, insert_line, false, { declaration, "" })
	end)
end
