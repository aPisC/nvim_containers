return {
  {
    -- Formatter
    'mhartington/formatter.nvim',
    opts = function (plug, opts) return {
      logging = false,
      log_level = vim.log.levels.WARN,
      filetype = {
        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace
        }
      },
    } end,
    config = function(plug, opts)
      local formatter = require("formatter").setup(opts)
    end,
  },
}

