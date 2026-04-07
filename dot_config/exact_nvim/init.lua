-- require("vim._core.ui2").enable({})

vim.lsp.enable({ "lua_ls", "basedpyright", "rust_analyzer", "vtsls" })

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		border = "rounded",
	},
})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", on_macro = true, timeout = 300 })
	end,
})

-- Keep the scroll size consistent to 10 even after resize
vim.api.nvim_create_autocmd("VimResized", {
	callback = function()
		vim.o.scroll = 10
	end,
})

-- Show diagnostic on CursorHold
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
})

-- refresh diagnostics on InsertLeave
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local clients = vim.lsp.get_clients({ bufnr = bufnr })
		if not clients or #clients == 0 then
			return
		end

		for _, client in ipairs(clients) do
			if client:supports_method("textDocument/diagnostic") then
				local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
				client:request("textDocument/diagnostic", params, nil, bufnr)
			end
		end
	end,
})
