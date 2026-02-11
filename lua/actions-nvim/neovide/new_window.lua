return function()
	if not vim.g.neovide then
		return
	end
	vim.fn.jobstart({ "neovide", "--no-multigrid" }, { detach = true, cwd = vim.env.HOME })
end
