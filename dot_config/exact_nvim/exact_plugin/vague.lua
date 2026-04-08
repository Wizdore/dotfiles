vim.pack.add({
	"https://github.com/vague-theme/vague.nvim",
})

require("vague").setup({
	transparent = false,
	italic = false,
	on_highlights = function(groups, colors)
		groups.Normal = { bg = colors.bg }
		groups.Comment = { fg = colors.comment, italic = true }
		groups["@comment"] = { fg = colors.comment, italic = true }
		groups["@keyword"] = { fg = colors.keyword, italic = true }
	end,
})
vim.cmd.colorscheme("vague")
