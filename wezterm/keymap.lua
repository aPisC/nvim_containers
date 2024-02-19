local wezterm = require 'wezterm'

return function(config)
  config.disable_default_key_bindings = true
  config.leader = { key = 't', mods = 'CTRL', timeout_milliseconds = 1000 }
  config.keys = {
    { key = 'V', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },
    { key = 'C', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateCopyMode  },
    -- { key = ''}
    { key = 't', mods = 'LEADER|CTRL', action = wezterm.action.SendKey { key = 't', mods = 'CTRL' } },
    { key = 'c', mods = 'LEADER', action = wezterm.action.SpawnCommandInNewTab { cwd = wezterm.home_dir }  },
    { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },
    { key = '|', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'P', mods = 'LEADER', action = wezterm.action.ActivateCommandPalette },
    { key = 'f', mods = 'LEADER', action = wezterm.action.DecreaseFontSize },
    { key = 'F', mods = 'LEADER', action = wezterm.action.IncreaseFontSize },
    { key = '=', mods = 'LEADER', action = wezterm.action.ResetFontSize },
    { key = '0', mods = 'LEADER', action = wezterm.action.ShowDebugOverlay },
    { key = '1', mods = 'LEADER', action = wezterm.action.ActivateTab(0) },
    { key = '2', mods = 'LEADER', action = wezterm.action.ActivateTab(1) },
    { key = '3', mods = 'LEADER', action = wezterm.action.ActivateTab(2) },
    { key = '4', mods = 'LEADER', action = wezterm.action.ActivateTab(3) },
    { key = '5', mods = 'LEADER', action = wezterm.action.ActivateTab(4) },
    { key = '6', mods = 'LEADER', action = wezterm.action.ActivateTab(5) },
    { key = '7', mods = 'LEADER', action = wezterm.action.ActivateTab(6) },
    { key = '8', mods = 'LEADER', action = wezterm.action.ActivateTab(7) },
    { key = '9', mods = 'LEADER', action = wezterm.action.ActivateTab(8) },
    { key = 'j', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(-1) },
    { key = 'k', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(1) },
    { key = 'F11', mods = 'LEADER', action = wezterm.action.ToggleFullScreen },

    { key = 'LeftArrow', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Left') },
    { key = 'RightArrow', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Right') },
    { key = 'UpArrow', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Up') },
    { key = 'DownArrow', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Down') },
    { key = 's', mods = 'LEADER', action = wezterm.action.ShowLauncher },
  }
end
