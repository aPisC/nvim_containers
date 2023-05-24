local telescope = require("telescope")

telescope.setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }
    }
  }
})

telescope.load_extension('ui-select')
telescope.load_extension('harpoon')
telescope.load_extension('toggletasks')

require'telescope-all-recent'.setup{
  -- your config goes here
}
