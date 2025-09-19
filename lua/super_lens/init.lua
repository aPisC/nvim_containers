local providers = require("super_lens.providers")

---@class SuperLensItem
---@field label string The display label for the item
---@field callback function The callback function to execute when the item is selected
---@field kind string The type of the item defined by the provider 
---@field provider string The name of the provider

local default_config = {
  providers = {
    code_action = providers.code_action,
    code_lens = providers.code_lens,
    inlay_hint = providers.inlay_hint,
    custom = false
  },
  timeout_ms = 5000,  -- Timeout for provider callbacks in milliseconds
  icons = {
    code_action = "💡",
    code_lens = "🔍",
    inlay_hint = "💭",
    timeout = "⏳",
  }
}

local M = {}

M.config = default_config

function M.run()
  -- Collect enabled providers
  local enabled_providers = {}
  for name, provider in pairs(M.config.providers) do
    if provider then
      enabled_providers[name] = provider
    end
  end

  -- Track provider completion status
  local provider_status = {}
  local provider_results = {}
  local total_providers = 0
  local timeout_triggered = false

  -- Initialize tracking objects
  for name, _ in pairs(enabled_providers) do
    provider_status[name] = false
    provider_results[name] = {}
    total_providers = total_providers + 1
  end

  -- If no providers are enabled, show message and return
  if total_providers == 0 then
    vim.notify("No providers enabled", vim.log.levels.INFO)
    return
  end

  -- Function to check if all providers have completed
  local function check_completion()
    local completed_count = 0
    for _, completed in pairs(provider_status) do
      if completed then
        completed_count = completed_count + 1
      end
    end
    return completed_count == total_providers
  end

  -- Function to handle when all providers complete
  local function handle_all_complete()
    -- Don't process if we've already handled completion
    if timeout_triggered then
      return
    end
    timeout_triggered = true

    -- Flatten all results into a single list
    local all_results = {}
    for _, results in pairs(provider_results) do
      for _, item in ipairs(results) do
        table.insert(all_results, item)
      end
    end

    -- Check if we have any items
    if #all_results == 0 then
      vim.notify("[SuperLens] No actions available", vim.log.levels.INFO)
      return
    end

    -- Use vim.ui.select to let user choose an action
    vim.ui.select(all_results, {
      prompt = "Select an action:",
      format_item = function(item)
        return string.format("%s%s", M.config.icons[item.kind] or ("[" .. item.kind .. "]"), item.label)
      end
    }, function(selected_item)
      if selected_item and selected_item.callback then
        selected_item.callback()
      end
    end)
  end

  -- Set up timeout to force completion if providers don't respond
  vim.defer_fn(function()
    if not timeout_triggered then
      -- Mark any incomplete providers as completed with placeholder items
      for name, completed in pairs(provider_status) do
        if not completed then
          provider_results[name] = {
            {
              label = string.format("%s %s provider did not respond", M.config.icons.timeout, name),
              callback = function()
                vim.notify(string.format("Provider '%s' timed out", name), vim.log.levels.WARN)
              end,
              kind = "timeout",
              provider = name
            }
          }
          provider_status[name] = true
        end
      end
      
      -- Handle completion with whatever we have
      handle_all_complete()
    end
  end, M.config.timeout_ms)

  -- Invoke all enabled providers with callbacks
  for name, provider in pairs(enabled_providers) do
    provider(function(items)
      -- Only process if we haven't timed out yet
      if not timeout_triggered then
        -- Store results from this provider
        provider_results[name] = items or {}
        provider_status[name] = true
        
        -- Check if all providers have completed
        if check_completion() then
          handle_all_complete()
        end
      end
    end)
  end
end



return M
