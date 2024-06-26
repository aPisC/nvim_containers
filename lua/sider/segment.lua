local Const = require("sider.const")

local Segment = {
	__prototype = {},
}

function Segment.new(segment)
	return setmetatable({
		win = nil,
		buf = nil,
		title = segment.title,
		condition = segment.condition,
		height_factor = segment.height_factor or 1,
    open = segment.open,
    parent = segment.parent,
	}, { __index = Segment.__prototype })
end

function Segment.__prototype.configure_window(self, pos)
	if not self.buf then return end

	if self.win and not vim.api.nvim_win_is_valid(self.win) then
		self.win = nil
	end

	local win_config = {
		relative = "win",
		win = pos.win,
		width = pos.width,
		height = pos.height,
		bufpos = { pos.top, pos.left },
		focusable = true,
		zindex = 2,
	}

	if self.win then
		vim.api.nvim_win_set_config(self.win, win_config)
	else
		self.win = vim.api.nvim_open_win(self.buf, false, win_config)
	end
end

function Segment.__prototype:mount(buf, win)
	local is_valid = win and buf and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_win_is_valid(win)

	if not is_valid then
		return
	end
	if self.buf == buf and self.win == win then
		return
	end

	if self.win and self.win ~= win and vim.api.nvim_win_is_valid(self.win) then
		vim.api.nvim_win_close(self.win)
	end

	-- TODO: add window and buffer exit events here
  vim.api.nvim_create_autocmd({"BufWinLeave"}, {
    buffer = buf,
    once = true,
    group = Const.augroup,
    callback = function()
      self.win = nil
      self.parent:render()
    end
  })

  for _ , map in ipairs(Const.segment_mappings) do
    vim.keymap.set(map[1], map[2], function() map[3](self) end, {buffer=buf})
  end

	self.buf = buf
	self.win = win
end

function Segment.__prototype:clear()
	if self.win and vim.api.nvim_win_is_valid(self.win) then
		vim.api.nvim_win_close(self.win, true)
		self.win = nil
	end
end

function Segment.__prototype:close()
	if self.win and vim.api.nvim_win_is_valid(self.win) then
		vim.api.nvim_win_close(self.win, true)
		self.win = nil
	end
end

function Segment.__prototype:is_open()
	return self.win and self.buf and vim.api.nvim_buf_is_valid(self.buf) and vim.api.nvim_win_is_valid(self.win)
end

function Segment.__prototype:render(props)
	local lines = {}

	local title = vim.is_callable(self.title) and self.title(self.buf, self.win) or self.title

	table.insert(lines, title)

	if self.win then
		table.insert(lines, {callback = function(window_props)
			self:configure_window({
				win = window_props.win,
				width = window_props.width,
				height = window_props.height,
				top = window_props.top,
				left = 0,
			})
		end, height_factor = self.height_factor})
	end


	return lines
end

function Segment.__prototype:focus()
  if self.win then
    vim.api.nvim_set_current_win(self.win)
  elseif self.buf and vim.api.nvim_buf_is_valid(self.buf) then
    self.win = -1
    self.parent:render()
  elseif self.open then
    if type(self.open) == "string" then
      vim.cmd(self.open)
    elseif vim.is_callable(self.open) then
      self.open()
    end
  end
end

return Segment
