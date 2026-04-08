-- require("vim._core.ui2").enable({})
vim.lsp.enable({ "lua_ls", "basedpyright", "rust_analyzer", "vtsls" })
vim.cmd.packadd("nvim.difftool")

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
})
