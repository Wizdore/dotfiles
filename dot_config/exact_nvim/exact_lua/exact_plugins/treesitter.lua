-- Treesitter for syntax highlighting and more
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"bash",
				"c",
				"css",
				"diff",
				"html",
				"javascript",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"typescript",
				"vim",
				"vimdoc",
				"vue",
			},
			auto_install = true,
			highlight = {
				enable = true,
			},
		})
	end,
}
