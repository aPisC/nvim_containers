
local colors = {
  dark = "#282c34",
  light = "#abb2bf",
  blue = "#61afef",
  cyan = "#56b6c2",
  green = "#98c379",
  magenta = "#c678dd",
  red = "#e06c75",
  yellow = "#e5c07b",
  primary = "#98c379",
}

local program_icons = {
  ["nvim"] = "",
  ["git"] = "",
  ["zsh"] = "",
  ["fish"] = "",
  ["bash"] = "",
  ["wezterm"] = "",
  ["ssh"] = "󰣀",
  ["htop"] = "",
  ["kubectl"] = "󱃾",
  ["k9s"] = "󱃾",
}

local program_colors = {
  nvim = colors.blue,
  k9s = colors.red,
  kubectl = colors.red,
}

local symbols = {
  edge = "",
}

local wezterm = require 'wezterm'

local function tab_title_text(tab)
  local pane = tab.active_pane
  local cwd = pane.current_working_dir
  local title = program_icons[pane.title] or pane.title
  if cwd then
    return string.format('%s %s', title, cwd.file_path:gsub("/$", ""):gsub('.*/', ''))
  end
  return pane.title
end

local function tab_program_color(tab)
  local pane = tab.active_pane
  local title = pane.title
  return program_colors[pane.title] or colors.primary
end

local function format_tab_title(tab, tabs, panes, config, hover, max_width)
  local primary = tab_program_color(tab)

  local edge_background = colors.dark
  local background = colors.dark
  local foreground = primary

  if tab.is_active then
    background = primary
    foreground = colors.dark
  elseif hover then
    background = colors.light
    foreground = colors.dark
  end

  local edge_foreground = background

  local title = tab_title_text(tab)
  local left_separator = (tab.tab_id == 0) and "" or symbols.edge 
  local right_separator = symbols.edge

  local title_len = string.len(title)
  local max_title_len = 24
  if title_len > max_title_len then
    title = string.sub(title, 1, max_title_len - 1) .. "…"
  end


  return {
      { Foreground = { Color = edge_background } },
      { Background = { Color = edge_foreground } },
      { Text = left_separator },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = " " .. title .. " "},
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = right_separator },
  }
end

local function format_left_status(window, pane)
  local date = wezterm.strftime ' %H:%M:%S'

  return {
    -- { Attribute = { Underline = 'Single' } },
    -- { Attribute = { Italic = true } },
    { Background = { Color = colors.light } },
    { Foreground = { Color = colors.dark } },
    { Text = '' .. (date or "") .. ' ' },

    { Background = { Color = colors.dark } },
    { Text = ' ' },
  }
end

return function(config)
  config.force_reverse_video_cursor = true
  config.enable_tab_bar = true
  config.tab_bar_at_bottom = false
  config.use_fancy_tab_bar = false
  config.tab_max_width = 28
  config.colors.tab_bar = {
    background = colors.dark,
  }

  config.tab_bar_style = {
    new_tab = wezterm.format {
      { Background = { Color = colors.dark} },
      { Foreground = { Color = colors.light } },
      { Text = "  +  " },
    },
    new_tab_hover = wezterm.format {
      { Foreground = { Color = colors.dark } },
      { Background = { Color = colors.light } },
      { Text = symbols.edge },
      { Background = { Color = colors.light } },
      { Foreground = { Color = colors.dark } },
      { Text = " + " },
      { Background = { Color = colors.dark } },
      { Foreground = { Color = colors.light } },
      { Text = symbols.edge },
    },
  }


  wezterm.on('format-tab-title', format_tab_title)
  wezterm.on('update-right-status', function(window, pane)
    window:set_left_status(wezterm.format(format_left_status(window, pane)))
  end)
end
