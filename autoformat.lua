local M = {}

local config = {
  enabled = true,
  autocmd_created = false,
  enabled_lang = {
    ["*"] = false
  },
  formatter = {
    ["*"] = "FormatWrite"
  },
  initializers = {},
  locked = false,
}

function use_formatter(formatter) 
  if type(formatter) == "string" then
    vim.cmd(formatter)
  elseif type(formatter) == "table" then
    for i, v in ipairs(formatter) do use_formatter(v) end
  elseif type(formatter) == "function" then
    formatter()
  end
end

function M.format(lang)
  if config.locked then return end
  if not config.enabled then return end 
  if config.enabled_lang[lang] == false then return end
  if not (config.enabled_lang[lang] or config.enabled_lang["*"]) then return end

  local initializer = config.initializers[lang]
  if type(initializer) == "string" then
    config.initializers[lang] = nil
    vim.cmd(initializer)
  elseif type(initializer) == "function" then
    config.initializers[lang] = nil
    initializer()
  elseif initializer then
    config.initializers[lang] = nil
    print("Invalid autoformat initializer for", lang)
  end

  local formatter = config.formatter[lang] or config.formatter["*"]
  use_formatter(formatter)
end

function M.temp_lock(locked)
  config.locked = locked
end


function M.enable(lang) 
  if lang == nil or lang == "" then
    config.enabled = true
    print("Autoformat enabled")
  else
    config.enabled_lang[lang] = true
    print("Autoformat enabled for", lang)
  end
end

function M._enable(lang) 
  if lang == nil or lang == "" then
    config.enabled = true
  else
    config.enabled_lang[lang] = true
  end
end

function M.disable(lang) 
  if lang == nil or lang == "" then
    config.enabled = false
    print("Autoformat disabled")
  else
    config.enabled_lang[lang] = false
    print("Autoformat disabled for", lang)
  end
end

function M.initializer(lang, init)
  config.initializers[lang] = init
end

function M.setup(setup_config)
  if not config.autocmd_created then
    config.autocmd_created = true
    vim.api.nvim_create_autocmd({"BufWritePre"}, { pattern = {"*"}, callback=function()
      M.format(vim.bo.filetype)
    end})

    vim.api.nvim_create_user_command('Autoformat', function() M.format(vim.bo.filetype) end, {})
    vim.api.nvim_create_user_command('AutoformatDisable', function(args) M.disable(args.args) end, { nargs="?" })
    vim.api.nvim_create_user_command('AutoformatEnable', function(args) M.enable(args.args) end, { nargs="?" })
    vim.api.nvim_create_user_command('AutoformatSetFormatter', function(args) M.setup({[vim.bo.filetype] = args.args}) end, { nargs=1 })

  end

  M.configure(setup_config)
  return M
end

function M.configure(setup_config)
  for k, v in pairs(setup_config) do
    if v == true then
      config.enabled_lang[k] = true
      config.formatter[k] = nil
    elseif v == false  then
      config.enabled_lang[k] = false
      config.formatter[k] = nil
    else
      config.enabled_lang[k] = true
      config.formatter[k] = v
    end
  end
  return M
end

return M
