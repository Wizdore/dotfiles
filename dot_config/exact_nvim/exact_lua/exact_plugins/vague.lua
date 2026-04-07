require("vague").setup({
	italic = true,

	on_highlights = function(groups, colors)
		groups.Comment = { fg = colors.comment, italic = true }
		groups["@comment"] = { fg = colors.comment, italic = true }
	end,
})

vim.cmd.colorscheme("vague")
