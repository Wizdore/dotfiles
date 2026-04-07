require("snacks").setup({
	picker = { enabled = true },
	lazygit = { enabled = true },
	zen = { enabled = true },
	notifier = { enabled = true },
	input = { enabled = true },
	terminal = {
		enabled = true,
		win = {
			border = "rounded",
			style = "float",
			relative = "editor",
			width = 0.9,
			height = 0.9,
			row = 0.05,
			col = 0.05,
		},
	},
})

-- [[ Keymaps ]]
local map = vim.keymap.set

-- Picker (File Finding)
map("n", "<leader><leader>", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>ss", function()
	Snacks.picker.smart()
end, { desc = "Smart Find Files" })
map("n", "<leader>sf", function()
	Snacks.picker.files()
end, { desc = "Find Files" })
map("n", "<leader>sr", function()
	Snacks.picker.recent()
end, { desc = "Recent Files" })
map("n", "<leader>sg", function()
	Snacks.picker.grep()
end, { desc = "Grep Search" })

-- Zen Mode
map("n", "<leader>zz", function()
	Snacks.zen()
end, { desc = "Toggle Zen Mode" })
map("n", "<leader>ZZ", function()
	Snacks.zen.zoom()
end, { desc = "Toggle Zoom" })

-- Lazygit
map("n", "<leader>lg", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })

-- Yazi
map("n", "<leader>e", function()
	Snacks.terminal.toggle("yazi", {
		win = {
			style = "float",
			relative = "editor",
			width = 0.9,
			height = 0.9,
			row = 0.05,
			col = 0.05,
		},
	})
end, { desc = "Yazi" })

-- Terminal
map({ "n", "t" }, "<c-/>", function()
	Snacks.terminal.toggle()
end, { desc = "Terminal" })
