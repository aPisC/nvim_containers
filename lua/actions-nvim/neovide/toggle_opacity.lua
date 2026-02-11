return function(opacity_value)
	if not vim.g.neovide then
		return
	end

	local opacity

	if opacity_value and opacity_value ~= "" then
		opacity = tonumber(opacity_value)
		if not opacity or opacity < 0 or opacity > 1 then
			vim.notify("Invalid opacity value. Must be between 0 and 1", vim.log.levels.ERROR)
			return
		end
	else
		opacity = vim.g.neovide_normal_opacity == 1 and 0.8 or 1
	end

	vim.g.neovide_normal_opacity = opacity
end
