local Const = {}



Const.sider_segment_buf_opts = {
}

Const.sider_segment_win_opts = {
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
