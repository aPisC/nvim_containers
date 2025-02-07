function initialize_linter(plug, opts)
  if not opts.linters  then return end
      require('lint').linters_by_ft = opts.linters
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
end


function initialize_linter_lazy(opts)
  local Promise = require("promise")
  
  local linters = vim.tbl_filter(
    function(formatter)
      return not not opts.linters[formatter]
    end,
    vim.tbl_keys(opts.linters)
  )

  if #linters == 0 then
    return Promise.resolve()
  end

  return Promise.rejected("Not implemented")
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mfussenegger/nvim-lint',
    },
    opts = {
      linters = {},
      _initializers = { linter = initialize_linter },
      _initialize_lazy = { formatter = initialize_linter_lazy },
    }
  }

}
