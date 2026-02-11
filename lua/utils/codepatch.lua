local M = {}

function M.find_upvalue(target, upvalue_name, ...)
  local nested_names = {...}
  local upvalue_index = 1

  while true do
    local name, value = debug.getupvalue(target, upvalue_index)
    if not name then return nil end
    if name == upvalue_name then
      if #nested_names == 0 then
        return value
      else
        return M.find_upvalue(value, unpack(nested_names))
      end
    end
    upvalue_index = upvalue_index + 1
  end
end

function M.patch(key, target, field, new_impl)
  local impl_store = vim.g.__vimpatch_impl_store or {}
  impl_store[key] = impl_store[key] or target[field]
  target[field] = function(...)
    return new_impl(impl_store[key], ...)
  end
end

return M
