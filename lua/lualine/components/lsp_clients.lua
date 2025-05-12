local M = require("lualine.component"):extend()
local utils = require("lualine.utils.utils")
local highlight = require("lualine.highlight")


local lsp_icons = {
  copilot = " ",
  ["GitHub Copilot"] = " ",
  tsserver = " ",
  ["typescript-tools"] = " ",
  tailwind = "󱏿 ",
  tailwindcss = "󱏿 ",
  emmet_ls = " ",
  emmet_language_server = " ",
  metals = " ",
  omnisharp = "󰌛 ",
  lua = " ",
  jsonls = "",
  texlab = " ",
  efm = "󱌣 ",
}

local default_options = {
  icons = {}
}

M.init = function(self, options)
  M.super.init(self, options)
	self.icons = vim.tbl_extend("force", lsp_icons, options.icons or {})
end

M.update_status = function(self)
  local has_dap, dap = pcall(require, "dap")
  local buf_clients = vim.lsp.get_clients({
    bufnr=vim.api.nvim_get_current_buf()
  })

  local buf_client_names = {}

  if has_dap and dap.session() ~= nil then
    table.insert(buf_client_names, " ")
  end


  for _, client in pairs(buf_clients) do
    if lsp_icons[client.name] ~= nil then
      table.insert(buf_client_names, lsp_icons[client.name])
    elseif lsp_icons[client.name] ~= false then
      table.insert(buf_client_names, "[" .. client.name .. "]")
    end
  end

  if #buf_client_names == 0 then return "" end
  return table.concat(buf_client_names, " ")
end

return M

