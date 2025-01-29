function initialize_formatter(plug, opts)
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


return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mhartington/formatter.nvim',
    },
    opts = {
      mason_install = { },
      formatters = {},
      _initialize = { formatter = initialize_formatter }
    }
  }
}
