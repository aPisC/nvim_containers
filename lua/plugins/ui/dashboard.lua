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
          path = path:gsub('\\', '/')
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
    config = function(_, opts) 
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
