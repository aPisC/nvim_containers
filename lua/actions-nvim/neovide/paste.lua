return function()
	if not vim.g.neovide then
		return
	end

	local mode = vim.fn.mode()

	if mode == "i" then
		-- Insert mode: temporarily enable paste mode
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-R>+", true, false, true), "n", false)
	elseif mode == "c" then
		-- Command mode: insert register content
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-R>+", true, false, true), "n", false)
	elseif mode == "t" then
		-- Terminal mode: paste into terminal
		vim.cmd("normal! pi")
	end
end
