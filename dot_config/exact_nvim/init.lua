require('vim._core.ui2').enable({})

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

vim.api.nvim_create_autocmd("VimResized", {
	callback = function()
		vim.o.scroll = 10
	end,
})

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
})
