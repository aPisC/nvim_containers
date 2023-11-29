return {
  {
    -- Treesitter
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        disable = { "lua", "help" },
        additional_vim_regex_highlighting = true,
      },
    },
    config = function(plug, opts)
      require("nvim-treesitter.configs").setup(opts)
    end
  },
}
