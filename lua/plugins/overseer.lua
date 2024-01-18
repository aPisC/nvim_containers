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
          ["w"] = "<CMD>OverseerQuickAction watch<CR>",
          ["x"] = "<CMD>OverseerQuickAction dispose<CR>",
          ["f"] = "<CMD>OverseerQuickAction open float<CR>",
          ["t"] = "<CMD>OverseerQuickAction open tab<CR>",
          ["dd"] = "<CMD>OverseerQuickAction dispose<CR>",
        },
      },
    },
    event = "VeryLazy",
  }
}
