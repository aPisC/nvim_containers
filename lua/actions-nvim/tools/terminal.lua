return function()
	local term_id = vim.v.count > 0 and vim.v.count or 1
	local term = require("toggleterm.terminal").get(term_id)
	if term == nil then
		term = require("toggleterm.terminal").Terminal:new({ id = term_id })
	end

	if vim.api.nvim_get_current_buf() == term.bufnr then
		term:close()
	else
		term:open(10, "horizontal")
	end
end

