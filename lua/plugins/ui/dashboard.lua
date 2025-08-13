return {
  {
    'nvimdev/dashboard-nvim',
    dependencies = { 
      'nvim-tree/nvim-web-devicons',
      'coffebar/neovim-project',
    },
    event = 'VimEnter',
    opts = function() 
      local projects = vim.fn.reverse(require("neovim-project.utils.history").get_recent_projects())
      local actions = {
        {
          icon = ' ',
          icon_hl = 'Title',
          desc = "Browse projects",			
          desc_hl = 'String',
          key = '0',
          key_hl = 'Number',
          action = function()
            vim.cmd('NeovimProjectDiscover')
          end
        }
      }

      for i = 1, 8 do
        local path = projects[i]
        if path then
          table.insert(actions, {
          icon = ' ',
          icon_hl = 'Title',
          desc = path,
          desc_hl = 'String',
          key = tostring(i),
          key_hl = 'Number',
          action = function()
            vim.cmd('NeovimProjectLoad ' .. path)
          end
        })
        end
      end

      -- {
      --   icon = ' ',
      --   desc = 'Find Dotfiles',
      --   key = 'f',
      --   keymap = 'SPC f d',
      --   key_format = ' %s', -- remove default surrounding `[]`
      --   action = 'lua print(3)'
      -- },

      return {  
        theme = 'doom',
        config = {
          header = {
            "",
            "",
            "██╗   ██╗███████╗ ██████╗ ██████╗ ██████╗ ███████╗",
            "██║   ██║██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔════╝",
            "██║   ██║███████╗██║     ██║   ██║██║  ██║█████╗  ",
            "╚██╗ ██╔╝╚════██║██║     ██║   ██║██║  ██║██╔══╝  ",
            " ╚████╔╝ ███████║╚██████╗╚██████╔╝██████╔╝███████╗",
            "  ╚═══╝  ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝",
            "",
            "",
          },
          center = actions,
          footer = {
            "",
            " [ TIP: To exit Neovim, just power off your computer. ] ",
            "",
          },
          vertical_center = false, -- Center the Dashboard on the vertical (from top to bottom)
        }
      }
    end,
      -- config = {
      --   project = { 
      --     enable = true, 
      --     limit = 8, 
      --     action = function(path) 
      --       vim.notify(path)
      --       return
      --       -- if path == "[Browse]" then
      --       --   vim.cmd('NeovimProjectDiscover') 
      --       --   return
      --       -- end
      --       -- local home = string.gsub(vim.env.HOME, "\\", "/")
      --       -- vim.cmd('NeovimProjectLoad ' .. path:gsub(home, '~')) 
      --     end
      --   },
      -- }
    config = function(_, opts) 
      -- local utils = require("dashboard.utils")
      -- local path = utils.path_join(vim.fn.stdpath("cache"), "dashboard/cache")
      -- vim.fn.writefile({ 'local projects = require("neovim-project.utils.history").get_recent_projects(); table.insert(projects, ".."); return projects' }, path)
      vim.api.nvim_set_hl(0, "DashboardHeader", { link="Constant" })
      vim.api.nvim_set_hl(0, "DashboardFooter", { link="Comment" })
      require('dashboard').setup(opts)
    end,
  },
  {
    "coffebar/neovim-project",
    opts = {
      projects = {
        vim.fn.stdpath("config")
      },
      picker = {
        type = "telescope",
      },
      last_session_on_startup = false,
    },
    init = function()
      vim.opt.sessionoptions:remove("options")
      vim.opt.sessionoptions:remove("buffers")
      vim.opt.sessionoptions:remove("help")
      vim.opt.sessionoptions:remove("globals")
      vim.opt.sessionoptions:remove("folds")
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim"},
      { "Shatur/neovim-session-manager" },
    },
    lazy = false,
  },
}
