local Const = require("sider.const")
local Segment = require("sider.segment")

local Sidebar = {
	__prototype = {},
}

function Sidebar.new(props)
	props = vim.tbl_extend("force", {
		position = "left", -- "left" | "right"
	}, props or {})

	local instance = setmetatable({
		segments = {},
		lines_segment_map = {},
		win = nil,
	}, {
		__index = function(_, key)
			return Sidebar.__prototype[key]
		end,
	})

	return instance
end

function Sidebar.__prototype:create_buffer()
	local buf = vim.api.nvim_create_buf(false, true)

	vim.bo[buf].modifiable = false
	vim.bo[buf].filetype = "sider-bar"

	vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
		group = Const.augroup,
		buffer = buf,
		callback = function()
			self:close()
		end,
	})

	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		group = Const.augroup,
		buffer = buf,
		callback = function()
			self:render()
		end,
	})

	vim.keymap.set({ "n" }, "<cr>", function()
		local line = unpack(vim.api.nvim_win_get_cursor(0))
		local segment = self.lines_segment_map[line]
		return segment and segment:focus()
	end, { buffer = buf })

	vim.keymap.set({ "n" }, "<LeftMouse>", function()
		local line = unpack(vim.api.nvim_win_get_cursor(0))
		local segment = self.lines_segment_map[line]
		return segment and segment:focus()
	end, { buffer = buf })

	return buf
end

function Sidebar.__prototype:create_window()
	if self.win and vim.api.nvim_win_is_valid(self.win) then
		vim.api.nvim_win_close(self.win)
	end

	local buffer = self:create_buffer()
	local win = vim.api.nvim_open_win(buffer, true, {
		win = -1,
		split = "left",
		width = 40,
		vertical = true,
		focusable = false,
	})

	vim.wo[win].statuscolumn = ""
	vim.wo[win].number = false
	vim.wo[win].rnu = false
	vim.wo[win].foldcolumn = "0"
	vim.wo[win].winfixwidth = true
	vim.wo[win].winfixheight = true
	vim.wo[win].winfixbuf = true

	self.win = win
	return win
end

function Sidebar.__prototype:try_mount_buf(buf, win)
	for _, segment in ipairs(self.segments) do
		local ft_matches = not segment.ft
			or string.match(vim.bo[buf].filetype, segment.ft)
			or vim.bo[buf].filetype == segment.ft
		local filter_matches = (not segment.filter) or segment.filter(buf, win)
		if (segment.ft or segment.filter) and ft_matches and filter_matches then
			segment:mount(buf, win)
			return true
		end
	end
	return false
end

function Sidebar.__prototype:open()
	if not self.win or not vim.api.nvim_win_is_valid(self.win) then
		self:create_window()
	end

	self:render()
end

function Sidebar.__prototype:update()
	self:render()
end

function Sidebar.__prototype.render(self)
	if not self.win or not vim.api.nvim_win_is_valid(self.win) then
		return
	end

	local buf = vim.api.nvim_win_get_buf(self.win)
	local lines = {}
	local lines_segment = {}

	local segment_width = vim.api.nvim_win_get_width(self.win)
	for _, segment in ipairs(self.segments) do
		local segment_lines = segment:render({ width = segment_width })
		for _, line in ipairs(segment_lines) do
			table.insert(lines, line)
			table.insert(lines_segment, segment)
		end
		if #segment_lines > 0 then
			table.insert(lines, "")
			table.insert(lines_segment, false)
		end
	end

	local sum_height_factor = vim.fn.reduce(
		vim.tbl_map(
			function(line)
				return line.height_factor or 1
			end,
			vim.tbl_filter(function(line)
				return type(line) == "table"
			end, lines)
		),
		function(a, b)
			return a + b
		end,
		0
	)

	local text_line_count = vim.tbl_count(vim.tbl_filter(function(line)
		return type(line) == "string"
	end, lines))

	local height_available = vim.api.nvim_win_get_height(self.win) - text_line_count

	local lines_final = {}
	local lines_segment_final = {}

	for index, line in ipairs(lines) do
		if type(line) == "table" then
			local height = math.ceil(height_available * line.height_factor / sum_height_factor)
			local segment_lines = line.callback({
				win = self.win,
				width = segment_width,
				height = height,
				top = #lines_final - 1,
			}) or {}

			for li = 1, height, 1 do
				table.insert(lines_final, segment_lines[li] or "")
				table.insert(lines_segment_final, lines_segment[index])
			end

			height_available = height_available - height
			sum_height_factor = sum_height_factor - line.height_factor
		else
			table.insert(lines_final, line)
			table.insert(lines_segment_final, lines_segment[index])
		end
	end

	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines_final)
	self.lines_segment_map = lines_segment_final
	vim.bo[buf].modifiable = false
end

function Sidebar.__prototype:unrender()
	for _, segment in ipairs(self.segments) do
		segment:unrender()
	end

	if self.win and vim.api.nvim_win_is_valid(self.win) then
		vim.api.nvim_win_close(self.win)
		self.win = nil
	end
end

function Sidebar.__prototype:add_segment(segment)
	local instance = Segment.new(vim.tbl_extend("force", {
		parent = self,
	}, segment))
	table.insert(self.segments, instance)
end

function Sidebar.__prototype:close()
	for _, segment in ipairs(self.segments) do
		segment:unrender()
	end
	if self.win then
		vim.api.nvim_win_close(self.win, true)
		self.win = nil
	end
end

function Sidebar.__prototype:close_if_empty()
	for _, segment in ipairs(self.segments) do
		if segment:is_open() then
			return
		end
	end
	self:close()
end

function Sidebar.__prototype:get_segment_neighbour(segment, step)
	local index = nil
	local direction = step > 0 and 1 or -1
	for i, s2 in ipairs(self.segments) do
		if not index and s2 == segment then
			index = i
		end
	end

	if not index then
		return nil
	end

	while step ~= 0 do
		local s = self.segments[index + direction]
		if not s then
			return nil
		end
		if s:is_visible() then
			step = step - direction
		end
		index = index + direction
	end

  return self.segments[index]
end

return Sidebar
