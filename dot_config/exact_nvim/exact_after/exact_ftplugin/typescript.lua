vim.opt_local.shiftwidth = 2

vim.api.nvim_create_autocmd("BufWritePre", {
	buffer = 0,
	callback = function()
		vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
	end,
})
