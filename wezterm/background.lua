local wezterm = require("wezterm")
local Utils = require("utils")
local pane_config_cache = {}

-- background priority:
-- 1. manual set background
-- 2. program background
-- 3. local background
-- 4. default background

local random_image_pool = {
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

local program_backgrounds = {
  k9s = {type = "image", path = "/home/bendeguz/Pictures/background/program/serverpark_anime_girl.png"},
}

local presets = {
  default = "random",
  plain = { type = "color", color = "#121417" },
  random = function(background)
    -- { type = "random", [select = <idx>] }
    local idx = tonumber(background.select) or math.random(1, #random_image_pool)
    return { 
      type = "image",
      path = "/home/bendeguz/Pictures/background/" .. random_image_pool[idx][1],
      horizontal_align = random_image_pool[idx][2] or "Center",
      vertical_align = random_image_pool[idx][3] or "Middle",
    }
  end,
  transparent = function(background)
    -- { type = "transparent", opacity = 0.8 }
    return {
      type = "color",
      color = "#000000",
      opacity = tonumber(background.opacity) or 0.8,
    }
  end,
  color = function(background)
    -- { type = "color", [color = "<color>"], [opacity = 1] }
    return {
      {
        source = { Color = background.color },
        width= '100%',
        height = '100%',
        opacity = tonumber(background.opacity) or 1,
      },
    }
  end,
  image = function(background, wd)
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
        source = { File = Utils.resolve_path(background.path, wd) },
        width = "Cover",
        repeat_x = 'NoRepeat',
        horizontal_align = background.horizontal_align or "Center",
        vertical_align = background.vertical_align or "Middle",
        opacity = tonumber(background.opacity) or .5,
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

local function resolve_background(background, wd)
  if type(background) == "string" then return resolve_background(presets[background], wd) end
  if type(background) == "function" then return resolve_background(background({}, wd), wd) end
  if type(background) == "table" and type(background.type) == "string" then
    if type(presets[background.type]) == "function" then
      return resolve_background(presets[background.type](background, wd), wd)
    end
    return resolve_background(presets[background.type], wd)
  end
  if type(background) == "table" then return background end
  return nil
end

local function load_pane_conf(pane, selector, conf_id)
  if pane_config_cache[conf_id] then return pane_config_cache[conf_id] end
  wezterm.log_info("load config: ", conf_id)

  -- Use defined background from the user
  if selector.bg_var then
    local parseSuccess, parsedBg = pcall(wezterm.json_parse, selector.bg_var)
    if parseSuccess and type(parsedBg) == "table" then
      conf = {
        bg_id = conf_id,
        background = resolve_background(parsedBg, selector.dir)
      }
      pane_config_cache[conf_id] = conf
      return conf
    end

    conf = {
      bg_id = conf_id,
      background = resolve_background(selector.bg_var, selector.dir)
    }
    pane_config_cache[conf_id] = conf
    return conf
  end

  -- Use program background settings
  if program_backgrounds[selector.program] then
    conf = {
      bg_id = conf_id,
      background = resolve_background(program_backgrounds[selector.program])
    }
    pane_config_cache[conf_id] = conf
    return conf
  end

  -- Use local background settings
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
    pane_config_cache[conf_id] = conf
    return conf
  end

  -- Use default background settings
  conf = {
    bg_id = conf_id,
    background = resolve_background("default", wd)
  }
  pane_config_cache[conf_id] = conf
  return conf
end


local function get_pane_config(pane)
  local pane_id = pane:pane_id()
  local pane_user_vars = pane:get_user_vars()

  local selector = {
    dir = Utils.pane_working_dir(pane),
    bg_var = (pane_user_vars.bg and pane_user_vars.bg ~= "") and pane_user_vars.bg or nil,
    program = pane:get_title()
  }
  local conf_id = selector.dir .. "$" .. (selector.bg_var or "default") .. "$" .. selector.program

  local conf = pane_config_cache[pane_id]
  if not conf or conf.bg_id ~= conf_id then
    conf = load_pane_conf(pane, selector, conf_id)
    pane_config_cache[pane_id] = conf
  end

  return conf
end


return function(config)
  pane_config_cache = {}

  wezterm.on("user-var-changed", function(win, pane, name, value)
    if name == 'WEZTERM_PROG' or name == "bg" then
      win:set_config_overrides(get_pane_config(pane))
    end
  end)

  wezterm.on("update-status", function(win, pane)
      win:set_config_overrides(get_pane_config(pane))
  end)
end
