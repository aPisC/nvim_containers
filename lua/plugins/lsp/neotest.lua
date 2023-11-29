return {
  {
    -- Neotest
    'nvim-neotest/neotest',
    dependencies = {
      {'nvim-treesitter/nvim-treesitter'},
      {'antoinemadec/FixCursorHold.nvim'},
      { 'nvim-lua/plenary.nvim'},
    },
    opts = function() return {
      adapters = { },
      icons = {
        running_animated = { "◜", "◜", "◝", "◝", "◞", "◞", "◟", "◟" },
      },
      summary = {
        mappings = {
          short = "o",
          output = "O",
          stop = "s",
        }
      },
    } end,
    config = function(plug, opts)
      require("neotest").setup(opts)

      vim.api.nvim_create_user_command('TestStop', function() require("neotest").run.stop() end, {})
      vim.api.nvim_create_user_command('TestFile', function() require("neotest").run.run(vim.fn.expand("%")) end, {})
      vim.api.nvim_create_user_command('TestNearest', function() require("neotest").run.run() end, {})
      vim.api.nvim_create_user_command('TestLast', function() require("neotest").run.run() end, {})
      vim.api.nvim_create_user_command('TestSummary', function() require("neotest").summary.toggle() end, {})
    end
  },
}

