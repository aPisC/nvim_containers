return {
  {
    "zbirenbaum/copilot.lua",
    lazy = true,
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger=true,
        keymap = false,
     },
      panel = {
        enabled = false,
        auto_refresh = true,
      },
      filetypes = {
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
        sh = function ()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then return false end
          return true
        end,
        ["."] = false,
      },
      server_opts_overrides = {
        handlers = {
          ["metals/findTextInDependencyJars"] = function() end,
        },
      },
    },
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      {
        "zbirenbaum/copilot-cmp",
        config = function ()
          require("copilot_cmp").setup()
        end
      },
    },
    priority=60,
    opts = function(plug, opts)
      table.insert(opts.sources, {
        name = "copilot",
        group_index = 1,
        priority = 1000,
      })
      return opts
    end,
  }
}
