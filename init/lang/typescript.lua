require("init.lsp")
.ensure_lsp("tsserver")
.ensure_dap("node2")
.set_formatter(
  {"typescript", "typescriptreact"},
  { require"formatter.filetypes.typescriptreact".prettierd }
)

-- Debugger
-- require("dap-vscode-js").setup({
--   node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
--   debugger_path = "/home/bendeguz/.config/nvim/plugged/vscode-js-debug", -- Path to vscode-js-debug installation.
--   adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
--   -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
-- })
-- require("dap").configurations["typescript"] = {
--   {
--     type = "pwa-node",
--     request = "launch",
--     runtimeExecutable = "npm",
--     name = "npm start",
--     args = {"start"},
--     cwd = "${workspaceFolder}",
--   }
-- }
-- require("dap").configurations["javascript"] = {
--   {
--     type = "node",
--     request = "launch",
--     name = "Launch file",
--     program = "${file}",
--     cwd = "${workspaceFolder}",
--   },
--   {
--     type = "node",
--     request = "launch",
--     runtimeExecutable = "npm",
--     name = "Launch npm start",
--     autoAttachChildProcesses = true,
--     runtimeArgs = {"run-script", "start"},
--     cwd = "${workspaceFolder}",
--   }
-- }

