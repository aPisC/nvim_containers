local utils = require("init.utils")

require("init.lsp")
.set_formatter("scala", {function() 
  return {
    ['exe']= 'scalafmt',
    ['args']= { '--stdin' },
    ['stdin']= 1,
  }
end})

local metals_config = utils.merge_deep(
  require("metals").bare_config(),
  {
    settings = {
      testUserInterface = "Test Explorer", 
      showImplicitArguments = true,
      showImplicitConversionsAndClasses = true,
      excludedPackages = {
        "akka.actor.typed.javadsl", 
        "com.github.swagger.akka.javadsl" 
      },
    },
    init_options = {statusBarProvider = "on"},
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    on_attach = function(client, bufnr) require("metals").setup_dap() end
  }
)

-- Configure metals autoCommand
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function() 
    require("metals").initialize_or_attach(metals_config) 
  end,
  group = vim.api.nvim_create_augroup("nvim-metals", { clear = true }),
})


-- Installing scalafmt with nailgun
--   coursier bootstrap 
--     --standalone com.geirsson:scalafmt-cli_2.12:1.5.1 
--     -r bintray:scalameta/maven 
--     -o /usr/local/bin/scalafmt_ng 
--     -f --main com.martiansoftware.nailgun.NGServer
--

-- vim.g.neoformat_scala_scalafmt_ng = {
--   ['exe' ]= 'ng-nailgun',
--   ['args' ]= {'scalafmt' },
--   ['stdin' ]= 0,
--   ['replace']= 1,
-- }
