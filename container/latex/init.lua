-- Load all .lua files from ~/.config/nvim directory ordered by name 
-- (except: init.lua to avoid recutrion)



-- local dir = "/home/bendeguz/.config/nvim"
-- for file in io.popen('find "'..dir..'" -maxdepth 1 -type f | sort | grep -v init.lua$ | grep .lua$'):lines() do
--   dofile(file)       
-- end

package.path = '/root/.config/nvim/?.lua;' .. '/root/.config/nvim/?/init.lua;'  .. package.path

require("init.00_plug")
require("init.01_plugins")
require("init.02_statuscol")
require("init.03_lualine")
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
require("init.lang.latex")
require("init.lsp").start()

-- Setup theme
require("init.theme").assert_setup({
  theme="vscode",
  variant="dark",
})
