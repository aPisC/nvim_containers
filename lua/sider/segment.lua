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

function Segment.__prototype:create_placeholder_buf()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].swapfile = false
	vim.bo[buf].buflisted = false
	vim.bo[buf].filetype = "sider"

	local lines = {}
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	return buf
end

function Segment.__prototype.configure_window(self, pos)
	local win_config = {
		relative = "win",
		win = pos.win,
		width = pos.width,
		height = pos.height,
		bufpos = { pos.top, pos.left },
		focusable = true,
		zindex = 2,
	}

	if self.win and vim.api.nvim_win_is_valid(self.win) then
		vim.api.nvim_win_set_config(self.win, win_config)
	else
		local win = vim.api.nvim_open_win(self.buf, false, win_config)
		if self.win == -2 then
			vim.api.nvim_set_current_win(win)
		end
    self.buf = nil
		self.win = win
	end
end

function Segment.__prototype:mount(buf, win)
	if not win or not vim.api.nvim_win_is_valid(win) then
		return
	end
	if self.win == win then
		return
	end

	-- if self.win and tostring(self.win) ~= tostring(win) and vim.api.nvim_win_is_valid(self.win) then
	-- 	print("closing window" .. self.win .. " for buf " .. buf .. " and opening window " .. win)
	-- 	-- vim.api.nvim_win_close(self.win, true)
	-- end

	-- vim.bo[buf].key = value
	vim.w[win]["sider-win"] = true

	vim.api.nvim_create_autocmd({ "WinClosed" }, {
		buffer = buf,
		once = true,
		group = Const.augroup,
		callback = function(event)
			self.win = nil
			self.parent:render()
			self.parent:close_if_empty()
		end,
	})

	for _, map in ipairs(Const.segment_mappings) do
		vim.keymap.set(map[1], map[2], function()
			map[3](self)
		end, { buffer = buf })
	end

	for key, value in pairs(Const.sider_segment_win_opts) do
		vim.wo[win][key] = value
	end
	vim.api.nvim_win_set_hl_ns(win, Const.namespace)

	self.win = win
end

function Segment.__prototype:unrender()
	if self.win and vim.api.nvim_win_is_valid(self.win) then
		self.buf = vim.api.nvim_win_get_buf(self.win)
		vim.api.nvim_win_close(self.win, true)
		self.win = -1
	end
end

function Segment.__prototype:close()
	if self.win and vim.api.nvim_win_is_valid(self.win) then
		vim.api.nvim_win_close(self.win, true)
	end
	self.win = nil
	self.parent:render()
	self.parent:close_if_empty()
end

function Segment.__prototype:is_open()
	return self.win and vim.api.nvim_win_is_valid(self.win)
end

function Segment.__prototype:render(props)
	if self.win and self.win < 0 then
		if not self.buf or not vim.api.nvim_buf_is_valid(self.buf) then
			self.buf = nil
			self.win = nil
			if self.open then
				self:open()
			end
		end
	elseif self.win and not vim.api.nvim_win_is_valid(self.win) then
		self.win = nil
		if self.open then
			self:open()
		end
	end

	local lines = {}

	local title = vim.is_callable(self.title) and self.title(self.buf, self.win) or self.title

	table.insert(lines, title)

	if self.win then
		table.insert(lines, {
			callback = function(window_props)
				self:configure_window({
					win = window_props.win,
					width = window_props.width,
					height = window_props.height,
					top = window_props.top,
					left = 0,
				})
			end,
			height_factor = self.height_factor,
		})
	end

	return lines
end



function Segment.__prototype:focus()
	if self.win and vim.api.nvim_win_is_valid(self.win) then
		vim.api.nvim_set_current_win(self.win)
	-- elseif self.buf and vim.api.nvim_buf_is_valid(self.buf) then
	-- 	self.win = -2
	-- 	self.parent:render()
	elseif self.open then
		if type(self.open) == "string" then
			vim.cmd(self.open)
		elseif vim.is_callable(self.open) then
			self:open()
		end
	end
end

return Segment
