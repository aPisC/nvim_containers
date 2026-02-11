-- Helper: Prompt for placeholder values sequentially
local function fill_placeholders(template_text, placeholders, callback)
	local placeholder_names = vim.tbl_keys(placeholders)
	if #placeholder_names == 0 then
		callback(template_text)
		return
	end

	local filled = template_text

	local function prompt_next(index)
		if index > #placeholder_names then
			callback(filled)
			return
		end

		local key = placeholder_names[index]
		local default = placeholders[key]

		vim.ui.input({
			prompt = key .. ": ",
			default = default,
		}, function(value)
			if value then
				filled = filled:gsub("${" .. key .. "}", value)
			end
			prompt_next(index + 1)
		end)
	end

	prompt_next(1)
end

-- Helper: Generate the surrounded content from template and selection
local function generate_surrounded_content(filled_template, selected_text, range, base_indent)
	-- Determine if whole lines are selected
	local start_line = vim.api.nvim_buf_get_lines(0, range.start_row, range.start_row + 1, false)[1]
	local end_line = vim.api.nvim_buf_get_lines(0, range.end_row, range.end_row + 1, false)[1]

	local prefix_before_selection = start_line:sub(1, range.start_col)
	local suffix_after_selection = end_line:sub(range.end_col + 1)

	local starts_at_line_beginning = prefix_before_selection:match("^%s*$") ~= nil
	local ends_at_line_end = suffix_after_selection:match("^%s*$") ~= nil
	local whole_lines_selected = starts_at_line_beginning and ends_at_line_end

	-- Find where ${SELECTION} is and capture its indentation within the template
	local template_lines = vim.split(filled_template, "\n", { plain = true })
	local selection_line_indent = ""
	for _, line in ipairs(template_lines) do
		if line:find("${SELECTION}", 1, true) then
			local before_selection = line:sub(1, line:find("${SELECTION}", 1, true) - 1)
			selection_line_indent = before_selection:match("^(%s*)") or ""
			break
		end
	end

	-- Indent the selected text according to template indentation
	local selection_lines = vim.split(selected_text, "\n")
	local indented_selection_lines = {}
	for _, line in ipairs(selection_lines) do
		if line ~= "" then
			table.insert(indented_selection_lines, selection_line_indent .. line)
		else
			table.insert(indented_selection_lines, "")
		end
	end
	local indented_selection = table.concat(indented_selection_lines, "\n")

	-- Replace ${SELECTION} placeholder
	local escaped_pattern = string.gsub("${SELECTION}", "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
	local escaped_replacement = indented_selection:gsub("%%", "%%%%")
	filled_template = filled_template:gsub(escaped_pattern, escaped_replacement, 1)

	-- Build final lines
	template_lines = vim.split(filled_template, "\n", { plain = true })
	local final_lines = {}

	if whole_lines_selected then
		-- Whole lines: apply base indentation to all lines
		for _, line in ipairs(template_lines) do
			if line ~= "" then
				table.insert(final_lines, base_indent .. line)
			else
				table.insert(final_lines, "")
			end
		end
		return final_lines, whole_lines_selected, end_line
	else
		-- Partial line: keep prefix on first line, suffix on last line
		for i, line in ipairs(template_lines) do
			if i == 1 then
				table.insert(final_lines, prefix_before_selection .. line)
			else
				if line ~= "" then
					table.insert(final_lines, base_indent .. line)
				else
					table.insert(final_lines, "")
				end
			end
		end

		-- Append suffix to last line if needed
		if #final_lines > 0 and suffix_after_selection ~= "" and not suffix_after_selection:match("^%s*$") then
			final_lines[#final_lines] = final_lines[#final_lines] .. suffix_after_selection
		end

		return final_lines, whole_lines_selected
	end
end

-- Helper: Replace the range with generated content
local function replace_with_content(range, final_lines, whole_lines_selected, end_line)
	if whole_lines_selected then
		-- Replace entire lines
		vim.api.nvim_buf_set_text(
			0,
			range.start_row,
			0,
			range.end_row,
			#end_line,
			final_lines
		)
	else
		-- Replace from actual selection boundaries
		vim.api.nvim_buf_set_text(
			0,
			range.start_row,
			range.start_col,
			range.end_row,
			range.end_col,
			final_lines
		)
	end
end

return function()
	local helpers = require("actions-nvim.refactor._helpers")
	local templates_module = require("actions-nvim.generate._surround_templates")

	-- Check if in visual mode
	local mode = vim.fn.mode()
	if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
		vim.notify("Surround with requires visual selection", vim.log.levels.WARN)
		return
	end

	-- Capture range and text WHILE STILL in visual mode
	local range = helpers.get_visual_selection()
	local selected_text = helpers.get_selected_text()
	local base_indent = helpers.get_line_indent(0, range.start_row)

	-- Exit visual mode before UI
	vim.cmd('normal! ' .. vim.api.nvim_replace_termcodes('<Esc>', true, false, true))

	local filetype = vim.bo.filetype
	local templates = templates_module.get_templates_for_filetype(filetype)

	if #templates == 0 then
		vim.notify("No surround templates available for filetype: " .. filetype, vim.log.levels.WARN)
		return
	end

	vim.ui.select(templates, {
		prompt = "Surround with:",
		format_item = function(template)
			return template.name
		end,
	}, function(selected_template)
		if not selected_template then
			return
		end

		fill_placeholders(selected_template.template, selected_template.placeholders, function(filled_template)
			local final_lines, whole_lines_selected, end_line = generate_surrounded_content(
				filled_template,
				selected_text,
				range,
				base_indent
			)
			replace_with_content(range, final_lines, whole_lines_selected, end_line)
		end)
	end)
end
