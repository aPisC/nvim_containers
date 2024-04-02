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
      local ensure_installed = { }
      for lang, enabled in pairs(opts.ensure_installed) do
        if enabled then table.insert(ensure_installed, lang) end
      end

      local config = vim.tbl_extend("force", opts, { ensure_installed = ensure_installed })
      require("nvim-treesitter.configs").setup(config)
    end
  },
}
