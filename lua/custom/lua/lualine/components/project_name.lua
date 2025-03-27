local M = require("lualine.component"):extend()

local default_options = { }

M.init = function(self, options)
  M.super.init(self, options)
end

M.update_status = function(self)
  return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. " "
end

return M

