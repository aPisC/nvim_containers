local utils = require("init.utils")

local M = {
  lsp_names = {},
  lsp_config = {},
  dap_names = {},
  dap_handlers = {},
  treesitter_names = {},
  formatters = {},
  neotest_adapters = {},
  tools = {},
}

function M.ensure_tool(tools)
  if type(tools) == "table" then
    for i,k in ipairs(tools) do
      table.insert(M.tools, k)
    end
  else
    table.insert(M.tools, tools)
  end
  return M
end

function M.ensure_lsp(lsp, config)
  table.insert(M.lsp_names, lsp) 
  M.lsp_config[lsp] = config
  return M
end

function M.ensure_dap(dap, handler)
  table.insert(M.dap_names, dap)
  M.dap_handlers[dap] = handler
  return M
end

function M.ensure_treesitter(name)
  table.insert(M.treesitter_names, name)
  return M
end

function M.set_formatter(filetypes, config)
  if type(filetypes) == "table" then
    for i,k in ipairs(filetypes) do
      M.formatters[k] = config
    end
  else
    M.formatters[filetypes] = config
  end
  return M
end 

function M.set_neotest(adapter) 
  table.insert(M.neotest_adapters, adapter)
  return M
end

function M.start() 
  require("mason").setup()
  require("mason-tool-installer").setup {
    ensure_installed = M.tools,
    auto_update = false,
    run_on_start = true,
    start_delay = 3000,
  }
  require("mason-lspconfig").setup {
    -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
    ensure_installed = M.lsp_names,
    automatic_installion = true,
  }
  require("mason-nvim-dap").setup{
    ensure_installed = M.dap_names,
    handlers = M.dap_handlers,
  }
  require('nvim-treesitter.configs').setup({
    ensure_installed = M.treesitter_names,
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      disable = { "lua", "help" },
      additional_vim_regex_highlighting = false,
    },
  })
  require("formatter").setup {
    logging = true,
    log_level = vim.log.levels.WARN,
    -- All formatter configurations are opt-in
    filetype = utils.merge_deep(
      {}, 
      {
        --https://github.com/mhartington/formatter.nvim
        ["*"] = {
           require("formatter.filetypes.any").remove_trailing_whitespace
         }
      }, 
      M.formatters
    )
  }
  require("neotest").setup({
    adapters = M.neotest_adapters,
    
  })

  for i, lsp in ipairs(M.lsp_names) do
    require("lspconfig")[lsp].setup(M.lsp_config[lsp] or {})
  end

  return M
end

return M
