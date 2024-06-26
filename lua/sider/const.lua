local Const = {}

Const.sider_buf_opts = {
	modifiable = false,
	filetype = "sider-bar",
}

Const.sider_win_opts = {
	statuscolumn = "",
	number = false,
	rnu = false,
	foldcolumn = "0",
	winfixwidth = true,
	winfixheight = true,
	winfixbuf = true,
}

Const.sider_win_config = {
	win = -1,
	split = "left",
	width = 40,
	vertical = true,
	focusable = false,
}

Const.namespace = vim.api.nvim_create_namespace("sider")

Const.augroup = vim.api.nvim_create_augroup("sider", { clear = true })

Const.segment_mappings = {
	{
		"n",
		"<C-q>",
		function(segment)
      segment.parent:close()
		end,
	},
	{
		"n",
		"q",
		function(segment)
      segment:close()
		end,
	},
	{
		"n",
		"<tab>",
		function(segment)
      local step = vim.v.count > 0 and vim.v.count or 1
      local other = segment.parent:get_segment_neighbour(segment, step)
      if other then other:focus() end
		end,
	},
	{
		"n",
		"<S-tab>",
		function(segment)
      local step = vim.v.count > 0 and vim.v.count or 1
      local other = segment.parent:get_segment_neighbour(segment, -step)
      if other then other:focus() end
		end,
	},
}

return Const
