return {
  {
    'nvim-telescope/telescope.nvim',
    priority=60,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { "<C-p>", function() vim.cmd"Telescope git_files" end },
      { "<C-S-p>", function() vim.cmd"Telescope commands" end },
      { "<C-g>f", function() vim.cmd"Telescope buffers" end },
      { "<C-g>a", function() vim.cmd"Telescope find_files" end },
      { "<C-g>s", function() vim.cmd"Telescope lsp_document_symbols" end },
      { "<C-g>S", function() vim.cmd"Telescope lsp_workspace_symbols" end },
    },
    opts = function() return {
      defaults = {
        path_display = { "smart" },
      },
      extensions = {
        ["ui-select"] = {
          require ("telescope.themes").get_dropdown {}
          -- require("telescope.themes").get_ivy {}
          -- require("telescope.themes").get_cursor {}
        }
      }
    } end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require"telescope".load_extension("ui-select")
    end
  },
  {
    'prochri/telescope-all-recent.nvim',
    dependencies = {
      {'kkharji/sqlite.lua'},
    },
    opts = {},
  },
  {
    'protex/better-digraphs.nvim',
    keys = {
      {'<C-k><C-k>', function() require'better-digraphs'.digraphs("insert") end, mode='i'}
    },
  }
}
