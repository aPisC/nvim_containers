local osu = require("utils.os")

function telescope_open_action(...)
  local args = { ... }
	return function()
		require("telescope.command").load_command(table.unpack(args))
	end
end

return {
	{
		"nvim-telescope/telescope.nvim",
		priority = 60,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"protex/better-digraphs.nvim",
			{
				"aPisC/actions-nvim",
				opts = {
					["find.class"] = telescope_open_action("lsp_dynamic_workspace_symbols", "symbols=class"),
					["find.file"] = telescope_open_action("find_files"),
					["find.local_symbol"] = telescope_open_action("lsp_doculent_symbols"),
					["find.local_text"] = telescope_open_action("current_buffer_fuzzy_find"),
					["find.symbol"] = telescope_open_action("lsp_dynamic_workspace_symbols"),
					["find.text"] = telescope_open_action("live_grep"),
					["tools.commands"] = telescope_open_action("commands"),
					["tools.help"] = telescope_open_action("help_tags"),
          ["jump.definition"] =  telescope_open_action("lsp_definitions"),
          ["jump.lsp_implementation"] = telescope_open_action("lsp_implementations"),
          ["jump.recent_files"] = telescope_open_action("oldfiles"),
          ["jump.usages"] = telescope_open_action("lsp_references"),
          ["tools.diagnostics"] = telescope_open_action("diagnostics"),
				},
			},
		},
		keys = {
			{
				"<C-k><C-k>",
				function()
					require("better-digraphs").digraphs("insert")
				end,
				mode = "i",
			},
		},
		opts = function()
			return {
				defaults = { path_display = { "filename_first" } },
				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown({}) },
				},
			}
		end,
	},
	{
		"prochri/telescope-all-recent.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"kkharji/sqlite.lua",
		},
		init = function()
			vim.g.sqlite_clib_path = osu.cond({
				linux = nil,
				windows = "C:\\Program Files\\Neovim\\sqlite3.dll",
			})
		end,
		config = function()
			require("telescope-all-recent").setup({})
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("telescope").load_extension("ui-select")
		end,
	},
}
