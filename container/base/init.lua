require("init.00_plug")
require("init.01_plugins")
require("init.05_telescope")
require("init.06_tasks")
require("init.51_completion")
require("init.60_debugger")
require("init.91_vimoptions")
require("init.93_keymaps")
require("init.94_commands")
require("init.98_workspace_initializer")
require("init.99_workspace")

-- Setup languages
require("init.lsp").start()

-- Setup theme
require("init.theme").assert_setup({
  theme="vscode",
  variant="dark",
})
