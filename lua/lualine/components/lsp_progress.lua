local M = require("lualine.component"):extend()
local lualine = require("lualine")

local default_options = {
  excludes = {}
}

M.init = function(self, options)
  M.super.init(self, options)

  -- Register event handler for lsp progress
  local old_progress = vim.lsp.handlers["$/progress"]
  vim.lsp.handlers["$/progress"] = function(...)
    if old_progress then old_progress(...) end
    self:handle_progress(...)
  end

  -- Register event handler for lsp message
  local old_message = vim.lsp.handlers["window/showMessage"]
  vim.lsp.handlers["window/showMessage"] = function(...)
    -- if old_message then old_message(...) end
    self:handle_message(...)
  end

  self.options = vim.tbl_deep_extend("force", {}, default_options, options)
  self.notifications = {}
end


M.handle_progress = function(self, _, result, context)
  local value = result.value

  local client_id = context.client_id
  local client_name = vim.lsp.get_client_by_id(client_id).name

  if vim.tbl_contains(self.options.excludes, client_name) then
    return 
  end

  local notification_id = client_name .. "#" .. result.token 

  if value.kind == "report" then
    -- create or update notification
    local notification = self.notifications[notification_id] or { 
      id = notification_id,
      client_name = client_name,
      name = result.token,
      value = value,
    }

    notification.message = value.message or ""
    notification.percentage = value.percentage
    notification.title = value.title or ""

    self.notifications[notification_id] = notification
  elseif value.kind == "end" then
    local notification = self.notifications[notification_id]

    if notification ~= nil then
      notification.message = value.message or ""
      notification.percentage = value.percentage or "Done"

      self:handle_done(notification)
      self.notifications[notification_id] = nil
    end
  end

  lualine.refresh()
end

M.handle_done = function(self, notification)
  if notification == nil and self.done_tasks ~=nil and #self.done_tasks > 0 then
    local tasks = self.done_tasks
    self.done_tasks = {}
    local message = table.concat(
      vim.tbl_map(function(task) return self:format_notification(task) end, tasks),
      "\n" 
    )
    self:handle_message(nil, { message = message }, { type = 3 }, nil)
    vim.defer_fn(function() self:handle_done() end, 5000)
  elseif notification == nil then
    self.done_tasks = nil
  elseif self.done_tasks == nil then
    self.done_tasks = { notification }
    self:handle_done()
  else
    table.insert(self.done_tasks, notification)
  end
end

M.handle_message = function(self, err, method, params, client_id)
  local severity = {
    vim.log.levels.ERROR,
    vim.log.levels.WARN,
    vim.log.levels.INFO,
    vim.log.levels.INFO,
  }

  self:notify(method.message, severity[params.type], { title = "LSP" })
end

M.notify = function(self, message, severity, opts)
  vim.notify(message, severity, opts)
end

M.format_notification = function(self, current)
  local msg = string.format("[%s] %s", current.client_name, current.title)
  if type(current.percentage) == "number"  then
    msg = msg .. string.format(" (%d%%)", current.percentage)
  elseif current.percentage ~= nil then
    msg = msg .. string.format(" (%s)", tostring(current.percentage))
  end
  if current.message ~= null then
    msg = msg .. " " .. current.message:gsub("\n", " | ")
  end
  return msg
end

M.update_status = function(self)
  local notification_list = vim.tbl_values(self.notifications)
  local current = notification_list[1]

  if current == nil then return "" end

  local msg = self:format_notification(current):gsub("%%", "%%%%")
  return msg
end

return M

