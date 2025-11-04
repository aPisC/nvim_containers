local M = {}

local note_template = [[# Notes for %s

Created: %s

## Tasks
- [ ]

## Notes

]]

local function get_note_folder(dir_override)
	-- Get the notes directory path
	local notes_dir = vim.fn.stdpath("data") .. "/notes"

	local cwd, folder_name
	if dir_override then
		-- Use provided directory name directly (already escaped)
		folder_name = dir_override
		cwd = dir_override
	else
		-- Get current working directory and escape special characters for folder name
		cwd = vim.fn.getcwd()
		folder_name = cwd:gsub("[^%w]", "_")
	end

	local note_folder = notes_dir .. "/" .. folder_name

	-- Create the note folder
	vim.fn.mkdir(note_folder, "p")

	return note_folder, cwd
end

local function create_note_file(note_path, cwd)
	-- Create file with template if it doesn't exist
	if vim.fn.filereadable(note_path) == 0 then
		local template = string.format(note_template, cwd, os.date("%Y-%m-%d %H:%M:%S"))

		local file = io.open(note_path, "w")
		if file then
			file:write(template)
			file:close()
		end
	end
end

local function load_note_buffer(note_path)
	-- Find or create buffer for the note file
	local buf = vim.fn.bufnr(note_path)
	if buf == -1 then
		-- Buffer doesn't exist, create it and load the file (unlisted, scratch)
		buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_call(buf, function()
			vim.cmd("edit " .. vim.fn.fnameescape(note_path))
		end)
		-- Mark as unlisted and set buffer options to hide from buffer lists
		vim.api.nvim_buf_set_option(buf, "buflisted", false)
		vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
	else
		-- Buffer exists, ensure it's loaded and unlisted
		if not vim.api.nvim_buf_is_loaded(buf) then
			vim.fn.bufload(buf)
		end
		vim.api.nvim_buf_set_option(buf, "buflisted", false)
		vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
	end

	return buf
end

local function open_in_float(buf, note_name)
	-- Create floating window
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	-- Set window-local options for better experience
	vim.api.nvim_win_set_option(win, "number", true)
	vim.api.nvim_win_set_option(win, "relativenumber", true)
	vim.api.nvim_win_set_option(win, "signcolumn", "no")

	-- Set custom winbar with note name
	local display_name = note_name or "index"
	vim.api.nvim_win_set_option(win, "winbar", string.format("  [Note] %s", display_name))

	-- Close the floating window when switching to a non-floating window
	vim.api.nvim_create_autocmd("BufLeave", {
		buffer = buf,
		callback = function()
			-- Schedule to run after the new window/buffer is active
			vim.schedule(function()
				if not vim.api.nvim_win_is_valid(win) then
					return
				end

				local current_win = vim.api.nvim_get_current_win()

				-- Check if current window is floating
				local win_config = vim.api.nvim_win_get_config(current_win)
				local is_floating = win_config.relative and win_config.relative ~= ""

				-- Close note window only if we switched to a non-floating window
				if not is_floating then
					vim.api.nvim_win_close(win, true)
				end
			end)
		end,
	})

	return win
end

local function open_note_file(note_folder, note_name, cwd)
	-- Use provided name or default to index
	local filename = note_name and (note_name .. ".md") or "index.md"
	local note_path = note_folder .. "/" .. filename

	-- Create file if needed
	create_note_file(note_path, cwd)

	-- Load buffer
	local buf = load_note_buffer(note_path)

	-- Open in floating window
	open_in_float(buf, note_name)
end

local function open_note(opts)
	local args = vim.split(opts.args or "", "%s+", { trimempty = true })
	local dir_override, note_name

	if #args == 0 then
		-- No arguments: open index.md in cwd
		dir_override = nil
		note_name = nil
	elseif #args == 1 then
		-- One argument: treat as note_name
		dir_override = nil
		note_name = args[1]
	else
		-- Two or more arguments: first is dir, second is note_name
		dir_override = args[1]
		note_name = args[2]
	end

	local note_folder, cwd = get_note_folder(dir_override)
	open_note_file(note_folder, note_name, cwd)
end

local function list_notes(opts)
	local args = vim.split(opts.args or "", "%s+", { trimempty = true })
	local dir_override = args[1] or nil

	local note_folder, cwd = get_note_folder(dir_override)

	-- Get all markdown files in the note folder
	local files = vim.fn.globpath(note_folder, "*.md", false, true)
	local note_list = {}

	-- Always include index.md
	table.insert(note_list, "index.md")

	-- Add existing files (excluding index.md if already present)
	for _, file in ipairs(files) do
		local filename = vim.fn.fnamemodify(file, ":t")
		if filename ~= "index.md" then
			table.insert(note_list, filename)
		end
	end

	-- Show selection UI
	vim.ui.select(note_list, {
		prompt = "Select a note:",
		format_item = function(item)
			-- Remove .md extension for display
			return item:gsub("%.md$", "")
		end,
	}, function(choice)
		if choice then
			-- Remove .md extension to get note name
			local note_name = choice:gsub("%.md$", "")
			open_note_file(note_folder, note_name, cwd)
		end
	end)
end

function M.setup(opts)
	opts = opts or {}

	-- Register Note command with optional arguments
	vim.api.nvim_create_user_command("Note", open_note, {
		nargs = "*",
		desc = "Open a note. Usage: Note [dir] [note_name]",
	})

	-- Register Notes command to list and select notes
	vim.api.nvim_create_user_command("Notes", list_notes, {
		nargs = "?",
		desc = "List notes. Usage: Notes [dir]",
	})
end

return M
