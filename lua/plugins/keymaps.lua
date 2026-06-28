local ACTIONS = require("actions-nvim.actions")

local function action(mode, action)
	local result = {}
	for i = 1, #mode do
		local char = mode:sub(i, i)
		result[char] = ACTIONS[action]
	end
	return result
end

local opts = {
	["IDE"] = {
		icon = "󰒋",
		itemgroup = "IDE",
		keymaps = {
			-- Find actions
			-- { "<C-n>", action("n", "find.class"), description = "Find class" },
			-- { "<C-F12>", action("n", "find.local_symbol"), description = "Find symbol in file" },
			{ "<C-p>", action("n", "find.file"), description = "Find file" },
			{ "<C-t>", action("n", "find.symbol"), description = "Find symbol in workspace" },
			{ "<C-f>", action("n", "find.local_text"), description = "Find text in file" },
			{ "<C-S-f>", action("n", "find.text"), description = "Find text in project" },

			-- Jump actions
			-- { "<C-S-B>", action("n", "jump.implementation"), description = "Go to implementation" },
			{ "<F12>", action("n", "jump.definition"), description = "Go to definition" },
			{ "<S-F12>", action("n", "jump.usages"), description = "Find usages" },
			{ "<M-Left>", action("n", "jump.prev"), description = "Navigate back" },
			{ "<M-Right>", action("n", "jump.next"), description = "Navigate forward" },
			{ "<C-e>", action("n", "jump.recent_files"), description = "Recent files" },
			{ "<F8>", action("n", "jump.next_diag"), description = "Next diagnostic" },
			{ "<S-F8>", action("n", "jump.prev_diag"), description = "Previous diagnostic" },

			-- Edit actions
			{ "<M-F>", action("n", "edit.format"), description = "Format code" },
			{ "<C-->", action("nv", "edit.comment_line"), description = "Toggle line comment" },
			{ "", action("nv", "edit.comment_block"), description = "Toggle block comment" },
			{ "<M-Up>", action("nvi", "edit.line_move_up"), description = "Move line up" },
			{ "<M-Down>", action("nvi", "edit.line_move_down"), description = "Move line down" },

			-- Completion actions
			{ "<C-Space>", action("ni", "completion.open"), description = "Trigger completion" },
			-- { "<C-q>", action("n", "completion.show_documentation"), description = "Show documentation" },
			-- { "<M-CR>", action("nvi", "completion.show_actions"), description = "Show code actions" },
			-- { "<C-p>", action("ni", "completion.show_parameter"), description = "Show parameter info" },

			-- Refactor actions
			{ "<F2>", action("n", "refactor.rename"), description = "Rename symbml" },
			-- { "<C-M-o>", action("n", "refactor.optiomize_imports"), description = "Optimize imports" },
			-- { "<C-M-v>", action("v", "refactor.extract_variable"), description = "Extract variable" },
			-- { "<C-M-c>", action("v", "refactor.extract_constant"), description = "Extract constant" },
			-- { "<C-M-m>", action("v", "refactor.extract_method"), description = "Extract method" },
			-- { "<C-M-f>", action("v", "refactor.extract_field"), description = "Extract field" },
			-- { "<C-M-n>", action("n", "refactor.inline"), description = "Inline" },
			-- { "<M-Del>", action("n", "refactor.delete"), description = "Safe delete" },
			-- { "<C-M-S-t>", action("nv", "refactor.open"), description = "Refactor this" },

			-- Multi Cursor actions
			{ "", action("n", "select.multi_match_next"), description = "[MC] Select next occurrence" },
			{ "", action("n", "select.multi_match_skip"), description = "[MC] Skip next occurrence" },
			{ "<C-F2>", action("n", "select.multi_match_all"), description = "[MC] Select all occurrences" },
			{
				"<M-I>",
				action("v", "select.multi_range_end"),
				description = "[MC] Add cursos to the end of selected lines",
			},
			{ "<M-LeftMouse>", action("n", "select.multi_click"), description = "[MC] Select with mouse" },
			{ "<M-S-LeftDrag>", action("n", "select.multi_drag"), hide = true },
			{ "<M-S-LeftRelease>", action("n", "select.multi_release"), hide = true },

			-- Generate actions
			-- { "<C-S-T>", action("v", "generate.surround_with"), description = "Surround with" },
			-- { "<M-Insert>", action("n", "generate.code"), description = "Generate code" },
			-- { "<C-M-I>", action("n", "generate.implementation"), description = "Generate implementation" },
			-- { "<C-M-O>", action("n", "generate.override"), description = "Generate override" },

			-- Tools
			{ "<C-S-E>", action("n", "tools.files"), description = "File tools" },
			{ "<C-S-Y>", action("n", "tools.debugger"), description = "Open Dap Repl" },
			{ "<S-CR>", action("n", "tools.diagnostics"), description = "Diagnostic tools" },
			{ "<C-S-G>", action("n", "tools.git"), description = "Git tools" },
			{ "<C-ö>", action("n", "tools.terminal"), description = "Open terminal" },
			{ "<C-0>", action("n", "tools.terminal"), description = "Open terminal" },
			{ "<C-S-P>", action("n", "tools.commands"), description = "Show commands" },
			{ "<F1>", action("n", "tools.help"), description = "Help tools" },
		},
    commands = {
      { ":Commands", ACTIONS["tools.commands"], description = "Show commands" },
      { ":Term", ACTIONS["tools.terminal"], description = "Open terminal" },
      { ":Git", ACTIONS["tools.git"], description = "Git tools" },
      { ":Diagnostics", ACTIONS["tools.diagnostics"], description = "Diagnostic tools" },
      { ":Debug", ACTIONS["tools.debugger"], description = "Open Dap Repl" },
      { ":Help", ACTIONS["tools.help"], description = "Help tools" },
      { ":Files", ACTIONS["find.file"], description = "File tools" },
      { ":Grep", ACTIONS["find.text"], description = "Grep in project" },
    }
	},

	["dap"] = {
		icon = "",
		itemgroup = "Dap",
		keymaps = {
			{ "<F5>", action("ni", "debugger.continue"), description = "Continue debugging" },
			{ "<S-F5>", action("ni", "debugger.stop"), description = "Stop debugging (󰘶 󱊯 )" },
			{ "<C-S-F5>", action("ni", "debugger.run_last"), description = "Run last debugging configuration (󰘳 󰘶 󱊯 )" },
			{ "<F9>", action("ni", "debugger.toggle_breakpoint"), description = "Toggle breakpoint" },
			{ "<S-F9>", action("ni", "debugger.conditional_breakpoint"), description = "Toggle conditional breakpoint (󰘶 󱊳 )" },
			{ "<F10>", action("ni", "debugger.step_over"), description = "Step over" },
			{ "<F11>", action("ni", "debugger.step_into"), description = "Step into" },
			{ "<S-F11>", action("ni", "debugger.step_out"), description = "Step out (󰘶 󱊵 )" },
		},
    commands = {
      { ":DapRunLast", ACTIONS["debugger.run_last"], description = "Run last debugging configuration" },
    }
	},

	["flash.nvim"] = {
		icon = "⚡",
		itemgroup = "Flash",
		keymaps = {
			{ "<Tab>", action("nox", "nvim.flash.jump"), description = "Flash jump" },
			{ "<S-Tab>", action("nox", "nvim.flash.treesitter"), description = "Flash treesitter" },
			{ "<C-Tab>", action("nox", "nvim.flash.remote"), description = "Flash remote" },
			{ "<C-S-Tab>", action("nox", "nvim.flash.treesitter_search"), description = "Flash treesitter search" },
		},
	},

	["neovide"] = {
		icon = "",
		itemgroup = "Neovide",
		enabled = vim.g.neovide ~= nil,
		keymaps = {
			{ "<C-ScrollWheelDown>", action("nv", "neovide.scale_up"), description = "Increase scale" },
			{ "<C-ScrollWheelUp>", action("nv", "neovide.scale_down"), description = "Decrease scale" },
			{ "<C-0>", action("nv", "neovide.scale_reset"), description = "Reset scale" },
			{ "<C-S-V>", action("ict", "neovide.paste"), description = "Paste from clipboard" },
			{ "<C-S-N>", action("nv", "neovide.new_window"), description = "New Neovide window" },
		},
		commands = {
			{ ":ToggleGobiMode", ACTIONS["neovide.toggle_gobi_mode"], description = "Toggle Gobi mode" },
			{ ":NeovideToggleOpacity", ACTIONS["neovide.toggle_opacity"], description = "Toggle Neovide opacity" },
			{ ":NeovideOpen", ACTIONS["neovide.new_window"], description = "Open new Neovide window" },
		},
	},

	["nvim-lspconfig"] = {
		icon = "󰢊",
		itemgroup = "LSP",
		commands = {
			{
				":LspHintInspect",
				require("utils.lsp-inspect-hint").inspect_hint,
				description = "Inspect inlay hints",
			},
			{
				":LspHintEnable",
				function()
					vim.lsp.inlay_hint.enable(true)
				end,
				description = "Enable inlay hints",
			},
			{
				":LspHintDisable",
				function()
					vim.lsp.inlay_hint.enable(false)
				end,
				description = "Disable inlay hints",
			},
		},
		keymaps = {
			-- { "<F12>", { n = ":Telescope lsp_definitions<CR>" }, description = "LSP Show definitions" },
			-- { "<F24>", { n = ":Telescope lsp_references<CR>" }, description = "LSP Show references" },
			-- { "gd", { n = ":Telescope lsp_definitions<CR>" }, description = "LSP Show definitions" },
			-- { "gr", { n = ":Telescope lsp_references<CR>" }, description = "LSP Show references" },
			-- {
			-- 	"gi",
			-- 	{ n = ":Telescope lsp_implementations<CR>" },
			-- 	description = "LSP Show implementations",
			-- },
			{
				"gx",
				{
					n = function(...)
						require("lsplinks").gx(...)
					end,
				},
				description = "LSP Open external link",
			},
			-- {
			-- 	"gt",
			-- 	{ n = ":Telescope lsp_type_definitions<CR>" },
			-- 	description = "LSP Show type definitions",
			-- },
			{
				"gk",
				{
					n = function()
						vim.diagnostic.setloclist()
					end,
				},
				description = "LSP show diagnostics in loclist",
			},
			{
				"gK",
				{ n = ":Telescope diagnostics<CR>" },
				description = "LSP Show workspace diagnostic",
			},
			-- {
			-- 	"gp",
			-- 	{ n = ":Telescope lsp_document_symbols<CR>" },
			-- 	description = "LSP Show document symbols",
			-- },
			-- {
			-- 	"<C-f>",
			-- 	{
			-- 		n = function(ev)
			-- 			-- local efm = vim.lsp.get_active_clients({ name = 'efm', bufnr = vim.api.nvim_get_current_buf() })

			-- 			-- if vim.tbl_isempty(efm) then
			-- 			-- else
			-- 			--   vim.lsp.buf.({ name = 'efm' })
			-- 			-- end
			-- 			--
			-- 			local lspconfig = require("lspconfig")
			-- 			local efm_modules = vim.tbl_get(
			-- 				lspconfig,
			-- 				"efm",
			-- 				"manager",
			-- 				"config",
			-- 				"settings",
			-- 				"languages",
			-- 				vim.bo.filetype
			-- 			) or {}
			-- 			local has_efm_formatter = vim.tbl_filter(function(module)
			-- 				return module.formatCommand
			-- 			end, efm_modules)[1] ~= nil

			-- 			if has_efm_formatter then
			-- 				vim.lsp.buf.format({ name = "efm" })
			-- 			else
			-- 				vim.lsp.buf.format()
			-- 			end
			-- 		end,
			-- 	},
			-- 	description = "LSP Format",
			-- },
			-- {
			-- 	"gP",
			-- 	{
			-- 		n = function()
			-- 			local query = vim.fn.input("Search for: ")
			-- 			if query == "" or query == nil then
			-- 				vim.cmd(":Telescope lsp_dynamic_workspace_symbols")
			-- 			else
			-- 				vim.cmd(":Telescope lsp_workspace_symbols query=" .. query)
			-- 			end
			-- 		end,
			-- 	},
			-- 	description = "LSP Show workspace diagnostic",
			-- },
			-- { "<F2>", { n = vim.lsp.buf.rename }, description = "LSP Rename symbol" },
			{
				"<M-CR>",
				{
					n = function()
						require("super_lens").run()
					end,
					v = function()
						require("super_lens").run()
					end,
					i = function()
						require("super_lens").run()
					end,
				},
				description = "LSP Code actions",
			},
			{
				"<M-S-CR>",
				{ n = vim.lsp.codelens.run, v = vim.lsp.codelens.run, i = vim.lsp.codelens.run },
				description = "LSP Code lens",
			},
			{ "K", { n = vim.lsp.buf.hover }, description = "LSP Hover" },
			{ "<C-g>e", { n = vim.diagnostic.goto_next }, description = "LSP Next diagnostic" },
			{ "<C-?>", { i = vim.lsp.buf.signature_help }, description = "LSP Signature help" },
		},
	},
}

return {
	{
		"mrjones2014/legendary.nvim",
		dependencies = {},
		opts = opts,
		config = function(_, opts)
			local config = {
				extensions = {
					lazy_nvim = true,
				},
				keymaps = {
					{
						"<Esc>",
						{
							n = {
								function()
									print("Clearing highlights")
									local has_mc, mc = pcall(require, "multicursor-nvim")
									if has_mc then
										if mc.hasCursors() then
											mc.clearCursors()
											return
										end
									end
									vim.cmd("noh")
								end,
								opts = { remap = true },
							},
						},
						description = "Clear highlights or multicursor",
					},
				},
			}

			for module_name, module_opts in pairs(opts) do
				if module_opts.enabled ~= false then
					table.insert(config.keymaps, {
						itemgroup = module_opts.itemgroup or module_name,
						icon = module_opts.icon,
						description = module_opts.description,
						keymaps = module_opts.keymaps,
						commands = module_opts.commands,
					})
				end
			end

			require("legendary").setup(config)
		end,
	},
}
