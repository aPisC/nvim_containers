local function toggleterm_provider(toggleterm_opts)
	local has_toggleterm, toggleterm = pcall(require, "toggleterm.terminal")
	local Terminal = toggleterm.Terminal

	local M = {
		terminal_instance = nil,
	}

	-- Helper function to ensure terminal instance exists
	function M._ensure_terminal(cmd_string, env_table, opts)
		if not M.terminal_instance then
			toggleterm_opts = toggleterm_opts or {}
			M.terminal_instance = Terminal:new({
				cmd = cmd_string,
				env = env_table,
				id = toggleterm_opts.id,
				autoscroll = toggleterm_opts.autoscroll or true,
				direction = toggleterm_opts.direction or "horizontal",
				close_on_exit = false,
			})
			M.terminal_instance.__lualine_icon = "✻"
			M.terminal_instance.__lualine_hide_id = "✻"
		end
	end

	function M.is_available()
		return has_toggleterm
	end

	function M.setup()
		-- No additional setup needed as toggleterm is already configured
	end

	function M.open(cmd_string, env_table, opts, focus)
		---Open a terminal using toggleterm
		if not has_toggleterm then
			return
		end

		M._ensure_terminal(cmd_string, env_table, opts)
		if not M.terminal_instance:is_open() then
			M.terminal_instance:open(toggleterm_opts.size, toggleterm_opts.direction)
		end
		if focus then
			M.terminal_instance:focus()
		end
	end

	function M.close()
		---Close the terminal
		if not has_toggleterm or not M.terminal_instance then
			return
		end
		M.terminal_instance:close()
	end

	function M.simple_toggle(cmd_string, env_table, opts)
		---Simple toggle: always show/hide terminal regardless of focus
		if not has_toggleterm then
			return
		end

		M._ensure_terminal(cmd_string, env_table, opts)
		M.terminal_instance:toggle(toggleterm_opts.size, toggleterm_opts.direction)
	end

	function M.focus_toggle(cmd_string, env_table, config)
		---Smart focus toggle: switches to terminal if not focused, hides if currently focused
		if not has_toggleterm then
			return
		end

		M._ensure_terminal(cmd_string, env_table, config)

		if M.terminal_instance:is_focused() then
			M.terminal_instance:close()
		else
			if not M.terminal_instance:is_open() then
				M.terminal_instance:open(toggleterm_opts.size, toggleterm_opts.direction)
			end
			M.terminal_instance:focus()
		end
	end

	function M.get_active_bufnr()
		---Get the active terminal buffer number
		if  has_toggleterm and M.terminal_instance and vim.api.nvim_buf_is_valid(M.terminal_instance.bufnr)  then
			return M.terminal_instance.bufnr
		end
	end

	return M
end

return {
	{
		"mrjones2014/legendary.nvim",
		opts = {
			claude_code = {
				itemgroup = "claude_code",
				icon = "📟",
				description = "Claude Code",
				keymaps = {
					{
						"<C-g>c",
						function()
							vim.cmd(":ClaudeCodeFocus")
						end,
						mode = { "n" },
						description = "Focus Claude Code terminal",
					},
				},
			},
		},
	},
	{
		"coder/claudecode.nvim",
		dependencies = { "akinsho/toggleterm.nvim" },
		opts = function()
			return {
				diff_opts = {
					open_in_new_tab = true,
				},
				terminal = {
					provider = toggleterm_provider({
						id = 9,
						direction = "vertical",
						size = 80,
						autoscroll = true,
						display_name = "Claude Code",
					}),
				},
			}
		end,
	},
}
