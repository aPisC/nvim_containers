function get_overseer_tasks_file(dir)
	local files = require("overseer.files")
	local vscode_dirs = vim.fs.find(".vscode", { upward = true, type = "directory", path = dir, limit = math.huge })
	for _, vscode_dir in ipairs(vscode_dirs) do
		local tasks_file = files.join(vscode_dir, "overseer.json")
		if files.exists(tasks_file) then
			return tasks_file
		end
	end
end

function transform_json_component(component)
	if type(component) == "string" then
		return component
	elseif type(component) == "table" then
		return vim.tbl_extend("force", { component[1] }, component[2] or {})
	else
		return nil
	end
end

return {
	{
		"aPisC/overseer.nvim",
		dependencies = {
			{
				"stevearc/dressing.nvim",
				opts = {},
			},
		},
		opts = {
			custom_templates = {},
			templates = { "builtin" },
			task_list = {
        direction = "left",
				bindings = {
					["o"] = "<CMD>OverseerRun<CR>",
					["i"] = "<CMD>OverseerQuickAction open docked<CR>",
					["e"] = "<CMD>OverseerQuickAction edit<CR>",
					["r"] = "<CMD>OverseerQuickAction restart<CR>",
					["w"] = "<CMD>OverseerQuickAction watch<CR>",
					["x"] = "<CMD>OverseerQuickAction dispose<CR>",
					["f"] = "<CMD>OverseerQuickAction open float<CR>",
					["t"] = "<CMD>OverseerQuickAction open tab<CR>",
					["dd"] = "<CMD>OverseerQuickAction dispose<CR>",
				},
			},
			actions = {
				["open docked"] = {
					desc = "open terminal",
					condition = function(task)
						local bufnr = task:get_bufnr()
						return bufnr and vim.api.nvim_buf_is_valid(bufnr)
					end,
					run = function(task)
						local util = require("overseer.util")

						for _, win in ipairs(vim.api.nvim_list_wins()) do
							local win_bufnr = vim.api.nvim_win_get_buf(win)
							if vim.b[win_bufnr].overseer_edgy then
								vim.api.nvim_win_set_buf(win, task:get_bufnr())
								vim.api.nvim_set_current_win(win)
								util.scroll_to_end(0)
								return
							end
						end

						vim.cmd([[vsplit]])
						util.set_term_window_opts()
						vim.b[task:get_bufnr()].overseer_edgy = true
						vim.api.nvim_win_set_buf(0, task:get_bufnr())
						util.scroll_to_end(0)
					end,
				},
			},
			-- log = {
			--   {
			--     type = "file",
			--     filename = "overseer.log",
			--     level = vim.log.levels.TRACE, -- or TRACE for max verbosity
			--   },
			-- },
		},
		event = "VeryLazy",
		config = function(_, opts)
			local overseer = require("overseer")
			overseer.setup(opts)

			local files = require("overseer.files")
			overseer.register_template({
				name = "overseer.json",
				generator = function(search, cb)
					local task_file_path = get_overseer_tasks_file(vim.fn.getcwd())
					if not task_file_path then
						return cb({})
					end

					local task_file = files.load_json_file(task_file_path)

					local ret = {}
					for _, task in ipairs(task_file.tasks) do
						table.insert(ret, {
							name = task.name,
							desc = task.desc,
							priority = task.priority,
							tags = task.tags,
							params = task.params,
							condition = task.condition,
							builder = function()
								return {
									strategy = task.strategy and transform_json_component(task.strategy) or nil,
									cmd = task.cmd,
									args = task.args,
									cwd = task.cwd,
									env = task.env,
									name = task.name,
									components = vim.tbl_map(
										transform_json_component,
										task.components or { "default" }
									),
									metadata = task.metadata,
								}
							end,
						})
					end

					cb(ret)
				end,

				condition = {
					callback = function(search)
						return get_overseer_tasks_file(vim.fn.getcwd()) ~= nil
					end,
				},

				cache_key = function(opts)
					return get_overseer_tasks_file(vim.fn.getcwd()) or ""
				end,
			})

			for _, template in pairs(opts.custom_templates or {}) do
				overseer.register_template(template)
			end
		end,
	},
}
