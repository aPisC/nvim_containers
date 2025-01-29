local wezterm = require 'wezterm'

local config = {
  font_size = 9,
  initial_cols = 200,
  initial_rows = 50,
  audible_bell = "Disabled",
  -- font = wezterm.font 'FiraCode Nerd Font Mono',

  line_height = 1.0,
  font = wezterm.font_with_fallback {
    {
      family = 'Fira Code',
      scale = 1,
      assume_emoji_presentation = false,
    },
    { 
      family = "Symbols Nerd Font Mono",
      weight="Regular",
      stretch="Normal", 
      style="Normal",
      scale=0.95,
      assume_emoji_presentation = false,

    },
  },
  colors = {},
  allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace",
}



config = (require 'tabbar' (config)) or config
config = (require 'background' (config)) or config
config = (require 'keymap' (config)) or config

return config
