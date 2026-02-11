return function()
	if not vim.g.neovide then
		return
	end
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
end
