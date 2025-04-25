local osu = require("utils.os")

function telescope_open_action(action)
	return function()
		require("telescope.command").load_command(action)
	end
end


return {
	{
		"nvim-telescope/telescope.nvim",
		priority = 60,
		dependencies = {
			"nvim-lua/plenary.nvim",
      "protex/better-digraphs.nvim",
		},
		keys = {
			{ "<C-p>", telescope_open_action("find_files") },
			{ "<C-S-p>", telescope_open_action("commands") },
			{ "<C-g>f", telescope_open_action("buffers") },
			{ "<C-g>a", telescope_open_action("find_files") },
			{ "<C-g>s", telescope_open_action("lsp_document_symbols") },
			{ "<C-g>S", telescope_open_action("lsp_workspace_symbols") },
      {
				"<C-k><C-k>",
				function()
					require("better-digraphs").digraphs("insert")
				end,
				mode = "i",
			},
      { "<F1>", telescope_open_action("help_tags")}

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
          windows = "C:\\Program Files\\Neovim\\sqlite3.dll"
        })
      end,
      config = function()
        require("telescope-all-recent").setup({})
      end
  },
  {
      "nvim-telescope/telescope-ui-select.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim",
      },
      config = function()
        require("telescope").load_extension("ui-select")
      end
  },
}
