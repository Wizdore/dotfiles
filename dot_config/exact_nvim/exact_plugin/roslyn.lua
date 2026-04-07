vim.pack.add({
	{ src = "https://github.com/seblyng/roslyn.nvim" },
})

vim.lsp.config("roslyn", {
	capabilities = {
		textDocument = {
			diagnostic = {
				dynamicRegistration = false, -- tell roslyn not to register pull diagnostic providers
			},
		},
	},
	settings = {
		["csharp|inlay_hints"] = {
			csharp_enable_inlay_hints_for_implicit_object_creation = true,
			csharp_enable_inlay_hints_for_implicit_variable_types = true,
			csharp_enable_inlay_hints_for_lambda_parameter_types = true,
			csharp_enable_inlay_hints_for_types = true,
			dotnet_enable_inlay_hints_for_indexer_parameters = true,
			dotnet_enable_inlay_hints_for_object_creation_parameters = true,
			dotnet_enable_inlay_hints_for_other_parameters = true,
			dotnet_enable_inlay_hints_for_parameters = true,
		},
		["csharp|code_lens"] = {
			dotnet_enable_references_code_lens = true,
		},
		["csharp|completion"] = {
			dotnet_show_completion_items_from_unimported_namespaces = true,
		},
		["csharp|formatting"] = {
			dotnet_organize_imports_on_format = true,
		},
	},
})

require("roslyn").setup({
	broad_search = true,
	lock_target = false,
})

-- 1. Restore progress via snacks.nvim notifier (uses id to update in-place)
vim.api.nvim_create_autocmd("User", {
	pattern = "RoslynRestoreProgress",
	callback = function(ev)
		local token = ev.data.params[1]
		local state = ev.data.params[2]
		vim.notify(state.message or "", vim.log.levels.INFO, {
			id = "roslyn_restore_" .. token,
			title = "Roslyn: " .. (state.state or "Restoring"),
			timeout = false, -- keep open until finished
		})
	end,
})
vim.api.nvim_create_autocmd("User", {
	pattern = "RoslynRestoreResult",
	callback = function(ev)
		local msg = ev.data.err and ev.data.err.message or "Restore completed"
		vim.notify(msg, vim.log.levels.INFO, {
			id = "roslyn_restore_" .. ev.data.token,
			title = "Roslyn",
			timeout = 3000,
		})
	end,
})

-- 2. :CSFixUsings command
vim.api.nvim_create_user_command("CSFixUsings", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ name = "roslyn" })
	if not clients or vim.tbl_isempty(clients) then
		vim.notify("Couldn't find roslyn client", vim.log.levels.ERROR)
		return
	end
	local client = clients[1]
	local action = {
		kind = "quickfix",
		data = {
			CustomTags = { "RemoveUnnecessaryImports" },
			TextDocument = { uri = vim.uri_from_bufnr(bufnr) },
			CodeActionPath = { "Remove unnecessary usings" },
			Range = {
				["start"] = { line = 0, character = 0 },
				["end"] = { line = 0, character = 0 },
			},
			UniqueIdentifier = "Remove unnecessary usings",
		},
	}
	client:request("codeAction/resolve", action, function(err, resolved_action)
		if err then
			vim.notify("Fix usings failed", vim.log.levels.ERROR)
			return
		end
		vim.lsp.util.apply_workspace_edit(resolved_action.edit, client.offset_encoding)
	end)
end, { desc = "Remove unnecessary using directives" })
