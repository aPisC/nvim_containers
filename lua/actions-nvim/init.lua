local actions = require("actions-nvim.actions")

local M = {}

function M.implement(action_name, implementation)
  actions._actions[action_name] = implementation
end

M.setup = function(opts)
  opts = opts or {}
  for action_name, implementation in pairs(opts) do
    M.implement(action_name, implementation)
  end
end

return M
