function initialize_linter(plug, opts)
      require('lint').linters_by_ft = opts.linters
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mfussenegger/nvim-lint',
    },
    opts = {
      linters = {},
      _initializers = {
        linter = initialize_linter
      }
    }
  }

}
