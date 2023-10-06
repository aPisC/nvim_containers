return {
  {
    'anuvyklack/hydra.nvim',
    keys = {
      "gb",
      "<C-w>",
    },
    opts = {
      barbar = {
        name = 'Barbar',
        body = "gb",
        mode = "n",
        config = {
          invoke_on_body = true,
          color="pink",
          -- on_key = function()
          --   -- Preserve animation
          --   -- vim.wait(200, function() vim.cmd 'redraw' end, 30, false)
          -- end
        },
        heads = {
          { 'p', function() vim.cmd('bp') end, { on_key = false, desc = false } },
          { 'n', function() vim.cmd('bn') end, { on_key = false, desc = false } },
          { 'h', function() vim.cmd('bp') end, { on_key = false } },
          { 'l', function() vim.cmd('bn') end, { desc = 'choose', on_key = false } },

          -- { 'H', function() vim.cmd('bp') end },
          -- { 'L', function() vim.cmd('bn') end, { desc = 'move' } },

          -- { 'p', function() vim.cmd('PinBuffer') end, { desc = 'pin' } },

          { 'd', function() vim.cmd('bd') end, { desc = 'close' } },
          { 'c', function() vim.cmd('bd') end, { desc = false } },
          { 'q', function() vim.cmd('bd') end, { desc = false } },

          { '<Esc>', nil, { exit = true } }
        }
      },
      windows = {
        name = 'Windows',
        -- hint = window_hint,
        config = {
          invoke_on_body = true,
          hint = {
            border = 'rounded',
            offset = -1
          }
        },
        mode = 'n',
        body = '<C-w>',
        heads = {
          { 'h', '<C-w>h' },
          { 'j', '<C-w>j' },
          { 'k', '<C-w>k' },
          { 'l', '<C-w>l' },

          { '<left>', '<C-w>h' },
          { '<down>', '<C-w>j' },
          { '<up>', '<C-w>k' },
          { '<right>', '<C-w>l' },

          { 'H', '<C-w>H' },
          { 'J', '<C-w>J'  },
          { 'K', '<C-w>K'  },
          { 'L', '<C-w>L'  },

          { '+', '<C-w>+' },
          { '-', '<C-w>-'  },
          { '<', '<C-w><'  },
          { '>', '<C-w>>'  },

          -- { '<C-h>', function() splits.resize_left(2)  end },
          -- { '<C-j>', function() splits.resize_down(2)  end },
          -- { '<C-k>', function() splits.resize_up(2)    end },
          -- { '<C-l>', function() splits.resize_right(2) end },
          { '=', '<C-w>=', { desc = 'equalize'} },

          { 's',     '<C-w>s' },
          { '<C-s>', '<C-w>s', { desc = false } },
          { 'v',     '<C-w>v'  },
          { '<C-v>', '<C-w>v', { desc = false } },

          { 'w',     '<C-w>w', { exit = true, desc = false } },
          { '<C-w>', '<C-w>w', { exit = true, desc = false } },

          -- { 'z',     cmd 'WindowsMaximaze', { exit = true, desc = 'maximize' } },
          -- { '<C-z>', cmd 'WindowsMaximaze', { exit = true, desc = false } },

          { 'o',     '<C-w>o', { exit = true, desc = 'remain only' } },
          { '<C-o>', '<C-w>o', { exit = true, desc = false } },

          -- { 'b', 'gb', { exit = true, desc = 'choose buffer' } },

          { 'q',     '<C-w>q', { desc = 'close window' } },
          { '<C-q>', '<C-w>q', { desc = false } },

          { '<Esc>', nil,  { exit = true, desc = false }},
          { '<CR>', nil,  { exit = true, desc = false }},
        }
      }
    },
    config = function(plug, opts)
      local Hydra = require("hydra")

      for key, value in pairs(opts) do
        Hydra(value)
      end
    end
  }
}
