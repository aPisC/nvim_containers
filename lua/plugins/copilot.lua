return {
	{
		"github/copilot.vim",
		opts = {
			no_tab_map = true,
			filetypes = {
				["*"] = false,
				python = true,
				lua = true,
				scala = true,
				typescriptreact = true,
				typescript = true,
			},
		},
		init = function() end,
		config = function(_, opts)
			vim.g.copilot_enabled = true
			vim.g.copilot_filetypes = opts.filetypes
			vim.g.copilot_no_tab_map = opts.no_tab_map
		end,
	},
}

-- return {
--   {
--     'neovim/nvim-lspconfig',
--     opts = {
--       cmp_sources = {
--         copilot = {
--           name = "copilot",
--           group_index = 1,
--           priority = 1000,
--         }
--       }
--     }
--   },
--   {
--     "zbirenbaum/copilot.lua",
--     lazy = true,
--     event = "InsertEnter",
--     opts = {
--       suggestion = {
--         enabled = true,
--         enabled = false,
--         auto_trigger=true,
--         keymap = false,
--      },
--       panel = {
--         enabled = false,
--         auto_refresh = true,
--       },
--       filetypes = {
--         yaml = false,
--         markdown = false,
--         help = false,
--         gitcommit = false,
--         gitrebase = false,
--         hgcommit = false,
--         svn = false,
--         cvs = false,
--         toggleterm = false,
--         conf = false,
--         sh = function ()
--           if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then return false end
--           return true
--         end,
--         ["."] = false,
--       },
--       server_opts_overrides = {
--         handlers = {
--           ["metals/findTextInDependencyJars"] = function() end,
--           ["textDocument/codeLens"] = function() end,
--         },
--       },
--     },
--   },
-- }
