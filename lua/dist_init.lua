return function(system_dist_config)
  -- Start Lazy package manager
  require("keymaps")
  require("vimopts")

  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:append(lazypath)

  -- Configure plugins by dist config
  local default_dist_config = {
    -- modules by its name
    db = false,
    copilot = false,
    csharp = false,
    emmet = false,
    http = false,
    json = true,
    lua = false,
    scala = false,
    typescript = false,
    python = false,
    tailwind = false,

    -- plugins on indexes
  }

  function create_dist_config()
    -- Load dist configs from system -> workspace
    local has_workspace_configs, workspace_configs = pcall(dofile, "./.vscode/plugins.lua")
    local dist_config = vim.tbl_deep_extend(
      "force", 
      default_dist_config, 
      system_dist_config,
      has_workspace_configs and workspace_configs or {}
    )

    local collected_plugins = {}


    local config = {
      {import="plugins.keymaps"},
      {import="plugins.editor"},
      {import="plugins.git"},
      {import="plugins.ui"},
      {import="plugins.theme"},
      {import="plugins.telescope"},
      {import="plugins.hydra"},
      {import="plugins.lsp"},

      {import="plugins.copilot", enabled = dist_config.copilot},
      {import="plugins.db", enabled = dist_config.db},
      {import="plugins.langs.csharp", enabled = dist_config.csharp},
      {import="plugins.langs.emmet", enabled = dist_config.emmet},
      {import="plugins.langs.http", enabled = dist_config.http},
      {import="plugins.langs.json", enabled = dist_config.json},
      {import="plugins.langs.lua", enabled = dist_config.lua},
      {import="plugins.langs.scala", enabled = dist_config.scala},
      {import="plugins.langs.typescript", enabled = dist_config.typescript},
      {import="plugins.langs.python", enabled = dist_config.python},
      {import="plugins.langs.tailwind", enabled = dist_config.tailwind},
    }

    -- Collect plugins from configs
    for _, plugin in ipairs(default_dist_config) do table.insert(config, plugin) end
    for _, plugin in ipairs(system_dist_config) do table.insert(config, plugin) end
    for _, plugin in ipairs(has_workspace_configs and workspace_configs or {}) do table.insert(config, plugin) end

    return config
  end

  -- Start lazy with plugins
  require("lazy").setup(create_dist_config())

  -- Run workspace local init script
  function file_exists(name)
     local f=io.open(name,"r")
     if f~=nil then io.close(f) return true else return false end
  end

  local workspaceInitFile = "./.vscode/nvim.lua"
  local vscodeLaunchFile = "./.vscode/launch.json"

  if file_exists(workspaceInitFile) then
    dofile(workspaceInitFile)

    vim.api.nvim_create_autocmd({ "BufWritePost" }, { pattern = { "nvim.lua" }, callback=function()
      if (vim.fn.expand("%:.") == ".vscode/nvim.lua") then
        print("Reload workspace config...")
        dofile(workspaceInitFile)
      end
    end })
  end

  if file_exists(vscodeLaunchFile) then
    local has_dap, dap = pcall(require, "dap.ext.vscode")
    if has_dap then dap.load_launchjs(vscodeLaunchFile) end
  end
end
