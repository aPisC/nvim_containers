local M = {}

function M.merge_deep(target, ...)
  for i, tab in ipairs({...}) do
    for k,v in pairs(tab) do
      if type(target[k]) == "table" and type(v) == "table" then
        M.merge_deep(target[k], v)
      else
        target[k] = v
      end
    end
  end
  return target
end

function M.print(v) print(dump(v)) end 
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function M.file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

return M
