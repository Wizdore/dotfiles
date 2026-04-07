require("options")
require("keymaps")

vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/vague-theme/vague.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/lewis6991/hover.nvim",
	"https://github.com/akinsho/toggleterm.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/folke/flash.nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("^1"),
	},
})

require("plugins.oil")
require("plugins.snacks")
require("plugins.vague")
require("plugins.blink")
require("plugins.flash")
require("plugins.hover")
require("plugins.conform")

vim.lsp.enable({ "lua_ls", "basedpyright", "rust_analyzer", "vtsls" })

vim.diagnostic.config({
	virtual_text = false, -- Shows error text at the end of the line
	signs = true, -- Shows icons in the gutter
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		border = "rounded",
		-- source = "always", -- Shows "rust-analyzer" in the float
	},
})

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
})
