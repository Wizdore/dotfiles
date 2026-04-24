vim.pack.add({
	"https://github.com/folke/snacks.nvim",
})

require("snacks").setup({
	picker = {
		sources = {
			buffers = {
				current = false,
				sort_lastused = true,
			},
		},
	},
	lazygit = { enabled = true },
	notifier = { enabled = true },
	input = { enabled = true },
	scroll = { enabled = true },
	scratch = { enabled = true },
	indent = {
		priority = 1,
		enabled = true,
		char = "│",
		only_scope = true,
		only_current = true,
		hl = "SnacksIndent",
		scope = {
			enabled = true,
			char = "│",
			hl = "SnacksIndentScope",
			filter = function(buf, scope)
				if not scope or not scope.node then return true end
				local excluded = {
					arguments = true,
					call_expression = true,
					method_call_expression = true,
				}
				return not excluded[scope.node:type()]
			end,
		},
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
map("n", "<leader><leader>", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>ss", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
map("n", "<leader>sf", function() Snacks.picker.files() end, { desc = "Find Files" })
map("n", "<leader>sr", function() Snacks.picker.recent() end, { desc = "Recent Files" })
map("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep Search" })
map("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })

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
