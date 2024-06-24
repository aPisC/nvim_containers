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
			self:hide()
		end,
	})

	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		group = Const.augroup,
		buffer = self.buf,
		callback = function(event)
			print(vim.inspect(event))
			print(vim.inspect(vim.v.event))
			self:render()
		end,
	})
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
	if not self.buf then
		return
	end
	if not self.win then
		return
	end
	if not vim.api.nvim_buf_is_valid(self.buf) then
		return
	end
	if not vim.api.nvim_win_is_valid(self.win) then
		return
	end

	-- vim.notify("render")

	local lines = {}

	for _, segment in ipairs(self.segments) do
		local title = vim.is_callable(segment.title) and segment.title(segment.buf, segment.win) or segment.title
		local segment_height = 20
		local segment_width = vim.api.nvim_win_get_width(self.win)

		table.insert(lines, title)
		segment:open({
			win = self.win,
			width = segment_width,
			height = segment_height,
			top = #lines - 1,
			left = 0,
		})

		for _ = 1, segment_height, 1 do
			table.insert(lines, " |")
		end
	end

  -- for _, segment in ipairs(self.segments) do
		-- local segment_width = vim.api.nvim_win_get_width(self.win)

  --   local segment_lines = segment:render({
  --     width = segment_width,
  --     top = #lines
  --   })

		-- for _, line in ipairs(segment_lines) do
			-- table.insert(lines, line)
		-- end
	-- end

	vim.bo[self.buf].modifiable = true
	vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
	vim.bo[self.buf].modifiable = false
end

function Sidebar.__prototype:add_segment(segment)
  local instance = Segment.new(segment)
	table.insert(self.segments, instance)
end


function Sidebar.__prototype:hide()
	vim.notify("hide")
	for _, segment in ipairs(self.segments) do
		segment:clear()
	end
end

return Sidebar
