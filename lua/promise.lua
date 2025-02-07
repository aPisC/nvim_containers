local Promise = {}

 function Promise.new(fn)
    local trace = debug.traceback()
    thread = coroutine.create(function(callback_co)
      local function resolve()
        local status, data = coroutine.resume(callback_co) 
        if not status then error(data) end
        return data
     end

      status, result = pcall(fn, resolve)
      if not status then error(result .. "\n\n" ..trace) end
      return result
    end)
    return thread
  end

 function Promise._then(thread_1, thread_2)
  if type(thread_1) == "table" and thread2 == nil then
    local threads = thread_1
    local thread = coroutine.create(function(callback_co)
      local status, data = coroutine.resume(callback_co)
      if not status then error(data) end
      return data
    end)
    for i = 1, #threads do
      thread = Promise._then(thread, threads[i])
    end
    return thread
  end

  return coroutine.create(function(callback_co)
    local cont = coroutine.create(function()
      local status, data = coroutine.resume(thread_2, callback_co)
      if not status then error(data) end
      return data
    end)
    local status, data = coroutine.resume(thread_1, cont)
    if not status then error(data) end
    return data
  end)
end

function Promise._join(thread)
  local status, data = coroutine.resume(thread, coroutine.create(function() end))
  if not status then error(data) end
  return data
end

function Promise.resolved(value)
  return Promise.new(function(resolve) resolve(value) end)
end

function Promise.rejected(value)
  return Promise.new(function(_, reject) error(value) end)
end

function Promise.catch(thread, fn)
  return coroutine.create(function(callback_co)
    local thread_success = false

    local continuation = coroutine.create(function()
      thread_success = true
      local status, data = coroutine.resume(callback_co)
      if not status then error(data) end
      return data
    end)

    local status, data = coroutine.resume(thread, continuation)
    if not status then
      if thread_success then
        error(data)
      else
        fn(data)
        local status, data = coroutine.resume(callback_co)
        if not status then error(data) end
        return data
      end
    end

  end)
end


return Promise
