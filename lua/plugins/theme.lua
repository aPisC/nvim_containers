local custom_overrides = {
  DiagnosticUnderlineError = { bg="#661111", sp="NONE"   },
  DiagnosticUnderlineWarn = { bg="#333300", sp="NONE"   },
  DiagnosticUnderlineInfo = { sp="NONE"   },
  DapBreakpoint  = { fg='#993939'    },
  DapRejected    = { fg='grey'       },
  DapLogPoint    = { fg='#22547a'    },
  DapStopped     = { bg='#555500'    },
  CoqtailChecked = { bg='DarkGreen'  },
  CoqtailSent    = { bg='DarkGreen'  },
  coqProofAdmit  = { fg='DarkOrange' },
  CmpGhostText   = { fg='#888888'    },
  CopilotAnnotation = { fg='#888888', link = "CmpGhostText" },
  CopilotSuggestion = { fg='#888888', link = "CmpGhostText" },
  -- CursorLine = { bg = '#333333' },
  VertSplit = { bg = '#282c34', fg='#000000' },
  NeoTreeVertSplit = { bg = '#282c34', fg='#000000', vscode_light_bg = '#eaeaea', vscode_light_fg = '#000000' },
  NeoTreeWinSeparator = { bg = '#282c34', fg='#000000', vscode_light_bg = '#eaeaea', vscode_light_fg = '#000000' },
  -- NeoTreeTabActive = {  vscode_light_bg = '#ffffff', vscode_light_fg = '#000000' },
  -- NeoTreeTabInactive = { vscode_light_bg = '#eaeaea', vscode_light_fg = '#000000' },
  -- NeoTreeTabSeparator = { vscode_light_bg = '#eaeaea', vscode_light_fg = '#000000' },
  OverseerTaskBorder = { onedark_bg = 'transparent', fg='#888888' },
  FlashLabel = { bg = '#003300', fg = '#8ebd6b' },
  FlashMatch = { bg = '#112244', fg = 'cyan' },
  FlashCursor = { fg = '#112244', bg = 'cyan' },
  -- FlashBackdrop = { fg = '#a0a8b7' },
  WinBar = { bg = 'transparent', fg = '#eaeaea' },
  WinBarNC = { bg = 'transparent', fg = '#eaeaea' }, 
  FoldColumn = { fg="#5c6370" },
}


local function get_custom_overrides(dialect, resolve)
  local overrides = {}
  for k, v in pairs(custom_overrides) do
    overrides[k] = {}
    overrides[k].fg = v[dialect .. "_fg"] or v.fg or nil
    overrides[k].bg = v[dialect .. "_bg"] or v.bg or nil
    overrides[k].sp = v[dialect .. "_sp"] or v.sp or nil
    overrides[k].link = v[dialect .. "_link"] or v.link or nil

    if resolve then
      overrides[k].fg = overrides[k].fg and resolve[overrides[k].fg] or overrides[k].fg
      overrides[k].bg = overrides[k].bg and resolve[overrides[k].bg] or overrides[k].bg
    end
  end
  return overrides
end


-- user command to load a theme
local theme_loaders = { }
vim.api.nvim_create_user_command("Theme", function()
  vim.ui.select(
    vim.tbl_keys(theme_loaders), 
    { prompt = "Select a theme" },
    function(selected) if theme_loaders[selected] then theme_loaders[selected]() end end
  )
end, {})



return {
  -- {
  --   'folke/tokyonight.nvim',
  --   branch = 'main',
  --   lazy = true
  -- },

  -- {
  --   'Everblush/nvim',
  --   lazy = true
  -- },
  {
    'Mofiqul/vscode.nvim',
    config = function(plug, opts)
      local vscode = require('vscode')
      theme_loaders["vscode"] = function()
        vscode.setup({
          style = "dark",
          transparent = true,
          italic_comments = true,
          group_overrides = get_custom_overrides("vscode", {}),
        })
        vscode.load()
      end

      theme_loaders["vscode_light"] = function()
        vscode.setup({
          style = "light",
          transparent = false,
          italic_comments = true,
          group_overrides = get_custom_overrides("vscode_light", {}),
        })
        vscode.load()
      end

    end
  },
  {
    'navarasu/onedark.nvim',
    dependencies = {
      "levouh/tint.nvim"
    },
    lazy = false,
    priority = 1000,
    config = function(plug, opts)
      local onedark = require('onedark')

      theme_loaders["onedark"] = function()
        onedark.setup({
          transparent = true,
          style = 'dark',
          highlights = get_custom_overrides("onedark", {}),
        })
        onedark.load()
      end

      theme_loaders["onedark_darker"] = function()
        onedark.setup({
          transparent = true,
          style = 'darker',
          highlights = get_custom_overrides("onedark", {}),
        })
        onedark.load()
      end

      theme_loaders["onedark"]()
    end
  },
  {
    "levouh/tint.nvim",
    enabled = true,
    opts = {
      tint = -40,
      tint_background_colors = false,
      -- highlight_ignore_patterns = { "WinSeparator", "Status.*"},
      window_ignore_function = function(winid)
        local bufid = vim.api.nvim_win_get_buf(winid)
        local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
        local floating = vim.api.nvim_win_get_config(winid).relative ~= ""
        local filetyle = vim.api.nvim_buf_get_option(bufid, "filetype")

        -- Do not tint `terminal` or floating windows, tint everything else
        -- vim.notify("filetype: " .. filetype)

        return false -- buftype == "terminal" or buftype == "nofile" or floating or filetype == "neo-tree"
      end
    }
  },
}
