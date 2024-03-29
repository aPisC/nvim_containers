return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      animate = {enabled = false},
      -- fix_win_height = false,
      options = {
        left = { size = 40 },
        right = { size = 60 },
        bottom = { size = 10 },
        top = { size = 10 },
      },
      wo = { 
        winbar=true, 
        winhighlight = "WinBar:EdgyWinBar",
      },
      close_when_all_hidden = true,
      bottom = {
        {
          ft = "toggleterm",
          title = "Terminal",
          size = { height = 10, width=2 },
          filter = function(buf, win)
            -- exclude floating windows
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
        {
          ft = "Trouble",
          title = "Trouble",
          open = "Trouble",
        },
        {
          ft = "help",
          size = { height = 20 },
          title="Help",
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        { ft = "dap-repl", title= "DAP" }
        -- { ft = "spectre_panel", size = { height = 0.4 } },
      },
      right = {
        { ft = "dapui_scopes", title = "Dap Scopes" },
        { ft = "dapui_watches", title = "Dap watches" },
        { ft = "dapui_breakpoints", title = "Dap Breakpoints" },
      },
      left = {
        -- Neo-tree filesystem always takes half the screen height
        {
          title = "NeoTree",
          ft = "neo-tree",
          size = { height = 0.5 },
          pinned = true,
          open = "Neotree position=left filesystem",
          -- filter = function(buf)
          --   return vim.tbl_contains({
          --     "filesystem"
          --   }, vim.b[buf].neo_tree_source)
          -- end,
        },
        -- {
        --   title = "Git",
        --   ft = "neo-tree",
        --   filter = function(buf)
        --     return vim.b[buf].neo_tree_source == "git_status"
        --   end,
        --   pinned = true,
        --   open = "Neotree position=right git_status",
        -- },
        -- {
        --   title = "Buffers",
        --   ft = "neo-tree",
        --   filter = function(buf)
        --     return vim.b[buf].neo_tree_source == "buffers"
        --   end,
        --   pinned = true,
        --   open = "Neotree position=top buffers",
        -- },
        {
          title = "Overseer",
          ft="OverseerList",
          pinned = true,
          open = function()
            require("overseer").open()
          end,
        },
        {
          title = "Tests",
          ft = "neotest-summary",
          pinned = true,
          open = function()
            require("neotest").summary.open()
          end,
        },
        -- { 
        --   ft = "qf", 
        --   title = "Quickfix", 
        --   pinned=true, 
        --   open = "copen",

        -- },
          


        -- {
        --   ft = "Outline",
        --   pinned = true,
        --   open = "SymbolsOutlineOpen",
        -- },
        -- any other neo-tree windows
        -- "neo-tree",
      },
      keys = {
        ["q"] = function(win) win:close() end,
        ["<c-q>"] = function(win) win:hide() end,
        ["Q"] = function(win) win.view.edgebar:close() end,
        ["]w"] = function(win) win:next({ visible = true, focus = true }) end,
        ["[w"] = function(win) win:prev({ visible = true, focus = true }) end,
        ["]W"] = function(win) win:next({ pinned = false, focus = true }) end,
        ["[W"] = function(win) win:prev({ pinned = false, focus = true }) end,
        ["<C-w><C-w>"] = function(win) win.view.edgebar:close() end,
        ["<c-w>>"] = function(win) win:resize("width", 8) end,
        ["<c-w><lt>"] = function(win) win:resize("width", -8) end,
        ["<c-w>+"] = function(win) win:resize("height", 8) end,
        ["<c-w>-"] = function(win) win:resize("height", -8) end,
        ["<c-w>="] = function(win) win.view.edgebar:equalize() end,
      },
    },
    config = function(_, opts)
      require("edgy").setup(opts)
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end
  },
}
