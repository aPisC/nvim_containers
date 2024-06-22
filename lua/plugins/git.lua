return {
	{
		"akinsho/git-conflict.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"sindrets/diffview.nvim",
		lazy = true,
		opts = {
			enhanced_diff_hl = true,
		},
		init = function()
			vim.opt.fcs = vim.opt.fcs._value .. (vim.opt.fcs._value == "" and "" or ",") .. "diff: "
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function(_, opts)
			require("gitsigns").setup(opts)

			vim.api.nvim_create_user_command("BlameLine", function()
				require("gitsigns").blame_line()
			end, { nargs = 0, force = true })

			vim.api.nvim_create_user_command("BlameFile", function()
				require("gitsigns").blame()
			end, { nargs = 0, force = true })
		end,
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"sindrets/diffview.nvim",
			"ibhagwan/fzf-lua",
		},
		opts = {
			disable_hint = true,
			graph_style = "unicode",
			integrations = {
				telescope = true,
				diffview = true,
			},
			signs = {
				hunk = { "", "" },
				item = { "", "" },
				section = { "", "" },
			},
		},
		event = "VeryLazy",
		cmd = {
			"Git",
			"Neogit",
		},
		config = function(plug, opts)
			require("neogit").setup(opts)

			vim.api.nvim_create_user_command("Git", function()
				require("neogit").open()
			end, { nargs = 0, force = true })
		end,
		keys = {
			{
				"<C-g><C-g>",
				function()
					require("neogit").open()
				end,
			},
		},
	},
	{
		"f-person/git-blame.nvim",
		priority = 40,
		event = "VeryLazy",
		opts = {
			enabled = true,
			message_template = "[<date>] <author> <sha> <summary>",
			date_format = "%Y.%m.%d",
			message_when_not_committed = "Not Committed Yet",
			highlight_group = "NonText",
			virtual_text_column = 80,
			display_virtual_text = false,
		},
	},
}
