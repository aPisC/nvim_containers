return {
  {
    'saghen/blink.cmp',
    dependencies = {
        "giuxtaposition/blink-cmp-copilot",
        "zbirenbaum/copilot.lua",
        "giuxtaposition/blink-cmp-copilot",
    },
    opts = {
      sources = {
        default = { copilot = true },
        providers = {
          copilot = { name = "copilot", module = "blink-cmp-copilot", score_offset = 100, async = true },
        },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        ["*"] = true,
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        toggleterm = false,
        conf = false,
        ["."] = false,
        sh = function ()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%..*') then return false end
          return true
        end,
      },
    },
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
