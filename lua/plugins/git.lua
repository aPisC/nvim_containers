return {
  {
    'akinsho/git-conflict.nvim',
    opts = {}
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "sindrets/diffview.nvim",
      "ibhagwan/fzf-lua",
    },
    config = function(plug, opts) 
      require("neogit").setup(opts)

      vim.api.nvim_create_user_command('Git', function() require"neogit".open() end, {nargs=0, force= true})
    end,
    keys = {
      {'<C-g><C-g>', function() require("neogit").open() end}
    },
  },
  {
    "f-person/git-blame.nvim",
    priority=40,
    opts = {
      enabled = true,
      highlight_group = "NonText", 
      virtual_text_column = 80,
      message_template = "  ◆ [<date>] <author> <sha> <summary>",
      date_format = "%Y.%m.%d",
      message_when_not_committed = "  ◆ Not Committed Yet"
    }
  },
  -- {
  --   'TimUntersberger/neogit',
  --   deps = {
  --     {'sindrets/diffview.nvim'},
  --   }
  --   opts = {
  --     disable_commit_confirmation = true,
  --     kind = "tab",
  --     integrations = {
  --       diffview = true
  --     },
  --     commit_popup = {
  --       kind = "tab"
  --     },
  --     popup = {
  --       kind = "tab"
  --     }

  --   }
  -- },
  {
    'lewis6991/gitsigns.nvim',
    config = true,
  },
}
