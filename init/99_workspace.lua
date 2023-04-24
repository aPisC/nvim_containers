local file_exists = require"init.utils".file_exists

local workspaceInitFile = "./.vscode/nvim.lua"
local vscodeLaunchFile = "./.vscode/launch.json"


if file_exists(workspaceInitFile) then
  dofile(workspaceInitFile) 
end

if file_exists(vscodeLaunchFile) then
  require("dap.ext.vscode").load_launchjs(vscodeLaunchFile) 
end

