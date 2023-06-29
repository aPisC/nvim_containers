local utils = require"init.utils"

local M = {
  initialized = false
}

local default_config = { theme="onedark", variant="dark", transparent=false }

local light_overrides = {
  DapBreakpoint  = { fg='#993939'    },
  DapRejected    = { fg='grey'       },
  DapLogPoint    = { fg='#22547a'    },
  DapStopped     = { bg='yellow'     },
  CoqtailChecked = { bg='LightGreen' },
  CoqtailSent    = { bg='LightGreen' },
  coqProofAdmit  = { fg='DarkOrange' },
}

local dark_overrides = {
  DapBreakpoint  = { fg='#993939'    },
  DapRejected    = { fg='grey'       },
  DapLogPoint    = { fg='#22547a'    },
  DapStopped     = { bg='#555500'    },
  CoqtailChecked = { bg='DarkGreen'  },
  CoqtailSent    = { bg='DarkGreen'  },
  coqProofAdmit  = { fg='DarkOrange' },
}

function M.assert_setup(config)
  if not M.initialized then
    M.setup(config)
  end
end

function M.setup(config)
  config = utils.merge_deep({}, default_config, config or {})
  local theme = config.theme
  if theme == "vscode" then
    setup_vscode(config)
  elseif theme == "onedark" then
    setup_onedark(config)
  elseif theme == "everblush" then
    setup_everblush(config)
  elseif theme == "tokyo" then
    setup_tokyo(config)
  else
    print("theme " .. theme .. " not found")
  end

  if config.variant == "light" then
    apply_hl(light_overrides)
  else
    apply_hl(dark_overrides)
  end
  M.initialized = true
end

function setup_vscode(config)
    local vscode = require('vscode')
    vscode.setup({
        style =config.variant, -- dark  light
        transparent = config.transparent,
        italic_comments = true,
        disable_nvimtree_bg = true,
    })
    vscode.load()
end

function setup_onedark(config)
    -- https://github.com/navarasu/onedark.nvim
    require('onedark').setup {
      -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer'
      style =config.variant,
      transparent = config.transparent,
      lualine = {
          transparent = config.transparent,
      },
    }
    require('onedark').load()
end

function setup_everblush(config)
  require('everblush').setup({
      override = {},
      transparent_background = config.transparent,
      nvim_tree = {
          contrast = false,
      },
      override = {
        LineNr = {fg = '#b3b9b8'},
        Comment = {fg = '#b3b9b8'},
          -- Normal = { fg = '#ffffff', bg = 'comment' },
      },
  })
  vim.cmd('colorscheme everblush')
end

function setup_tokyo(config)
  vim.cmd('let g:tokyonight_style = "night"')
  vim.cmd('let g:tokyonight_enable_italic = 0')
  vim.cmd('let g:tokyonight_transparent_background = 1')
  vim.cmd('let g:airline_theme = "tokyonight"')
  vim.cmd('set termguicolors')
  -- vim.cmd('colorscheme tokyonight')
  vim.cmd[[colorscheme tokyonight]]
  -- vim.cmd('hi LineNr cterm=bold ctermfg=121 gui=bold guifg=#7aa2f7 guibg=#232433')
  -- vim.cmd('hi LineNrAbove ctermfg=11 guifg=#444b6a guibg=#232433')
  -- vim.cmd('hi 
end


function apply_hl(overrides)
  for k, ov in pairs(overrides) do
    vim.api.nvim_set_hl(0, k, ov)
  end
end

return M
