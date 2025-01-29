-- AWS sso credential module
local Credential = {
  prototype = {},
}

Credential.metatable = {
  __index = function(table, key) return Credential.prototype[key] end
}

function Credential.new(thunk)
  local o = {
    thunk = thunk
  } 
  setmetatable(o, Credential.metatable) 
  return o
end

function Credential.prototype.env(cred, base_env)
     return coroutine.create(
       function(callback_co)
          local base_co = cred.thunk()

          local success, data = coroutine.resume(base_co, coroutine.create(
            function(data)
                local env = {  
                  AWS_ACCESS_KEY_ID=data.AccessKeyId,
                  AWS_SECRET_ACCESS_KEY=data.SecretAccessKey,
                  AWS_SESSION_TOKEN=data.SessionToken,
                }
                for k,v in pairs(base_env or {}) do
                  env[k] = v
                end

                vim.notify("AWS credential initialization finished", "info", {title="AWS SSO"})

                local success, data = coroutine.resume(callback_co, env)
                if not success then error(data) end
                return data
            end
          ))

          if not success then error(data) end
        end
     )
 end



 function exec_async(callback_co, cmd, opts)
   opts = opts or {}
   vim.system(
     cmd,
     {
       timeout=opts.timeout or 30000, -- 30 seconds
       stderr = opts.stderr and function(err, data) if data and opts.stderr then opts.stderr(data) end end,
       stdout = opts.stdout and function(err, data) if data and opts.stdout then opts.stdout(data) end end,
     },
     function(out)
       if out.code ~= 0 then
         error("Command failed with code " .. out.code)
       end

       local success, data = coroutine.resume(callback_co, out.stdout)
       if not success then error(data) end
       return data
     end
   )
 end

function Credential.prototype.assume(cred, arn, session_name)
  return Credential.new(
    function()
      return coroutine.create(
        function(callback_co)
          local base_co = cred.thunk()
          local success, data = coroutine.resume(base_co, coroutine.create(
            function(data)
              
              vim.notify("Assuming role " .. arn, "info", {title="AWS SSO"})
              exec_async(
                coroutine.create(function(stdout)
                  local data = vim.json.decode(stdout)
                  coroutine.resume(callback_co, data)
                end),
                {
                  "sh", 
                  "-c",
                  string.gsub(
                    "AWS_ACCESS_KEY_ID=$AccessKeyId AWS_SECRET_ACCESS_KEY=$SecretAccessKey AWS_SESSION_TOKEN=$SessionToken aws sts assume-role --role-arn=$Arn --role-session-name=$SessionName | jq .Credentials",
                    "%$(%w+)", 
                    { 
                      Arn=arn, 
                      SessionName=session_name,
                      AccessKeyId=data.AccessKeyId,
                      SecretAccessKey=data.SecretAccessKey,
                      SessionToken=data.SessionToken,
                    }
                  )
                }
              )
            end
          ))

          if not success then error(data) end
          return data
      end)
    end
  )
end

-- AWS sso module

local M = {
  Credential=Credential,
}

function M.profile(profile) 
  return Credential.new(
    function()
      return coroutine.create(
        function(callback_co)
          vim.system(
            {"aws-sso-util", "login"}, 
            {
              text=true,
              timeout=30000, -- 30 seconds
              stderr = function(err, data) if data then vim.notify(data, "warn", {title="AWS SSO"}) end end,
              stdout = function(err, data) if data then vim.notify(data, "info", {title="AWS SSO"}) end end,
            },
            function(out)
              if out.code ~= 0 then
                vim.notify("Failed to login to AWS SSO", "error", {title="AWS SSO"})
                error("Failed to login to AWS SSO")
              end

              exec_async(
                coroutine.create(function(stdout)
                  local data = vim.json.decode(stdout)
                  local success, data = coroutine.resume(callback_co, data)
                  if not success then error(data) end
                  return data
                end),
                {
                  "aws-sso-util",
                  "credential-process",
                  "--profile",
                  profile
                }
              )
            end
          )
        end
        )
    end
  )
end

return M
