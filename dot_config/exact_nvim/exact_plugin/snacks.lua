vim.pack.add({
	"https://github.com/folke/snacks.nvim",
})

require("snacks").setup({
	picker = { enabled = true },
	lazygit = { enabled = true },
	notifier = { enabled = true },
	input = { enabled = true },
	scroll = { enabled = true },
	scratch = { enabled = true },
	indent = {
		priority = 1,
		enabled = true, -- enable indent guides
		char = "│",
		only_scope = true, -- only show indent guides of the scope
		only_current = true, -- only show indent guides in the current window
		hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
	},
	animate = {
		enabled = true,
		style = "out",
		easing = "quint",
		duration = {
			step = 20, -- ms per step
			total = 500, -- maximum duration
		},
	},
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

-- Terminal
map({ "n", "t" }, "<C-/>", function()
	Snacks.terminal.toggle()
end, { desc = "Terminal" })

-- Scratch buffer
map("n", "<leader>.", function()
	Snacks.scratch()
end, { desc = "Toggle scratch buffer" })

map("n", "<leader>,", function()
	Snacks.scratch.select()
end, { desc = "Select scratch buffer" })
