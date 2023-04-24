local workspaceFiles = {
  scala=[[
    -- Enable auto formatter for scala files
    -- vim.cmd("autocmd BufWritePre *.{scala,sbt} Neoformat")

    -- Override scala debugger config
    -- local dap = require("dap")
    -- dap.configurations.scala = {
    --   {
    --     type = "scala",
    --     request = "launch",
    --     name = "RunOrTest",
    --     metals = {
    --       runType = "runOrTestFile",
    --       --args = { "firstArg", "secondArg", "thirdArg" },
    --     },
    --   },
    -- }

    -- Override scalafmt config
    -- vim.g.neoformat_scala_scalafmt = {
    --   ['exe' ]= 'scalafmt',
    --   ['args' ]= { '--stdin', '-c', 'path/to/.scalafmt.conf'},
    --   ['stdin' ]= 1,
    -- }
  ]],
}

function init_workspace(arg)
  local lang = arg["args"]
  if not workspaceFiles[lang] then
    print("Config " .. lang .. " does not exist")
    return
  end
  os.execute("mkdir -p ./.vscode")
  local file = io.open("./.vscode/nvim.lua", "a+")
  file:write("-- Insert " .. lang .. " configuration\n")
  file:write(workspaceFiles[lang])
  file:write("\n\n\n")
  file:close()
end

vim.api.nvim_create_user_command('InitWorkspace', init_workspace, { nargs=1 })
