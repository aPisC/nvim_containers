return {
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		opts = {
			animate = { enabled = false },
			-- fix_win_height = false,
			options = {
				left = { size = 40 },
				right = { size = 50 },
				bottom = { size = 10 },
				top = { size = 10 },
			},
			wo = {
				winbar = true,
				winhighlight = "WinBar:EdgyWinBar",
			},
			close_when_all_hidden = true,
			bottom = {
				{
					ft = "toggleterm",
					title = "Terminal",
					size = { height = 10 },
					filter = function(buf, win)
						-- exclude floating windows
						return vim.api.nvim_win_get_config(win).relative == ""
					end,
				},
				{
					title = "Overseer",
					ft = "",
					size = { height = 10 },
					filter = function(buf, win)
						return vim.b[buf] and vim.b[buf].overseer_edgy == true
					end,
				},
				{
					ft = "Trouble",
					title = "Trouble",
					open = "Trouble",
				},
				{
					ft = "help",
					size = { height = 20 },
					title = "Help",
					filter = function(buf)
						return vim.bo[buf].buftype == "help"
					end,
				},
				{
					ft = "dap-repl",
					title = "DAP",
					filter = function(buf, win)
						return vim.api.nvim_win_get_config(win).relative == ""
					end,
				},
				{ ft = "httpResult", title = "HTTP" },
			},
			right = {
				{ ft = "dapui_scopes", title = "Dap Scopes",
					filter = function(buf, win)
						return vim.api.nvim_win_get_config(win).relative == ""
					end, },
				{ ft = "dapui_watches", title = "Dap watches",
					filter = function(buf, win)
						return vim.api.nvim_win_get_config(win).relative == ""
					end, },
				{ ft = "dapui_breakpoints", title = "Dap Breakpoints",
					filter = function(buf, win)
						return vim.api.nvim_win_get_config(win).relative == ""
					end, },
			},
			left = {
				{
					title = "NeoTree",
					ft = "neo-tree",
					size = { height = 0.5 },
					pinned = true,
					open = "Neotree position=left filesystem",
				},
				{
					title = "Overseer",
					ft = "OverseerList",
					pinned = true,
					open = function()
						require("overseer").open()
					end,
				},
				{
					title = "Tests",
					ft = "neotest-summary",
					pinned = true,
					open = function()
						require("neotest").summary.open()
					end,
				},
				{
					title = "DB",
					ft = "dbui",
				},
			},
			keys = {
				["q"] = function(win)
					win:close()
				end,
				["<c-q>"] = function(win)
					win:hide()
				end,
				["Q"] = function(win)
					win.view.edgebar:close()
				end,
				["]w"] = function(win)
					win:next({ visible = true, focus = true })
				end,
				["[w"] = function(win)
					win:prev({ visible = true, focus = true })
				end,
				["]W"] = function(win)
					win:next({ pinned = false, focus = true })
				end,
				["[W"] = function(win)
					win:prev({ pinned = false, focus = true })
				end,
				["<C-w><C-w>"] = function(win)
					win.view.edgebar:close()
				end,
				["<c-w>>"] = function(win)
					win:resize("width", 8)
				end,
				["<c-w><lt>"] = function(win)
					win:resize("width", -8)
				end,
				["<c-w>+"] = function(win)
					win:resize("height", 8)
				end,
				["<c-w>-"] = function(win)
					win:resize("height", -8)
				end,
				["<c-w>="] = function(win)
					win.view.edgebar:equalize()
				end,
			},
		},
		config = function(_, opts)
			require("edgy").setup(opts)
			vim.opt.laststatus = 3
			vim.opt.splitkeep = "screen"
		end,
	},
}
