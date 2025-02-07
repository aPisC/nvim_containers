function initialize_treesitter(plug, opts)
  if not opts.treesitter_install  then return end
  require("nvim-treesitter.configs").setup({
    ensure_installed = vim.tbl_filter(
    function(lang) return opts.treesitter_install[lang] end,
    vim.tbl_keys(opts.treesitter_install)
    ),
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      disable = { "lua", "help" },
      additional_vim_regex_highlighting = true,
    },
  })
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      treesitter_install = {},
      _initialize = { treesitter = initialize_treesitter }
    }
  }

}

