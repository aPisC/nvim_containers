local Const = require("sider.const")
local Segment = require("sider.segment")

local Sidebar = {
	__prototype = {},
}

function Sidebar.__prototype:create_buffer()
	self.buf = vim.api.nvim_create_buf(false, true)
	for k, v in pairs(self.buf_opts) do
		vim.bo[self.buf][k] = v
	end

	vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
		group = Const.augroup,
		buffer = self.buf,
		callback = function()
			self:close()
		end,
	})

	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		group = Const.augroup,
		buffer = self.buf,
		callback = function()
			self:render()
		end,
	})

  vim.keymap.set({"n"}, "<cr>", function ()
    local line = unpack(vim.api.nvim_win_get_cursor(0))
    if self.lines_segment_map[line] then
      self.lines_segment_map[line]:focus()
    end
  end, {buffer = self.buf})
end

function Sidebar.__prototype:create_window()
	self.win = vim.api.nvim_open_win(self.buf, true, self.win_config)
	for k, v in pairs(self.win_opts) do
		vim.wo[self.win][k] = v
	end
end

function Sidebar.new(props)
	props = props or {}

	local instance = setmetatable({
		segments = {},
		buf_opts = vim.tbl_extend("force", {}, Const.sider_buf_opts, props.buf_opts or {}),
		win_opts = vim.tbl_extend("force", {}, Const.sider_win_opts, props.win_opts or {}),
		win_config = vim.tbl_extend("force", {}, Const.sider_win_config, props.win_config or {}),
    lines_segment_map = {},
		buf = nil,
		win = nil,
	}, {
		__index = function(_, key)
			return Sidebar.__prototype[key]
		end,
	})

	return instance
end

function Sidebar.__prototype:try_mount_buf(buf)
	local win = vim.fn.bufwinid(buf)
	for _, segment in ipairs(self.segments) do
		if segment.condition(buf, win) then
			segment:mount(buf, win)
			return true
		end
	end
	return false
end

function Sidebar.__prototype:get_segment_for_buf(buf)
	return vim.tbl_filter(function(segment)
		return segment.buf == buf
	end, self.segments)[1]
end

function Sidebar.__prototype:get_template_for_buf(buf)
	if vim.bo[buf].filetype == "neo-tree" then
		return {}
	end
	return nil
end

function Sidebar.__prototype:open()
	if not self.buf or not vim.api.nvim_buf_is_valid(self.buf) then
		self:create_buffer()
	end

	if not self.win or not vim.api.nvim_win_is_valid(self.win) then
		self:create_window()
	end

	self:render()
end

function Sidebar.__prototype:update()
	self:render()
end

function Sidebar.__prototype.render(self)
	if not self.buf then return end
	if not self.win then return end
	if not vim.api.nvim_buf_is_valid(self.buf) then return end
	if not vim.api.nvim_win_is_valid(self.win) then return end


  local has_open_segment = false
	local lines = {}
  local lines_segment = {}

	local segment_width = vim.api.nvim_win_get_width(self.win)
	for _, segment in ipairs(self.segments) do
    has_open_segment = has_open_segment or segment:is_open()
		local segment_lines = segment:render({ width = segment_width })
		for _, line in ipairs(segment_lines) do
			table.insert(lines, line)
      table.insert(lines_segment, segment)
		end
	end

  if not has_open_segment then
    self:close()
    return
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
			line.callback({
				win = self.win,
				width = segment_width,
				height = height,
				top = #lines_final - 1,
			})
			for _ = 1, height, 1 do
				table.insert(lines_final, "")
        table.insert(lines_segment_final, lines_segment[index])
			end

			height_available = height_available - height
			sum_height_factor = sum_height_factor - line.height_factor
		else
			table.insert(lines_final, line)
      table.insert(lines_segment_final, lines_segment[index])
		end
	end

	vim.bo[self.buf].modifiable = true
	vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines_final)
  self.lines_segment_map = lines_segment_final
	vim.bo[self.buf].modifiable = false
end

function Sidebar.__prototype:add_segment(segment)
	local instance = Segment.new(vim.tbl_extend("force", {
		parent = self,
	}, segment))
	table.insert(self.segments, instance)
end

function Sidebar.__prototype:close()
	for _, segment in ipairs(self.segments) do
		segment:clear()
	end
  if self.win then
    vim.api.nvim_win_close(self.win, true)
    self.win = nil
  end
end

function Sidebar.__prototype:get_segment_neighbour(segment, step)
  for i, s2 in ipairs(self.segments) do
    if s2 == segment then
      return self.segments[i + step]
    end
  end
end

return Sidebar
