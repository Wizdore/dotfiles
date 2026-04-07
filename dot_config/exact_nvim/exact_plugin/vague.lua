vim.pack.add({
	"https://github.com/vague-theme/vague.nvim",
})


require("vague").setup({
	italic = false,
	on_highlights = function(groups, colors)
		groups.Comment = { fg = colors.comment, italic = true }
		groups["@comment"] = { fg = colors.comment, italic = true }
		groups["@keyword"] = { fg = colors.keyword, italic = true }
	end,
})
vim.cmd.colorscheme("vague")
