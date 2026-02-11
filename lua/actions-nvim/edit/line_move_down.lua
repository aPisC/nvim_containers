return function()
	local mode = vim.fn.mode()
	if mode == "n" or mode == "i" then
		vim.cmd("move +1")
	elseif mode == "v" or mode == "V" or mode == "\22" then
	end
end
