function toggleterm_repl()
	local instance = nil

	function _ensure_instance()
		if instance and vim.api.nvim_buf_is_valid(instance.bufnr) then
			return
		end

		local codepatch = require("utils.codepatch")
		local dap_repl = require("dap.repl")
		local repl = codepatch.find_upvalue(dap_repl.clear, "repl")
		local Terminal = require("toggleterm.terminal").Terminal

		local get_bufnr = function()
			if not repl.buf then
				repl.buf = repl._init_buf()
			end
			return repl.buf
		end

		if not instance then
			instance = Terminal:new({ bufnr = get_bufnr(), id = 98 })
			instance.__lualine_icon = ""
			instance.__lualine_hide_id = true
			instance:__add()
		end

		if not vim.api.nvim_buf_is_valid(instance.bufnr) then
			instance.bufnr = get_bufnr()
		end
	end

	return function()
		_ensure_instance()
		if vim.api.nvim_get_current_buf() == instance.bufnr then
			instance:close()
		else
			instance:open(10, "horizontal")
		end
	end
end

local _toggleterm_repl = toggleterm_repl()

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
			{
				"aPisC/actions-nvim",
				opts = {
					["debugger.continue"] = function()
						require("dap").continue()
					end,
					["debugger.run_last"] = function()
						require("dap").run_last()
					end,
					["debugger.stop"] = function()
						require("dap").terminate()
					end,
					["debugger.toggle_breakpoint"] = function()
						require("dap").toggle_breakpoint()
					end,
					["debugger.conditional_breakpoint"] = function()
						local condition = vim.fn.input("Condition: ")
						if condition ~= "" then
							require("dap").set_breakpoint(condition)
							return
						end

						local logMessage = vim.fn.input("Log message: ")
						if logMessage ~= "" then
							require("dap").set_breakpoint(nil, nil, logMessage)
							return
						end

						require("dap").set_breakpoint()
					end,
          ["debugger.step_over"] = function ()
            require("dap").step_over()
          end,
          ["debugger.step_into"] = function ()
            require("dap").step_into()
          end,
          ["debugger.step_out"] = function ()
            require("dap").step_out()
          end,
          ["tools.debugger"] = _toggleterm_repl,
				},
			},
		},
		opts = {
			dap_adapters = {},
			dap_configurations = {},
			_initialize_lazy = {
				debugger = function(opts)
					local Promise = require("promise")
					return Promise.new(function(resolve)
						for adapter_name, adapter in pairs(opts.dap_adapters or {}) do
							require("dap").adapters[adapter_name] = adapter
						end
						for configuration_name, configuration in pairs(opts.dap_configurations or {}) do
							require("dap").configurations[configuration_name] = configuration
						end
						resolve()
					end)
				end,
			},
			_initialize = {
				debugger = function(plug, opts)
					for adapter_name, adapter in pairs(opts.dap_adapters or {}) do
						require("dap").adapters[adapter_name] = adapter
					end
					for configuration_name, configuration in pairs(opts.dap_configurations or {}) do
						require("dap").configurations[configuration_name] = configuration
					end
				end,
			},
		},
	},
	{
		-- DAP
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {},
		commands = {
			{
				"DapRun",
				function()
					require("dap").run()
				end,
			},
			{
				"DapRunLast",
				function()
					require("dap").run_last()
				end,
			},
			{
				"DapRepl",
				function()
					_toggleterm_repl.toggle(10, "horizontal")
				end,
			},
			{
				"DapUi",
				function()
					require("dapui").toggle()
				end,
			},
			{
				"DapStacks",
				function()
					require("dapui").float_element("stacks", { enter = true })
				end,
			},
			{
				"DapWatch",
				function()
					require("dapui").float_element("watches", { enter = true })
				end,
			},
			{
				"DapLocals",
				function()
					require("dapui").float_element("scopes", { enter = true })
				end,
			},
			{
				"DapBreakpoints",
				function()
					require("dapui").float_element("breakpoints", { enter = true })
				end,
			},
			{
				"DapEval",
				function()
					require("dapui").eval()
				end,
			},
		},
		config = function(plug)
			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			for _, c in ipairs(plug.commands) do
				vim.api.nvim_create_user_command(c[1], c[2], c[3] or { nargs = 0, force = true })
			end
		end,
	},
	{
		-- DAP UI
		"rcarriga/nvim-dap-ui",
		dependencies = { { "mfussenegger/nvim-dap" }, { "nvim-neotest/nvim-nio" } },
		lazy = true,
		opts = {
			layouts = {
				{
					elements = {
						{ id = "breakpoints", size = 10 },
						{ id = "watches", size = 0.33 },
						{ id = "scopes", size = 0.33 },
					},
					size = 30,
					position = "left",
				},
			},
			icons = {
				collapsed = "",
				current_frame = "",
				expanded = "",
			},
			controls = {
				element = "scopes",
			},
			expand_lines = false,
		},
	},
}
