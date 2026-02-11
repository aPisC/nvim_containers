return function()
	if not vim.g.neovide then
		return
	end
	vim.g.neovide_cursor_animation_length = vim.g.neovide_cursor_animation_length == 0 and 0.13 or 0
	vim.g.neovide_cursor_vfx_mode = vim.g.neovide_cursor_vfx_mode == "" and "pixiedust" or ""
end
