lua package.path = '/usr/share/nvim/runtime/lua/?.lua;' .. '/usr/share/nvim/runtime/lua/?/init.lua;'  .. package.path
lua dofile("/usr/share/nvim/runtime/init.lua")
