return {
  -- {
  --   name = "keymaps",
  --   keys = {
  --     {"<C-s>", function() vim.cmd"w" end }
  --   },
  -- },
  {'mbbill/undotree'},
  {
    'folke/trouble.nvim',
    opts = { },
    event = "VeryLazy",
    keys = {
      {'<C-g>E', function() vim.cmd('TroubleToggle') end},
    }
  },
  {'tpope/vim-sensible'},
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
    'tiagovla/scope.nvim',
    opts = {},
  },
  {
    'stevearc/stickybuf.nvim',
    opts = {
      get_auto_pin = function(bufnr)
        local buftype = vim.bo[bufnr].buftype
        local filetype = vim.bo[bufnr].filetype
        local bufname = vim.api.nvim_buf_get_name(bufnr)

        if vim.startswith(filetype, "dapui_") then return "filetype" end
        if vim.startswith(filetype, "dap-") then return "filetype" end
        if vim.startswith(filetype, "toggleterm") then return "filetype" end
        if vim.startswith(filetype, "httpResult") then return "filetype" end
        if vim.startswith(filetype, "blame") then return "filetype" end
        if vim.startswith(filetype, "dbout") then return "filetype" end
        if vim.startswith(filetype, "dbui") then return "filetype" end
        if vim.startswith(filetype, "Neogit") then return nil end

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
    enabled = false,
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

          }, filetype)
        then return false end

        -- Disable on specific file names
        local disables_file_patterns = {
          "Dependencies.scala$",
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
    'akinsho/toggleterm.nvim',
    dependencies = {
      'tknightz/telescope-termfinder.nvim',
    }, 
    opts = {
      size = 10,
      start_in_insert = false,
      direction="horizontal",
      winbar = {
        enable = true,
      }
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      local has_telescope, telescope = pcall(require, "telescope")
      if has_telescope then
        telescope.load_extension("termfinder")
        vim.keymap.set("n", "<C-g>T", function() vim.cmd("Telescope termfinder find") end)
      end
    end

  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    config = function(plug, opts)
      require("flash").setup(opts)
      vim.api.nvim_create_user_command("FlashToggle", function() require("flash").toggle() end, {})
      vim.api.nvim_create_user_command("FlashEnable", function() require("flash").enable() end, {})
      vim.api.nvim_create_user_command("Flashdisable", function() require("flash").disale() end, {})
    end,
    keys = {
      { "S", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
      -- { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      -- { "S", mode = { "n", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      -- { "<Tab>", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
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
            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            --
            -- nvim_buf_set_keymap) which plugins like which-key display


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
  {
    'jedrzejboczar/toggletasks.nvim',
    opts =  {
      debug = false,
      silent = false,  -- don't show "info" messages
      short_paths = true,  -- display relative paths when possible
      search_paths = { '.vscode/toggletasks' },
      scan = {
        global_cwd = true,    -- vim.fn.getcwd(-1, -1)
      },
      tasks = { },
      -- toggleterm = {
      --   start_in_insert=true,
      --   close_on_exit = false,
      --   hidden = false,
      --   direction = "tab"
      -- },
      telescope = {
        spawn = {
          open_single = true,  -- auto-open terminal window when spawning a single task
          show_running = false, -- include already running tasks in picker candidates
          mappings = {
            select_float = '<C-f>',
            spawn_smart = '<C-a>',  -- all if no entries selected, else use multi-select
            spawn_all = '<M-a>',    -- all visible entries
            spawn_selected = nil,   -- entries selected via multi-select (default <tab>)
          },
        },
        select = {
          mappings = {
            select_float = '<C-f>',
            open_smart = '<C-a>',
            open_all = '<M-a>',
            open_selected = nil,
            kill_smart = '<C-q>',
            kill_all = '<M-q>',
            kill_selected = nil,
            respawn_smart = '<C-s>',
            respawn_all = '<M-s>',
            respawn_selected = nil,
          },
        },
      },
    }
  },
}
