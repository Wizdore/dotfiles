require("flash").setup({
	labels = "sternichad",
	modes = {
		char = {
			enabled = false,
		},
	},
	jump = {
		nohlsearch = true,
	},
	label = {
		after = true,
		before = false,
		uppercase = false,
	},
	search = {
		multi_window = true,
		wrap = true,
	},
})

vim.keymap.set({ "n", "x", "o" }, "f", function()
	require("flash").jump()
end)

vim.keymap.set({ "n", "x", "o" }, "F", function()
	require("flash").treesitter()
end)
