return {
  {
    'stevearc/oil.nvim',
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    opts = {},
    lazy = false,
  },
  {
      'mrjones2014/legendary.nvim',
      opts = {
        oil = {
          itemgroup = "oil",
          icon = "🛢️",
          description = "Oil",
          keymaps = {
            {"<C-b>", ":Oil<CR>", mode={'n'}, description="Open oil" },
            {"<C-S-b>", ":vsplit|Oil<CR>", mode={'n'}, description="Open oil in vsplit" },
          },
        },
      }
  }
}
