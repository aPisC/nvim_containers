return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(plug, opts)
      table.insert(opts.ensure_installed, "json")
      table.insert(opts.ensure_installed, "http")
      return opts
    end
  },
  -- {
  --   'WhoIsSethDaniel/mason-tool-installer.nvim',
  --   opts = function(plug, opts)
  --     table.insert(opts.ensure_installed, "htmlbeautifier")
  --     return opts
  --   end
  -- },
  {
    'aPisC/rest.nvim',
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function(plug, opts)
      require("rest-nvim").setup(opts)

      local aug = vim.api.nvim_create_augroup("RestNvim", {clear=true})
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "http",
        callback = function()
          vim.keymap.set({'n', 'i'}, '<M-CR>', function(args) require("rest-nvim").run() end, {buffer=true} )
          vim.keymap.set({'n', 'i'}, '<M-?>', function(args) require("rest-nvim").run(true) end, {buffer=true} )
        end
      })
      vim.api.nvim_buf_create_user_command(0, "RestRun", function(args) require("rest-nvim").run() end, {})
      vim.api.nvim_buf_create_user_command(0, "RestPreview", function(args) vim.inspect(require("rest-nvim").run(true)) end, {})
      vim.api.nvim_buf_create_user_command(0, "RestLast", function(args) require("rest-nvim").last() end, {})
      vim.api.nvim_create_user_command("Rest", function() vim.cmd":e .vscode/requests.http" end, {})
    end,
    opts = {
      -- Open request results in a horizontal split
      result_split_horizontal = true,
      -- Keep the http file buffer above|left when split horizontal|vertical
      result_split_in_place = true,
      -- Skip SSL verification, useful for unknown certificates
      skip_ssl_verification = true,
      -- Encode URL before making request
      encode_url = true,
      -- Highlight request on run
      highlight = {
        enabled = true,
        timeout = 500,
      },
      result = {
        -- toggle showing URL, HTTP info, headers at top the of result window
        show_url = true,
        -- show the generated curl command in case you want to launch
        -- the same request via the terminal (can be verbose)
        show_curl_command = true,
        show_http_info = true,
        show_headers = true,
        -- executables or functions for formatting response body [optional]
        -- set them to false if you want to disable them
        formatters = {
          json = "jq",
          html = false,
        },
      },
      -- Jump to request line on run
      jump_to_request = false,
      env_file = '.env',
      custom_dynamic_variables = {},
      yank_dry_run = true,
    },
  },
}
