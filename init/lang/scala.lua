local utils = require("init.utils")

require("init.lsp")
.set_formatter("scala", {function() 
  return {
    ['exe']= 'scalafmt',
    ['args']= { '--stdin' },
    ['stdin']= 1,
  }
end})
.set_neotest(
  require("neotest-scala")({
    -- -- Command line arguments for runner
    -- -- Can also be a function to return dynamic values
    -- args = {"--no-color"},
    -- -- Runner to use. Will use bloop by default.
    -- -- Can be a function to return dynamic value.
    -- -- For backwards compatibility, it also tries to read the vim-test scala config.
    -- -- Possibly values bloop|sbt.
    runner = "sbt",
    -- -- Test framework to use. Will use utest by default.
    -- -- Can be a function to return dynamic value.
    -- -- Possibly values utest|munit|scalatest.
    -- framework = "utest",
  })
)

local metals_config = utils.merge_deep(
  require("metals").bare_config(),
  {
    -- root_patterns=  {'build.sbt', 'build.sc', 'build.gradle', 'pom.xml', '.git'}
    -- root_patterns=  {'.git'},
    settings = {
      testUserInterface = "Test Explorer", 
      showImplicitArguments = true,
      showImplicitConversionsAndClasses = true,
      excludedPackages = {
        "akka.actor.typed.javadsl", 
        "com.github.swagger.akka.javadsl" 
      },
      -- serverVersion = "0.11.12",
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
