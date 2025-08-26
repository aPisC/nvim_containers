local function open_hint()
  function select_label(label) 
    if label then
      if label.command.command == "goto-position" then
        local loc = label.command.arguments[1]
        vim.lsp.util.show_document(loc, 'utf-8', {focus=true})
      end
    end
  end

  function inspect_hint(hint)
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

      if #labels == 0 then
        print("No actionable labels found in inlay hint")
        return
      elseif #labels == 1 then
        select_label(labels[1])
        return
      else
        vim.ui.select(labels, {
          prompt = "Inlay hint action",
          format_item = function(item) return item.value end
        }, select_label)
      end
    end, 0)
  end


  local bufnr, lnum = unpack(vim.fn.getpos("."))

  local hints = vim.lsp.inlay_hint.get({ 
    bufnr = bufnr, 
    range = {
      start = { line = lnum -1, character = 0},
      ["end"] = { line = lnum, character = 0 }
    }
  })

  if #hints == 0 then
    print("No inlay hint found at cursor position")
  elseif #hints == 1 then
    inspect_hint(hints[1])
  else
    vim.ui.select(
      hints,
      {
        prompt = 'Select tabs or spaces:',
        format_item = function(item)
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
        end,
      },
      inspect_hint
    )
  end


end

return {
  inspect_hint = open_hint,
}

