local api = vim.api
local ms = vim.lsp.protocol.Methods

local function get_display_label(item)
  local lens = item.lens
  if lens.command and lens.command.title then
    return lens.command.title
  elseif lens.label then
    if type(lens.label) == "string" then
      return lens.label
    elseif type(lens.label) == "table" then
      return table.concat(vim.tbl_map(function(part)
        return part.value
      end, lens.label), "")
    end
  end
  return "<no label>"
end

local function get_lenses_by_client(bufnr)
  local upvalue_name, lens_cache_by_buf = debug.getupvalue(vim.lsp.codelens.get, 1)
  if upvalue_name ~= "lens_cache_by_buf" then
    error("Unexpected upvalue name: " .. tostring(upvalue_name))
  end
  return lens_cache_by_buf[bufnr] or {}
end

local function execute_lens(lens, bufnr, client_id)
  local line = lens.range.start.line
  local namespaces = vim.lsp.codelens.__namespaces
  api.nvim_buf_clear_namespace(bufnr, namespaces[client_id], line, line + 1)

  local client = vim.lsp.get_client_by_id(client_id)
  assert(client, 'Client is required to execute lens, client_id=' .. client_id)
  client:exec_cmd(lens.command, { bufnr = bufnr }, function(...)
    vim.lsp.handlers[ms.workspace_executeCommand](...)
    vim.lsp.codelens.refresh()
  end)
end

local function code_lens_provider(callback)
  local line = api.nvim_win_get_cursor(0)[1] - 1
  local bufnr = api.nvim_get_current_buf()

  local lenses_by_client = get_lenses_by_client(bufnr)
  
  local filtered_lenses = {}
  for client, lenses in pairs(lenses_by_client) do
    for _, lens in pairs(lenses) do
      if
        lens.command
        and lens.command.command ~= ''
        and lens.range.start.line <= line
        and lens.range['end'].line >= line
        then
          table.insert(filtered_lenses, { client = client, lens = lens, bufnr = bufnr })
        end
      end
    end

  local results = vim.tbl_map(function(lens)
    return {
      label = get_display_label(lens),
      callback = function() execute_lens(lens.lens, lens.bufnr, lens.client) end,
      kind = "code_lens",
      provider = "code_lens"
    }
  end, filtered_lenses)

  callback(results)
end

return code_lens_provider
