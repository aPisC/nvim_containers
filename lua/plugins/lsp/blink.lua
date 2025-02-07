return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"saghen/blink.cmp",
				version = "*",
			},
			{ "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
			"rafamadriz/friendly-snippets",
			"fang2hou/blink-copilot",
		},
		opts = {
      _initialize_lazy = {
        -- completion = function()
        --   local Promise = require("promise")
        --   return Promise.rejected("Lazy loading blink completion is not supported")
        -- end
      },
			_initialize = {
				completion = function(_, opts)
					local tabpresstime = vim.call("reltime")
					local luasnip = require("luasnip")

					luasnip.setup({})
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_snipmate").lazy_load({ paths = "./snippets" })
					require("luasnip.loaders.from_vscode").load({ paths = "./snippets" })

					require("blink.cmp").setup({
						snippets = { preset = "luasnip" },
						signature = { enabled = true },
						completion = {
							ghost_text = {
								enabled = false,
								show_with_selection = false,
								show_without_selection = false,
							},
							documentation = {
								auto_show = true,
								auto_show_delay_ms = 500,
							},
							menu = {
								-- auto_show = true,
							},
							list = {
								selection = { preselect = false, auto_insert = true },
							},
							trigger = {
								-- show_on_trigger_character = false,
							},
						},
						appearance = {
							use_nvim_cmp_as_default = true,
							nerd_font_variant = "mono",
						},
						sources = {
							default = { "lsp", "path", "snippets", "buffer" },
							-- default = { "copilot", "snippets" },
							providers = {
								copilot = {
									name = "copilot",
									module = "blink-copilot",
									score_offset = 100,
									async = true,
									opts = {
										max_completions = 3,
									},
								},
							},
						},
						keymap = {
							preset = "enter",
							cmdline = {
							  preset = "super-tab",
								["<Up>"] = { "fallback" },
								["<Down>"] = { "fallback" },
							},
							["<Tab>"] = {
								function(cmp)
									local copilotvim_success, copilotvim_suggestion =
										pcall(vim.fn["copilot#GetDisplayedSuggestion"])
									if
										copilotvim_success
										and copilotvim_suggestion.text ~= ""
										and not cmp.get_selected_item()
									then
										local delay = vim.call("reltimefloat", vim.call("reltime", tabpresstime))
										if delay < 0.5 then
											vim.fn["feedkeys"](vim.fn["copilot#Accept"](""))
										else
											vim.fn["feedkeys"](vim.fn["copilot#AcceptWord"](""))
										end
										tabpresstime = vim.call("reltime")
										return true
									end
								end,
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
							-- ["<CR>"] = {
							-- 	"accept",
							-- 	"fallback",
							-- },
							-- ["<space>"] = {
							--   function(cmp)
							--     if cmp.get_selected_item() then
							--       cmp.accept()
							--     end
							--    vim.fn["feedkeys"](" ", "n")

							--   end,
							--   -- "fallback"
							-- },
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
					})
				end,
			},
			extend_capabilities = {
				blink = function(capabilities)
					local blink_capabilities = require("blink.cmp").get_lsp_capabilities()
					return vim.tbl_deep_extend("force", capabilities, blink_capabilities)
				end,
			},
		},
	},
}
