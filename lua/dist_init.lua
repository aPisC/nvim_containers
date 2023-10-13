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
    features = {
      copilot = false,
      csharp = false,
      emmet = false,
      http = false,
      json = true,
      lua = false,
      scala = false,
      typescript = false,
    },
    plugins = {}
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

    local config = {
      {import="plugins.editor"},
      {import="plugins.git"},
      {import="plugins.ui"},
      {import="plugins.theme"},
      {import="plugins.telescope"},
      {import="plugins.hydra"},
      {import="plugins.lsp"},
      {import="plugins.copilot", enabled = dist_config.features.copilot},
      {import="plugins.langs.emmet", enabled = dist_config.features.emmet},
      {import="plugins.langs.http", enabled = dist_config.features.http},
      {import="plugins.langs.json", enabled = dist_config.features.json},
      {import="plugins.langs.lua", enabled = dist_config.features.lua},
      {import="plugins.langs.scala", enabled = dist_config.features.scala},
      {import="plugins.langs.typescript", enabled = dist_config.features.typescript},
    }


    for _, plugin in ipairs(dist_config.plugins) do table.insert(config, plugin) end

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
