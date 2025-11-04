return {
	{
		"romanaverin/charleston.nvim",
		name = "charleston",
		opts = {
			terminal_colors = true,
			italic = true,
			darken_background = false,

			custom_colors = {
        green_bg = "#254524",
				teal_bg = "#1c4354",
				blue_bg = "#2a2e46",
				beige_bg = "#4a3c12",

			},
			-- Custom highlight group overrides similar to vscode theme
			-- These can be added based on your preferences
			group_overrides = {
				FloatBorder = { link = "NormalFloat" },

				RenderMarkdownCode = { bg = "${darker_gray}", fg = "NONE" },
				RenderMarkdownInfo = { fg = "${blue}" },
				RenderMarkdownChecked = { fg = "${green}" },

				["@markup.heading.1.markdown"] = { fg = "${text}", bg = "${green_bg}" },
				RenderMarkdownH1 = { fg = "${text}" },
				RenderMarkdownH1Bg = { bg = "${green_bg}" },

				["@markup.heading.2.markdown"] = { fg = "${text}", bg = "${teal_bg}" },
				RenderMarkdownH2 = { fg = "${text}" },
				RenderMarkdownH2Bg = { bg = "${teal_bg}" },

				["@markup.heading.3.markdown"] = { fg = "${text}", bg = "${blue_bg}" },
				RenderMarkdownH3 = { fg = "${text}" },
				RenderMarkdownH3Bg = { bg = "${blue_bg}" },
				--
				-- Notify plugin
				NotifyINFOTitle = { fg = "${blue}" },
				NotifyINFOIcon = { fg = "${blue}" },
				NotifyINFOBorder = { fg = "${blue}" },
				NotifyWARNTitle = { fg = "${orange}" },
				NotifyWARNIcon = { fg = "${orange}" },
				NotifyWARNBorder = { fg = "${orange}" },
				NotifyBackground = { bg = "${bg}" },

				-- Completion and Copilot
				CmpGhostText = { fg = "${charcoal}" },
				CopilotAnnotation = { fg = "${charcoal}" },
				CopilotSuggestion = { fg = "${charcoal}" },

				-- Navic icons (similar structure to vscode theme)
				NavicIconsFile = { link = "Structure" },
				NavicIconsModule = { link = "Structure" },
				NavicIconsNamespace = { link = "Structure" },
				NavicIconsPackage = { link = "Structure" },
				NavicIconsClass = { link = "Structure" },
				NavicIconsMethod = { link = "Function" },
				NavicIconsProperty = { link = "Identifier" },
				NavicIconsField = { link = "Identifier" },
				NavicIconsConstructor = { link = "Structure" },
				NavicIconsEnum = { link = "Type" },
				NavicIconsInterface = { link = "Type" },
				NavicIconsFunction = { link = "Function" },
				NavicIconsVariable = { link = "Identifier" },
				NavicIconsConstant = { link = "Constant" },
				NavicIconsString = { link = "String" },
				NavicIconsNumber = { link = "Number" },
				NavicIconsBoolean = { link = "Boolean" },
				NavicIconsArray = { link = "Structure" },
				NavicIconsObject = { link = "Structure" },
				NavicIconsKey = { link = "Identifier" },
				NavicIconsNull = { link = "Special" },
				NavicIconsEnumMember = { link = "Identifier" },
				NavicIconsStruct = { link = "Structure" },
				NavicIconsEvent = { link = "Type" },
				NavicIconsOperator = { link = "Operator" },
				NavicIconsTypeParameter = { link = "Type" },
				NavicText = { fg = "${text}" },
				NavicSeparator = { fg = "${text}" },

				DiffChange = { bg = "${blue_bg}" },
				DiffText = { bg = "${teal_bg}" },
				DiffDelete = { bg = "${diff_delete_bg}" },

				DapBreakpoint = { fg = "${red}" },
				DapLogPoint = { fg = "${blue}" },
				DapRejected = { fg = "${medium_gray}" },
				DapStopped = { bg = "${beige_bg}" },

				DapStoppedNumber = { bg = "${beige_bg}", fg = "${medium_gray}" },
			},
		},
		lazy = false,
		priority = 1000,
		config = function(plug, opts)
			local charleston = require("charleston")
			local colors =
				vim.tbl_deep_extend("force", {}, require("charleston.colors").palette, opts.custom_colors or {})

			local resolved_overrides = vim.tbl_map(function(override)
				return vim.tbl_map(function(value)
					if type(value) == "string" and value:match("^%${(.+)}$") then
						local color_name = value:match("^%${(.+)}$")
						if colors[color_name] then
							return colors[color_name]
						else
							error("Color '" .. color_name .. "' is not defined in the charleston color palette")
						end
					end
					return value
				end, override)
			end, opts.group_overrides)

			charleston.setup(opts)
			vim.o.background = "dark"
			vim.cmd.colorscheme("charleston")
			charleston.load()

			-- Set up a hook to apply overrides after colorscheme is loaded
			for group_name, group_settings in pairs(resolved_overrides) do
				vim.api.nvim_set_hl(0, group_name, group_settings)
			end
		end,
	},
}
