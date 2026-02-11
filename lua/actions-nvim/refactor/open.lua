return function()
	-- Show refactor menu
	local ACTIONS = require("actions-nvim.actions")

	local refactor_actions = {
		{ name = "Rename", action = ACTIONS["refactor.rename"] },
		{ name = "Extract Variable", action = ACTIONS["refactor.extract_variable"] },
		{ name = "Extract Constant", action = ACTIONS["refactor.extract_constant"] },
		{ name = "Extract Method", action = ACTIONS["refactor.extract_method"] },
		{ name = "Extract Field", action = ACTIONS["refactor.extract_field"] },
		{ name = "Inline", action = ACTIONS["refactor.inline"] },
		{ name = "Change Signature", action = ACTIONS["refactor.change_signature"] },
		{ name = "Optimize Imports", action = ACTIONS["refactor.optiomize_imports"] },
		{ name = "Safe Delete", action = ACTIONS["refactor.delete"] },
	}

	local choices = {}
	for _, item in ipairs(refactor_actions) do
		table.insert(choices, item.name)
	end

	vim.ui.select(choices, {
		prompt = "Refactor:",
	}, function(choice)
		if not choice then
			return
		end

		for _, item in ipairs(refactor_actions) do
			if item.name == choice then
				item.action()
				break
			end
		end
	end)
end
