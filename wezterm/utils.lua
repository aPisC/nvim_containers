local Utils = {}

function Utils.resolve_path(path, working_dir)
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

function Utils.pane_working_dir(pane)
  local wd_raw = pane:get_current_working_dir()
  if not wd_raw then
    return ""
  end
  return wd_raw.file_path or ""
end


return Utils

