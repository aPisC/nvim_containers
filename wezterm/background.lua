local images = {
  { "lofi.png", nil, nil},
  { "linux.png", nil, nil},
  { "088e24.jpg", "Left", "Middle" },
  { "1195a0.jpeg", "Left", "Top" },
  { "15b36f.jpg", nil, "Top" },
  { "1e609c.jpg", nil, "Top" },
  { "465cef.jpg", nil, nil },
  { "4955c1.jpeg", nil, "Top" },
  { "642267.jpg", "Right", "Top" },
  { "642306.jpg", nil, nil},
  { "643031.jpg", nil, nil},
  { "643103.jpg", "Right", "Middle" },
  { "643122.jpg", "Right", "Top" },
  { "975eee.jpg", "Right", "Top" },
  { "b6550f.jpg", nil, nil},
  { "bec426.jpg", nil, nil},
  { "d23c00.jpg", "Left", nil},
  { "e5d338.jpg", nil, nil},
  { "eecea5.jpeg", nil, "Top" },
}

local presets = {
  default = "random",
  plain = { type = "color", color = "#121417" },
  transparent = { type = "color", color = "Black", opacity = 0.8 },
  random = function(background)
    -- { type = "random", [select = <idx>] }
    local idx = background.select or math.random(1, #images)
    return { 
      type = "image",
      path = "/home/bendeguz/Pictures/background/" .. images[idx][1],
      horizontal_align = images[idx][2] or "Center",
      vertical_align = images[idx][3] or "Middle",
    }
  end,
  transparent = function(background)
    -- { type = "transparent", opacity = 0.8 }
    return {
      type = "color",
      color = "#000000",
      opacity = background.opacity or 0.8,
    }
  end,
  color = function(background)
    -- { type = "color", [color = "<color>"], [opacity = 1] }
    return {
      {
        source = { Color = background.color },
        width= '100%',
        height = '100%',
        opacity = background.opacity or 1,
      },
    }
  end,
  image = function(background)
    -- {
    --   type = "image",
    --   path = "<path>",
    --   horizontal_align = "Left" | "Center" | "Right",
    --   vertical_align = "Top" | "Middle" | "Bottom",
    --   opacity = 0.5,
    --   hsb ={ brightness = .4, hue = 1.0, saturation = .9 },
    -- }
    return {
      {
        source = { Color = '#282c34', },
        width= '100%',
        height = '100%',
      },
      {
        source = { File = resolve_path(background.path, wd) },
        width = "Cover",
        repeat_x = 'NoRepeat',
        horizontal_align = background.horizontal_align or "Center",
        vertical_align = background.vertical_align or "Middle",
        opacity = background.opacity ~= nil and background.opacity or .5,
        hsb = background.hsb or { brightness = .4, hue = 1.0, saturation = .9 },
      },
      {
        source = { Color = 'Black', },
        width= '100%',
        height = '100%',
        opacity = 0.6
      },
    }
  end,
}

local wezterm = require("wezterm")
local pane_local_conf = {}

local function get_wd(pane)
  local wd_raw = pane:get_current_working_dir()
  if not wd_raw then
    return ""
  end
  return wd_raw.file_path or ""
end 

local function resolve_path(path, working_dir)
  if path:sub(1, 1) == '/' then
    return path
  end

  if path:sub(1, 1) == '~' then
    return wezterm.home_dir .. path:sub(2)
  end

  if working_dir then
    return working_dir .. '/' .. path
  end

  return path
end

local function resolve_background(background, wd)
  wezterm.log_info("Resolving background: " , background)
  if type(background) == "string" then
    return resolve_background(presets[background], wd)
  end

  if type(background) == "function" then
    return resolve_background(background({}), wd)
  end

  if type(background) == "table" and type(background.type) == "string" then
    if type(presets[background.type]) == "function" then
      return resolve_background(presets[background.type](background), wd)
    end

    return resolve_background(presets[background.type], wd)
  end

  if type(background) == "table" then
    return background
  end

  return nil
end

local function load_pane_conf(pane)
  local wd = get_wd(pane)
  local bg_var = pane:get_user_vars().bg
  local conf_id = wd .. "$" .. ((bg_var and bg_var ~= "") and bg_var or "default")
  local conf = pane_local_conf[conf_id]

  if conf then return conf end
  
  if bg_var then
    local parseSuccess, parsedBg = pcall(wezterm.json_parse, bg_var)
    if parseSuccess and type(parsedBg) == "table" then
      conf = {
        bg_id = conf_id,
        background = resolve_background(parsedBg, wd)
      }
      pane_local_conf[conf_id] = conf
      return conf
    end

    conf = {
      bg_id = conf_id,
      background = resolve_background(bg_var, wd)
    }
    pane_local_conf[conf_id] = conf
    return conf
  end

  local has_local_conf, local_conf = pcall(function()
    local file = io.open(wd .. '/.vscode/.wezterm-local', 'r')
    local conf = wezterm.json_parse(file:read('*all')) or {}
    file:close()
    return conf
  end)

  if has_local_conf then
    conf = {
      bg_id = conf_id,
      background = resolve_background(local_conf.background, wd)
    }
    pane_local_conf[conf_id] = conf
    return conf
  end

  conf = {
    bg_id = conf_id,
    background = resolve_background("default", wd)
  }
  pane_local_conf[conf_id] = conf
  return conf
end


local function ensure_pane_conf(pane)
  local pane_id = pane:pane_id()
  local wd = get_wd(pane)
  local bg_var = pane:get_user_vars().bg
  local conf_id = wd .. "$" .. ((bg_var and bg_var ~= "") and bg_var or "default")

  local conf = pane_local_conf[pane_id]

  if not conf or conf.bg_id ~= conf_id then
    conf = load_pane_conf(pane)
    pane_local_conf[pane_id] = conf
  end

  return conf
end

local function update_pane(window, pane)
  local conf = ensure_pane_conf(pane)
  window:set_config_overrides(conf)
end

return function(config)
  pane_local_conf = {}

  wezterm.on("user-var-changed", function(win, pane, name, value)
    if name == 'WEZTERM_PROG' or name == "bg" then
      update_pane(win, pane)
    end
  end)

  wezterm.on("update-status", function(win, pane)
    update_pane(win, pane)
  end)
end
