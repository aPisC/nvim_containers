return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger=true,
        keymap = {
          accept_line = false,
          accept= "<M-CR>",
        }
      },
      panel = {
        enabled = false,
        layout = {
          position = "right",
          ratio = 0.5
        },
      },
    }
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup()
    end
  },
  {
    'hrsh7th/nvim-cmp',
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
