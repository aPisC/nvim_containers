return {
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g["VM_set_statusline"] = '0'
      vim.g["VM_silent_exit"] = 1
    end,
  },
  {'mbbill/undotree'},
  {
    'tpope/vim-commentary', 
    opts = {
      commentstring = { }
    },
    config = function(_, opts)
      local augroup = vim.api.nvim_create_augroup("commentary-filetypes", { clear = true })
      for filetype, cs in pairs(opts.commentstring) do
        vim.api.nvim_create_autocmd({"Filetype"}, {pattern = {filetype}, callback=function() vim.bo.commentstring = cs end })
      end
    end
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = { }
  },
  {'michaeljsmith/vim-indent-object'},
  {
    'stevearc/stickybuf.nvim',
    enabled = false,
    opts = {
      get_auto_pin = function(bufnr)
        local buftype = vim.bo[bufnr].buftype
        local filetype = vim.bo[bufnr].filetype
        local bufname = vim.api.nvim_buf_get_name(bufnr)

        if vim.startswith(filetype, "dapui_") then return "filetype" end
        if vim.startswith(filetype, "dap-") then return "filetype" end
        if vim.startswith(filetype, "toggleterm") then return "filetype" end
        -- if vim.startswith(filetype, "httpResult") then return "filetype" end
        if vim.startswith(filetype, "blame") then return "filetype" end
        if vim.startswith(filetype, "dbout") then return "filetype" end
        if vim.startswith(filetype, "dbui") then return "filetype" end
        if vim.startswith(filetype, "Neogit") then return nil end
        if vim.startswith(filetype, "neo-tree") then return nil end

        return require("stickybuf").should_auto_pin(bufnr)
      end
    },
  },
  {
    'junegunn/fzf',
    dependencies = {{'junegunn/fzf.vim'}},
    build = function() vim.fn['fzf#install']() end,
    event = "VeryLazy",
    keys = {
      {"<C-f>", "\"zy:Ag <C-r>z<CR>", mode="v"}
    },
  },
  {
    'm4xshen/autoclose.nvim',
    enabled = true,
    opts = {
      options = {
        disable_when_touch = true,
      }
    },
  },
  {
    'Pocco81/auto-save.nvim',
    opts = {
      trigger_events = {"InsertLeave"},
      condition = function(buf)
        local fn = vim.fn
        local filetype = fn.getbufvar(buf, "&filetype")

        -- Only enable in normal mode
        if vim.api.nvim_get_mode().mode ~= 'n' then return false end

        -- Disable on non-exsting buffers
        if not vim.api.nvim_buf_is_valid(buf) then return false end

        -- Disable on not modifiable buffers
        if not fn.getbufvar(buf, "&modifiable") == 1 then return false end

        -- Disable on Neogit buffers
        if string.match(filetype, "^Neogit") then return false end
        -- Disable on specific filetypes
        --
        if vim.tbl_contains({
            "sql",
            "neo-tree",
            "sbt",
            "OverseerForm",
            "OverseerList",
            "oil",
          }, filetype)
        then return false end

        -- Disable on specific file names
        local disables_file_patterns = {
          "Dependencies.scala$",
          "/tmp/.*",
        }
        local filename = vim.api.nvim_buf_get_name(0)
        for _, pattern in ipairs(disables_file_patterns) do
          if string.match(filename, pattern) then return false end
        end

        return true
      end,
    }
  },
  {
    "ryanmsnyder/toggleterm-manager.nvim",
    dependencies = {
      "akinsho/nvim-toggleterm.lua",
      "nvim-telescope/telescope.nvim",
      {
          'mrjones2014/legendary.nvim',
          opts = {
            toggleterm = {
              itemgroup = "toggleterm",
              icon = "📟",
              description = "Toggleterm",
              keymaps = {
                {"<C-g>t", function() vim.cmd((vim.v.count or 1) .. "ToggleTerm") end, mode={'n'}, description="Toggleterm manager" },
              },
            },
          }
      }
    },
    opts = function() 
      local actions = require("toggleterm-manager").actions
      return {
        mappings = { -- key mappings bound inside the telescope window
          i = {
            ["<CR>"] = { action = actions.toggle_term, exit_on_action = false }, -- toggles terminal open/closed
            ["<C-i>"] = { action = actions.create_term, exit_on_action = true }, -- creates a new terminal buffer
            ["<C-d>"] = { action = actions.delete_term, exit_on_action = false }, -- deletes a terminal buffer
            ["<F2>"] = { action = actions.rename_term, exit_on_action = false }, -- provides a prompt to rename a terminal
          },
        },
      } 
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    dependencies = {
      "nvim-lua/plenary.nvim",
    }, 
    opts = {
      size = 10,
      start_in_insert = false,
      direction="horizontal",
      winbar = {
        enable = true,
      },
      responsiveness = {
        -- breakpoint in terms of `vim.o.columns` at which terminals will start to stack on top of each other
        -- instead of next to each other
        -- default = 0 which means the feature is turned off
        horizontal_breakpoint = 135,
      }
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      -- local has_telescope, telescope = pcall(require, "telescope")
      -- if has_telescope then
      --   telescope.load_extension("termfinder")
      --   vim.keymap.set("n", "<C-g>T", function() vim.cmd("Telescope termfinder find") end)
      -- end
    end
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          enabled = true,
          search = { wrap = true },
          jump = { register = false },
          highlight = {
            backdrop = true,
            matches = false,
            priority = 5000,
            groups = { },
          },
        }
      }
    },
    -- stylua: ignore
    config = function(plug, opts)
      require("flash").setup(opts)
      vim.api.nvim_create_user_command("FlashToggle", function() require("flash").toggle() end, {})
      vim.api.nvim_create_user_command("FlashEnable", function() require("flash").enable() end, {})
      vim.api.nvim_create_user_command("Flashdisable", function() require("flash").disale() end, {})
    end,
    keys = {
      -- { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      -- { "S", mode = { "n", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "<Tab>", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
      -- { "<S-Tab>", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
      { "<S-Tab>", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { { 'nvim-treesitter/nvim-treesitter' } },
    opts = {
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aC"] = "@comment.outer",
            ["iC"] = "@comment.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["in"] = "@number.inner",
            ["as"] = "@statement.outer",
            ["ia"] = "@parameter.inner",
            ["aa"] = "@parameter.outer",
            ["i?"] = "@conditional.inner",
            ["a?"] = "@conditional.outer",


            -- You can also use captures from other query groups like `locals.scm`
            -- ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
          },
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
          include_surrounding_whitespace = false,
        },
      },},
    config = function(plug, opts) require'nvim-treesitter.configs'.setup(opts) end,
  },
}
