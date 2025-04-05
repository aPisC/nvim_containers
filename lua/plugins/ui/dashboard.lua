return {
  {
    'nvimdev/dashboard-nvim',
    dependencies = { 
      'nvim-tree/nvim-web-devicons',
      'coffebar/neovim-project',
    },
    event = 'VimEnter',
    opts = {
      config = {
        project = { enable = true, limit = 8, action = function(path) vim.cmd('NeovimProjectLoad ' .. path:gsub(vim.env.HOME, '~')) end},
      }
    },
    config = function(_, opts) 
      local utils = require("dashboard.utils")
      local path = utils.path_join(vim.fn.stdpath("cache"), "dashboard/cache")
      vim.fn.writefile({ 'return require("neovim-project.utils.history").get_recent_projects()' }, path)
      require('dashboard').setup(opts)
    end,
  },
  {
    "coffebar/neovim-project",
    opts = {
      projects = {
        "~/.config/nvim",
      },
      picker = {
        type = "telescope",
      },
      last_session_on_startup = false,
    },
    init = function()
      vim.opt.sessionoptions:append("options")
      vim.opt.sessionoptions:remove("buffers")
      vim.opt.sessionoptions:remove("help")
      vim.opt.sessionoptions:append("globals")
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim"},
      { "Shatur/neovim-session-manager" },
    },
    lazy = false,
  },
}
