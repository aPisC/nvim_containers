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
        -- path = require("neovim-project.utils.path").historyfile,
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
        "/home/bendeguz/workspace/hiya/*",
        "/home/bendeguz/.config/nvim",
      },
      picker = {
        type = "telescope",
      },
      last_session_on_startup = false,
    },
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
      { "Shatur/neovim-session-manager" },
    },
    lazy = false,
  },
}
