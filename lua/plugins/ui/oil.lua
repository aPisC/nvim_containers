return {
  {
    'stevearc/oil.nvim',
    dependencies = {  
      { "nvim-tree/nvim-web-devicons", opts = {} },
    },
    opts = {

      view_options = {
        show_hidden = false,
        is_hidden_file = function(name, bufnr)
          -- Hide parent directory
          if name == nil then return true end
          if name == ".." then return true end

          -- Check if the file is ignored by git 
          local path = vim.api.nvim_buf_get_name(bufnr):gsub("^oil://", "") .. "/" .. name
          local proc = vim.system({"git", "check-ignore", "--", path})
          local completion = proc:wait(100)
          if completion.code == 0 then return true end

          return false
        end,
      }
    },
    lazy = false,
  },
  {
      'mrjones2014/legendary.nvim',
      opts = {
        oil = {
          icon = "🛢️",
          description = "File explorer",
          keymaps = {
            {"<C-b>", ":Oil<CR>", mode={'n'}, description="Open oil" },
            {"<C-S-b>", ":vsplit|Oil<CR>", mode={'n'}, description="Open oil in vsplit" },
          },
        },
      }
  }
}
