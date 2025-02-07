function initialize_formatter(plug, opts)
  if not opts.formatters  then return end
      require("formatter").setup({
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = vim.tbl_map(
          function(formatter)
            if type(formatter) == "function" then
              return formatter()
            else
              return formatter
            end
          end,
          opts.formatters
        )
      })
end

function initialize_formatter_lazy(opts)
  local Promise = require("promise")
  
  local formatters = vim.tbl_filter(
    function(formatter)
      return not not opts.formatters[formatter]
    end,
    vim.tbl_keys(opts.formatters)
  )

  if #formatters == 0 then
    return Promise.resolve()
  end

  return Promise.rejected("Not implemented")
end


return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mhartington/formatter.nvim',
    },
    opts = {
      mason_install = { },
      formatters = {},
      _initialize = { formatter = initialize_formatter },
      _initialize_lazy = { formatter = initialize_formatter_lazy },

    }
  }
}
