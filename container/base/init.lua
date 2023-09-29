require("keymaps")
require("vimopts")

-- Start Lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:append(lazypath)


require("lazy").setup({
  {import="plugins.editor"},
  {import="plugins.git"},
  {import="plugins.ui"},
  {import="plugins.theme"},
  {import="plugins.telescope"},

  {import="plugins.lsp"},
  {import="plugins.langs.typescript"},
  {import="plugins.langs.http"},
  {import="plugins.langs.emmet"},
})

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
  require("dap.ext.vscode").load_launchjs(vscodeLaunchFile) 
end

