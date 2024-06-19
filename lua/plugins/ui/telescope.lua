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
      "nvim-telescope/telescope-ui-select.nvim",
      "prochri/telescope-all-recent.nvim",
      "kkharji/sqlite.lua",
      "protex/better-digraphs.nvim",
		},
		keys = {
			{ "<C-p>", telescope_open_action("git_files") },
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

		},
		opts = function()
			return {
				defaults = { path_display = { "filename_first" } },
				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown({}) },
				},
			}
		end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
			telescope.load_extension("ui-select")
      require("telescope-all-recent").setup({})
    end
	},
}
