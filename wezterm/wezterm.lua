local wezterm = require 'wezterm'

local config = {
  font_size = 12,
  audible_bell = "Disabled",
  font = wezterm.font 'FiraCode Nerd Font Mono',
  colors = {},
}

config = (require 'tabbar' (config)) or config
config = (require 'background' (config)) or config
config = (require 'keymap' (config)) or config

return config
