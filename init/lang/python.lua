require("init.lsp")
  .ensure_tool("black")
  .ensure_lsp("pylsp")
  .ensure_dap("python")
  .set_formatter(
    { "python" },
    { require"formatter.filetypes.python".black }
  )

