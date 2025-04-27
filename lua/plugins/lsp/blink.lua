local osu = require("utils.os")


local function file_type_mapper(opts)
  return function()
    local filetype = vim.bo.filetype
    return opts[filetype] ~= nil and opts[filetype] or opts["*"]
  end
end

return {
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
			{ "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
			"rafamadriz/friendly-snippets",
    },
    opts = {
      enabled = { ["*"] = true },
      fuzzy = {
        implementation = osu.cond({windows = "lua" })
      },
      snippets = { preset = "luasnip" },
      cmdline =  { 
        enabled = true,
        keymap = { preset = "cmdline" }
      },
      signature = { 
        enabled = true,
        window = { border = "rounded" },
      },
      completion = {
        accept = { auto_brackets = { enabled = false }, },
        ghost_text = { 
          enabled =  { ["*"] = true } 
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          window = { border = "rounded" },
        },
        menu = { 
          border="rounded", 
          auto_show = { ["*"] = false }
        },
        list = {
          selection = { preselect = true, auto_insert = false },
        },
      },
      -- appearance = {
      --   use_nvim_cmp_as_default = true,
      --   nerd_font_variant = "mono",
      -- },
      sources = {
        default = { 
          lsp = true,
          path = true,
          snippets = true,
          buffer = true,
        },
      },
      keymap = {
        preset = "enter",
        ["<Tab>"] = {
            "snippet_forward",
            "select_next",
            function(cmp)
              if cmp.snippet_active() then
                return cmp.accept()
              else
                return cmp.select_and_accept()
              end
            end,
            "fallback",
          },
          ["<S-Tab>"] = {
            "snippet_backward",
            "select_prev",
            "fallback",
          },
          ["<esc>"] = {
            function(cmp)
              local copilotvim_success, copilotvim_suggestion =
              pcall(vim.fn["copilot#GetDisplayedSuggestion"])
              if copilotvim_success and copilotvim_suggestion.text ~= "" then
                vim.fn["copilot#Dismiss"]()
                return true
              end
            end,
            "hide",
            "fallback",
          },
        },
    },
    config = function(_, opts)
      local blink = require("blink.cmp")
      local luasnip = require("luasnip")

      luasnip.setup({})

      -- Load snippets from friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load({ paths = "./snippets" })
      require("luasnip.loaders.from_vscode").load({ paths = "./snippets" })

      -- Setup Blink
      local resolved_opts = vim.tbl_deep_extend("force", opts, {
        enabled = file_type_mapper(opts.enabled),
        sources = {
          default = vim.tbl_filter(
            function(source) return opts.sources.default[source] end, 
            vim.tbl_keys(opts.sources.default)
          ),
        },
        completion = {
          ghost_text = {
            enabled = file_type_mapper(opts.completion.ghost_text.enabled),
          },
          menu = {
            auto_show = file_type_mapper(opts.completion.menu.auto_show),
          }
        }
      })

      blink.setup(resolved_opts)
    end,
  },
	{
		"neovim/nvim-lspconfig",
		opts = {
			extend_capabilities = {
				blink = function(capabilities)
					local blink_capabilities = require("blink.cmp").get_lsp_capabilities()
					return vim.tbl_deep_extend("force", capabilities, blink_capabilities)
				end,
			},
		},
	},
}
