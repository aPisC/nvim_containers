function exec(cmd)
    local handle = assert(io.popen(cmd, 'r'))
    local output = assert(handle:read('*a'))
    
    handle:close()
    
    return output 
end

-- AWS sso credential module

local Credential = {
  prototype = {},
}

Credential.metatable = {
  __index = function(table, key) return Credential.prototype[key] end
}

function Credential.new(cred)
  local o = {
    AccessKeyId=cred.AccessKeyId,
    SecretAccessKey=cred.SecretAccessKey,
    SessionToken=cred.SessionToken,
  }
  setmetatable(o, Credential.metatable) 
  return o
end

function Credential.prototype.env(cred, base_env)
  local env = {  
    AWS_ACCESS_KEY_ID=cred.AccessKeyId,
    AWS_SECRET_ACCESS_KEY=cred.SecretAccessKey,
    AWS_SESSION_TOKEN=cred.SessionToken,
  }
  for k,v in pairs(base_env or {}) do
    env[k] = v
  end
  return env
end

function Credential.prototype.exec(cred, command)
  return exec(
    string.gsub("AWS_ACCESS_KEY_ID=$AccessKeyId AWS_SECRET_ACCESS_KEY=$SecretAccessKey AWS_SESSION_TOKEN=$SessionToken", "%$(%w+)", cred) .. " " .. command
  )
end

function Credential.prototype.assume(cred, arn, session_name)
  local cred_str = Credential.prototype.exec(
    cred,
    string.gsub("aws sts assume-role --role-arn=$Arn --role-session-name=$SessionName | jq .Credentials", "%$(%w+)", { Arn=arn, SessionName=session_name })
  )
  return Credential.new(vim.json.decode(cred_str))
end

-- AWS sso module

local M = {
  Credential=Credential
}

function M.profile(profile) 
  exec("aws-sso-util login")
  local cred_str = exec("aws-sso-util credential-process --profile '" .. profile .. "'")
  return Credential.new(
    vim.json.decode(cred_str)
  )
end

return M
