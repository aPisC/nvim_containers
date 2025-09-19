-- AWS sso credential module
local Credential = {
  prototype = {},
}

Credential.metatable = {
  __index = function(table, key) return Credential.prototype[key] end
}

function Credential.new(data)
  local o = {
    AccessKeyId=data.AccessKeyId,
    SecretAccessKey=data.SecretAccessKey,
    SessionToken=data.SessionToken,
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

  vim.notify("AWS credential initialization finished", "info", {title="AWS SSO"})
  return env
end

function exec(cmd, opts)
  local co = coroutine.running()
  opts = opts or {}

  vim.system(
    cmd,
    {
      timeout=opts.timeout or 30000, -- 30 seconds
      stderr = opts.stderr and function(err, data) if data and opts.stderr then opts.stderr(data) end end,
      stdout = opts.stdout and function(err, data) if data and opts.stdout then opts.stdout(data) end end,
    },
    function(out) vim.schedule(function() coroutine.resume(co, out) end) end
  )

  local out = coroutine.yield(co)

  if out.code ~= 0 then
    error("Command failed with code " .. out.code)
  end

  return out.stdout
end

function Credential.prototype.assume(cred, arn, session_name)
  vim.notify("Assuming role " .. arn, "info", {title="AWS SSO"})
  local command_template = "AWS_ACCESS_KEY_ID=$AccessKeyId AWS_SECRET_ACCESS_KEY=$SecretAccessKey AWS_SESSION_TOKEN=$SessionToken aws sts assume-role --role-arn=$Arn --role-session-name=$SessionName | jq .Credentials"
  local exec_env = { 
    Arn=arn, 
    SessionName=session_name,
    AccessKeyId=cred.AccessKeyId,
    SecretAccessKey=cred.SecretAccessKey,
    SessionToken=cred.SessionToken,
  }

  local stdout = exec { "sh", "-c", string.gsub(command_template, "%$(%w+)", exec_env) }
  local success, data = pcall(vim.json.decode, stdout)

  if not success then error(data) end
  return Credential.new(data)
end


local M = {
  Credential=Credential,
}

function M.profile(profile) 
  local co = coroutine.running()

  -- Login to aws sso
  vim.system(
    {"aws-sso-util", "login"}, 
    {
      text=true,
      timeout=30000, -- 30 seconds
      stderr = function(err, data) if data then vim.notify(data, "warn", {title="AWS SSO"}) end end,
      stdout = function(err, data) if data then vim.notify(data, "info", {title="AWS SSO"}) end end,
    },
    function(out) vim.schedule(function() coroutine.resume(co, out.code) end) end
  )
  local sso_login_code = coroutine.yield(co)
  if sso_login_code ~= 0 then
    vim.notify("Failed to login to AWS SSO", "error", {title="AWS SSO"})
    error("Failed to login to AWS SSO")
  end

  -- Extract credentials
  local data = exec{ "aws-sso-util", "credential-process", "--profile", profile }
  local success, data = pcall(vim.json.decode, data)
  if not success then error(data) end
  return Credential.new(data)
end

return M
