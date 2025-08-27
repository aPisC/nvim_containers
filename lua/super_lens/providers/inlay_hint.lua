local function select_label(label) 
  if label then
    local client = vim.lsp.get_client_by_id(label.client_id)
    assert(client, 'Client is required to execute lens, client_id=' .. (label.client_id or "<nil>"))
    client:exec_cmd(label.label.command, { bufnr = label.bufnr }, function(...)
      vim.lsp.handlers['workspace/executeCommand'](...)
    end)
  end
end

local function inspect_hint(hint)
  local client = vim.lsp.get_client_by_id(hint.client_id)
  if not client then
    print("LSP client not found")
    return
  end

  client:request('inlayHint/resolve', hint.inlay_hint, function(err, result, ctx) 
    local resolved_hint = assert(result, err or "No response from LSP server")

    local labels = vim.tbl_filter(
      function(v) return v.command end,
      resolved_hint.label or {}
    )

    local labels_with_ctx = vim.tbl_map(function(label)
      return { 
        label = label,
        client_id = ctx.client_id,
        bufnr = hint.bufnr,
      }
    end, labels)

    if #labels == 0 then
      print("No actionable labels found in inlay hint")
      return
    elseif #labels == 1 then
      select_label(labels_with_ctx[1])
      return
    else
      vim.ui.select(labels_with_ctx, {
        prompt = "Inlay hint action",
        format_item = function(item) return item.label.value end
      }, select_label)
    end
  end, 0)
end

local function get_display_label(item)
  local label = item.inlay_hint.label
  if type(label) == "string" then return label end

  if type(label) == "table" then
    if #label == 0 then return "<empty label>" end
    return vim.fn.join(
      vim.tbl_map(function(segment)
        if type(segment) == "string" then return segment
        elseif type(segment) == "table" and segment.value then return segment.value
        else return "???" 
        end
      end, label),
      ""
    )
  end

  return "<unknown label type>"
end

local function inlay_hint_provider(callback)
  local bufnr, lnum = unpack(vim.fn.getpos("."))

  local hints = vim.lsp.inlay_hint.get({ 
    bufnr = bufnr, 
    range = {
      start = { line = lnum -1, character = 0},
      ["end"] = { line = lnum, character = 0 }
    }
  })

  local results = vim.tbl_map(function(hint)
    return {
      label = get_display_label(hint),
      callback = function() inspect_hint(hint) end,
      kind = "inlay_hint",
      provider = "inlay_hint"
    }
  end, hints)

  callback(results)
end

return inlay_hint_provider

