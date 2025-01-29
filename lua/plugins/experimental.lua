return {
{
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function ()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      open_browser_app = "xdg-open", -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
      handlers = {
        plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
        github = true, -- open github issues
        brewfile = true, -- open Homebrew formulaes and casks
        package_json = true, -- open dependencies from package.json
        search = false, -- search the web/selection on the web if nothing else is found
        go = true, -- open pkg.go.dev from an import statement (uses treesitter)
        jira = { -- custom handler to open Jira tickets (these have higher precedence than builtin handlers)
          name = "jira", -- set name of handler
          handle = function(mode, line, _)
            local ticket = require("gx.helper").find(line, mode, "(%u+-%d+)")
            if ticket and #ticket < 20 then
              return "http://jira.company.com/browse/" .. ticket
            end
          end,
        },
      },
      handler_options = {
        search_engine = "google", -- you can select between google, bing, duckduckgo, ecosia and yandex
        select_for_search = false, -- if your cursor is e.g. on a link, the pattern for the link AND for the word will always match. This disables this behaviour for default so that the link is opened without the select option for the word AND link
        git_remotes = { "upstream", "origin" }, -- list of git remotes to search for git issue linking, in priority
        git_remote_push = false, -- use the push url for git issue linking,
      },
    },
  },
  {
    'mrded/nvim-lsp-notify',
    dependencies = {
      'rcarriga/nvim-notify',
    },
    config = function()
      require('lsp-notify').setup({
        -- notify = require('notify'),
      })
    end
  },
  {
    'jonathan-elize/dap-info.nvim',
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {
      virt_text_opts = {
        namespace = "dap-info",
        prefix = "●",
        suffix = "",
        spacing = 4,
      },
    }
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "VeryLazy",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({
        underline=true,
        severity_sort=true,
        float = true,
        update_in_insert = true,
        virtual_text = false,
        virtual_lines = {highlight_whole_line = false, only_current_line= true},
          severity_sort = true,
          float = {
            source = "always",  -- Or "if_many"
          },
      })
    end,
  },
  {
    'anuvyklack/pretty-fold.nvim',
     enabled = false,
     opts = {},
  },
  {
      "folke/todo-comments.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      opts = {}
  }
  -- { 'echasnovski/mini.animate', version = false, },
  -- {   "karb94/neoscroll.nvim",  },
  -- {
  --   'edluffy/specs.nvim',
  --   opts = function () return {
  --     show_jumps  = true,
  --     min_jump = 30,
  --     popup = {
  --       delay_ms = 0, -- delay before popup displays
  --       inc_ms = 50, -- time increments used for fade/resize effects
  --       blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
  --       width = 10,
  --       winhl = "PMenu",
  --       fader = require('specs').linear_fader,
  --       resizer = require('specs').shrink_resizer
  --     },
  --     ignore_filetypes = {},
  --     ignore_buftypes = {
  --       nofile = true,
  --     },
  --   }
  -- end
  -- }
}
