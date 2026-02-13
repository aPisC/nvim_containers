return {
  {
    'stasfilin/nvim-sandman',
    priority = 9999,
    opts = {
      enabled = true,
      mode = 'block_all',
      allow = { 
        'lazy.nvim',
        'mason.nvim',
        'neovim-project',
        'copilot.lua',
      }, 
      on_block = function(info)
        vim.notify(info.message, vim.log.levels.WARN)
      end,
      ignore_notifications = {},
    }
  }
}
