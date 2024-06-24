local Segment = {
	__prototype = {},
}

function Segment.new(segment)
	return setmetatable({
		win = nil,
		buf = nil,
    title = segment.title,
    condition = segment.condition,
    is_open = segment.is_open or false
	}, { __index = Segment.__prototype })
end

function Segment.__prototype.open(self, pos)
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
    zindex=2,
	}

	if self.win then
		vim.api.nvim_win_set_config(self.win, win_config)
	else
		self.win = vim.api.nvim_open_win(self.buf, false, win_config)
	end
end

function Segment.__prototype:mount(buf, win)
  local is_valid =  win and buf and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_win_is_valid(win)

  if not is_valid then return end
  if self.buf == buf and self.win == win then return end

  if self.win and self.win ~= win and vim.api.nvim_win_is_valid(self.win) then
    vim.api.nvim_win_close(self.win)
  end

  -- TODO: add window and buffer exit events here

  self.buf = buf
  self.win = win
end

function Segment.__prototype:clear()
  if self.win and vim.api.nvim_win_is_valid(self.win) then
    vim.api.nvim_win_close(self.win, true)
    self.win = nil
  end
end

function Segment.__prototype:is_valid()
  return self.win and self.buf and vim.api.nvim_buf_is_valid(self.buf) and vim.api.nvim_win_is_valid(self.win)
end

function Segment.__prototype:render(props)
    local lines = {}

		local title = vim.is_callable(self.title) and self.title(self.buf, self.win) or self.title
		local segment_height = self.win and 20 or 0
		local segment_width = props.width

		table.insert(lines, title)

    if segment_height > 0 then
      self:configure_window({
        win = self.win,
        width = segment_width,
        height = segment_height,
        top = props.top + #lines - 1,
        left = 0,
      })

      for _ = 1, segment_height, 1 do
        table.insert(lines, " |")
      end
    end

    table.insert(lines, "")

    return lines
end

return Segment
