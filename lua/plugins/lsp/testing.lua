function initialize_testing(plug, opts)
  if not opts.test_adapters  then return end
      -- Setup test adapters
      require("neotest").setup({
        adapters = vim.tbl_values(vim.tbl_map(
          function(adapter)
            if type(adapter) == "function" then
              return adapter()
            else
              return adapter
            end
          end,
          opts.test_adapters
        )),
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
      })
      vim.api.nvim_create_user_command('TestStop', function() require("neotest").run.stop() end, {})
      vim.api.nvim_create_user_command('TestFile', function() require("neotest").run.run(vim.fn.expand("%")) end, {})
      vim.api.nvim_create_user_command('TestNearest', function() require("neotest").run.run() end, {})
      vim.api.nvim_create_user_command('TestLast', function() require("neotest").run.run() end, {})
      vim.api.nvim_create_user_command('TestSummary', function() require("neotest").summary.toggle() end, {})
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'nvim-neotest/neotest',
    },
    opts = {
      test_adapters = {},
      _initialize = { testing = initialize_testing }
    }
  }
}
