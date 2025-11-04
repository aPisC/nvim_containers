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
				is_sticky = true,
				__lualine_hide_id = true,
				__lualine_icon = "✻",
				start_in_insert = true,
				on_open = function(term)
					vim.cmd("startinsert!")
					vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<S-CR>", "<C-j>", { noremap = true, silent = true })
					vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc><esc>", "", {
						callback = function()
							term:close()
						end,
						noremap = true,
						silent = true,
					})
				end,
			})
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
		if has_toggleterm and M.terminal_instance and vim.api.nvim_buf_is_valid(M.terminal_instance.bufnr) then
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
							local mode = vim.fn.mode()
							if mode == "v" or mode == "V" or mode == "\22" then
								vim.cmd(":ClaudeCodeSend")
							else
								vim.cmd(":ClaudeCodeFocus")
							end
						end,
						mode = { "n", "v" },
						description = "Focus Claude Code terminal or send selection",
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
					hide_terminal_in_new_tab = true,
				},
				terminal = {
					provider = toggleterm_provider({
						id = 99,
						direction = "float",
						size = 10,
						autoscroll = true,
						display_name = "Claude Code",
					}),
				},
			}
		end,
	},
}
