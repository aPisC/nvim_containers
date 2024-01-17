return {
  {
    'aPisC/overseer.nvim',
    dependencies = {
      {
        'stevearc/dressing.nvim',
        opts = {},
      }
    },
    opts = {
      templates = {"builtin"},
      task_list = {
        bindings = {
          ["o"] = "<CMD>OverseerRun<CR>",
          ["i"] = "<CMD>OverseerQuickAction edit<CR>",
          ["r"] = "<CMD>OverseerQuickAction restart<CR>",
          ["x"] = "<CMD>OverseerQuickAction dispose<CR>",
          ["f"] = "<CMD>OverseerQuickAction float<CR>",
        },
      },
    },
    event = "VeryLazy",
  }
}
