local api = vim.api
local lsp = vim.lsp
local util = vim.lsp.util
local ms = vim.lsp.protocol.Methods

local function range_from_selection(bufnr, mode)
  -- TODO: Use `vim.fn.getregionpos()` instead.

  -- [bufnum, lnum, col, off]; both row and column 1-indexed
  local start = vim.fn.getpos('v')
  local end_ = vim.fn.getpos('.')
  local start_row = start[2]
  local start_col = start[3]
  local end_row = end_[2]
  local end_col = end_[3]

  -- A user can start visual selection at the end and move backwards
  -- Normalize the range to start < end
  if start_row == end_row and end_col < start_col then
    end_col, start_col = start_col, end_col --- @type integer, integer
  elseif end_row < start_row then
    start_row, end_row = end_row, start_row --- @type integer, integer
    start_col, end_col = end_col, start_col --- @type integer, integer
  end
  if mode == 'V' then
    start_col = 1
    local lines = api.nvim_buf_get_lines(bufnr, end_row - 1, end_row, true)
    end_col = #lines[1]
  end
  return {
    ['start'] = { start_row, start_col - 1 },
    ['end'] = { end_row, end_col - 1 },
  }
end



local function apply_action(action, client, ctx)
  if action.edit then
    util.apply_workspace_edit(action.edit, client.offset_encoding)
  end
  local a_cmd = action.command
  if a_cmd then
    local command = type(a_cmd) == 'table' and a_cmd or action
    --- @cast command lsp.Command
    client:exec_cmd(command, ctx)
  end
end



local function format_item(item)
  local clients = lsp.get_clients({ bufnr = item.ctx.bufnr })
  local title = item.action.title:gsub('\r\n', '\\r\\n'):gsub('\n', '\\n')

  if item.action.disabled then
    title = title .. ' (disabled)'
  end

  if #clients == 1 then
    return title
  end

  local source = assert(lsp.get_client_by_id(item.ctx.client_id)).name
  return ('%s [%s]'):format(title, source)
end

function code_action_provider(callback)

  local opts = {}
  local context = {
    triggerKind = lsp.protocol.CodeActionTriggerKind.Invoked
  }

  local mode = api.nvim_get_mode().mode
  local bufnr = api.nvim_get_current_buf()
  local win = api.nvim_get_current_win()

  lsp.buf_request_all(bufnr, ms.textDocument_codeAction, function(client)
    ---@type lsp.CodeActionParams
    local params

    if opts.range then
      -- TODO: Implement range handling
      assert(type(opts.range) == 'table', 'code_action range must be a table')
      local start = assert(opts.range.start, 'range must have a `start` property')
      local end_ = assert(opts.range['end'], 'range must have a `end` property')
      -- params = util.make_given_range_params(start, end_, bufnr, client.offset_encoding)
    elseif mode == 'v' or mode == 'V' then
      local range = range_from_selection(bufnr, mode)
      params =
        util.make_given_range_params(range.start, range['end'], bufnr, client.offset_encoding)
    else
      params = util.make_range_params(win, client.offset_encoding)
    end

    --- @cast params lsp.CodeActionParams

    if context.diagnostics then
      params.context = context
    else
      local ns_push = lsp.diagnostic.get_namespace(client.id, false)
      local ns_pull = lsp.diagnostic.get_namespace(client.id, true)
      local diagnostics = {}
      local lnum = api.nvim_win_get_cursor(0)[1] - 1
      vim.list_extend(diagnostics, vim.diagnostic.get(bufnr, { namespace = ns_pull, lnum = lnum }))
      vim.list_extend(diagnostics, vim.diagnostic.get(bufnr, { namespace = ns_push, lnum = lnum }))
      params.context = vim.tbl_extend('force', context, {
        ---@diagnostic disable-next-line: no-unknown
        diagnostics = vim.tbl_map(function(d)
          return d.user_data.lsp
        end, diagnostics),
      })
    end

    return params
  end, function(results)
    -- Extract actions from results
    local actions = {}
    for client_id, result in pairs(results) do
      for _, action in pairs(result.result or {}) do
        table.insert(actions, { action = action, ctx = result.context or {
          client_id = client_id,
          bufnr = bufnr,
        } })
      end
    end


    local results = vim.tbl_map(function(item)
      return {
        label = format_item(item),
        kind = "code_action",
        provider = "code_action",
        callback = function()
          local choice = item
          local client = assert(lsp.get_client_by_id(choice.ctx.client_id))
          local action = choice.action
          local bufnr = assert(choice.ctx.bufnr, 'Must have buffer number')

          if type(action.title) == 'string' and type(action.command) == 'string' then
            apply_action(action, client, choice.ctx)
            return
          end

          if action.disabled then
            vim.notify(action.disabled.reason, vim.log.levels.ERROR)
            return
          end

          if not (action.edit and action.command) and client:supports_method(ms.codeAction_resolve) then
            client:request(ms.codeAction_resolve, action, function(err, resolved_action)
              if err then
                -- If resolve fails, try to apply the edit/command from the original code action.
                if action.edit or action.command then
                  apply_action(action, client, choice.ctx)
                else
                  vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
                end
              else
                apply_action(resolved_action, client, choice.ctx)
              end
            end, bufnr)
          else
            apply_action(action, client, choice.ctx)
          end
        end,
      }
    end, actions)

    callback(results)

  end)
end

return code_action_provider
