return function()
	local mode = vim.fn.mode()
	if mode == "n" or mode == "i" then
		vim.cmd("move -2")
	end
end
