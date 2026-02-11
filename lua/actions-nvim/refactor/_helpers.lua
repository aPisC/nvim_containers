local M = {}

-- Get visual selection range
-- Must be called while still in visual mode
function M.get_visual_selection()
	-- Get current visual selection using vim.region which works in visual mode
	-- This is more reliable than getpos for visual selections
	local mode = vim.fn.mode()

	-- If not in visual mode, try using marks (for when called right after visual mode)
	if mode ~= 'v' and mode ~= 'V' and mode ~= '\22' then
		local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
		local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))

		-- Check if marks are valid
		if start_row == 0 or end_row == 0 then
			error("Visual marks not available. This function must be called in or immediately after visual mode.")
		end

		-- Convert to 0-indexed
		start_row = start_row - 1
		end_row = end_row - 1
		start_col = start_col - 1
		-- end_col stays as-is (1-indexed inclusive -> 0-indexed exclusive)

		return {
			start_row = start_row,
			start_col = start_col,
			end_row = end_row,
			end_col = end_col,
		}
	end

	-- In visual mode, handle different visual modes
	if mode == 'V' then
		-- Line-wise visual mode: select entire lines
		local _, start_row, _, _ = unpack(vim.fn.getpos("v"))
		local cursor_row, _ = unpack(vim.api.nvim_win_get_cursor(0))

		-- Determine which is start and which is end
		local actual_start_row, actual_end_row
		if start_row <= cursor_row then
			actual_start_row = start_row - 1
			actual_end_row = cursor_row - 1
		else
			actual_start_row = cursor_row - 1
			actual_end_row = start_row - 1
		end

		-- For line-wise, always select from column 0 to end of line
		local end_line = vim.api.nvim_buf_get_lines(0, actual_end_row, actual_end_row + 1, false)[1]
		return {
			start_row = actual_start_row,
			start_col = 0,
			end_row = actual_end_row,
			end_col = #end_line,
		}
	else
		-- Character-wise or block-wise visual mode
		local _, start_row, start_col, _ = unpack(vim.fn.getpos("v"))
		local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))

		-- getpos returns 1-indexed, nvim_win_get_cursor returns 0-indexed (row is 1-indexed, col is 0-indexed)
		-- We need to make sure end_col is exclusive (one past the last character)

		-- Determine which is start and which is end
		local start_pos, end_pos
		if start_row < cursor_row or (start_row == cursor_row and start_col <= cursor_col + 1) then
			start_pos = {start_row - 1, start_col - 1}
			-- cursor_col is 0-indexed, we need to add 1 to make it exclusive (one past the cursor)
			end_pos = {cursor_row - 1, cursor_col + 1}
		else
			start_pos = {cursor_row - 1, cursor_col}
			end_pos = {start_row - 1, start_col}
		end

		return {
			start_row = start_pos[1],
			start_col = start_pos[2],
			end_row = end_pos[1],
			end_col = end_pos[2],
		}
	end
end

-- Get selected text
function M.get_selected_text()
	local range = M.get_visual_selection()
	local lines = vim.api.nvim_buf_get_lines(0, range.start_row, range.end_row + 1, false)

	if #lines == 0 then
		return ""
	end

	-- Convert 0-indexed columns to 1-indexed for Lua string operations
	local start_col_lua = range.start_col + 1
	local end_col_lua = range.end_col

	-- Handle single line selection
	if #lines == 1 then
		return lines[1]:sub(start_col_lua, end_col_lua)
	end

	-- Handle multi-line selection
	lines[1] = lines[1]:sub(start_col_lua)
	lines[#lines] = lines[#lines]:sub(1, end_col_lua)

	return table.concat(lines, "\n")
end

-- Get indentation of current line
function M.get_current_indent()
	local line = vim.api.nvim_get_current_line()
	local indent = line:match("^%s*")
	return indent or ""
end

-- Get indentation of a specific line
function M.get_line_indent(bufnr, line_num)
	local line = vim.api.nvim_buf_get_lines(bufnr, line_num, line_num + 1, false)[1]
	if not line then
		return ""
	end
	local indent = line:match("^%s*")
	return indent or ""
end

-- Apply indentation to multiline text
function M.indent_text(text, indent)
	local lines = vim.split(text, "\n")
	for i, line in ipairs(lines) do
		if line ~= "" then
			lines[i] = indent .. line
		end
	end
	return table.concat(lines, "\n")
end

-- Get treesitter node under cursor
function M.get_node_at_cursor()
	local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
	if not ok then
		return nil
	end
	return ts_utils.get_node_at_cursor()
end

-- Find parent node of specific type
function M.find_parent_node(node, node_type)
	if not node then
		return nil
	end

	local current = node
	while current do
		if current:type() == node_type then
			return current
		end
		current = current:parent()
	end
	return nil
end

return M
