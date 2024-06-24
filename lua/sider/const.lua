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
}

Const.namespace = vim.api.nvim_create_namespace("sider")

Const.augroup = vim.api.nvim_create_augroup("sider", { clear = true })

return Const
