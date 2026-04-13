vim.pack.add({
	"https://github.com/olimorris/codecompanion.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
})

require("codecompanion").setup({
	adapters = {
		http = {
			copilot = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "claude-opus-4.6",
						},
					},
				})
			end,
		},
	},
	strategies = {
		chat = {
			adapter = "copilot",
			slash_commands = {
				["buffer"] = { opts = { provider = "snacks" } },
				["file"] = { opts = { provider = "snacks" } },
				["symbols"] = { opts = { provider = "snacks" } },
				["help"] = { opts = { provider = "snacks" } },
			},
		},
		inline = {
			adapter = "copilot",
		},
		cmd = {
			adapter = "copilot",
		},
	},
	display = {
		chat = {
			window = {
				layout = "vertical",
				width = 0.35,
			},
			show_settings = true,
		},
		diff = {
			provider = "mini_diff",
		},
	},
})

-- ── Keymaps ───────────────────────────────────────────────────────────
local map = vim.keymap.set

-- Chat
map({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle CodeCompanion Chat" })
map({ "n", "v" }, "<leader>cn", "<cmd>CodeCompanionChat<cr>", { desc = "New CodeCompanion Chat" })
map({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
map("v", "<leader>ce", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add selection to chat" })

-- Inline
map("v", "<leader>ci", ":CodeCompanion ", { desc = "Inline CodeCompanion prompt" })

-- Quick inline prompts (visual selection sent as context)
map("v", "<leader>cr", "<cmd>CodeCompanion Explain this code<cr>", { desc = "Explain selection" })
map("v", "<leader>ct", "<cmd>CodeCompanion Write unit tests for this code<cr>", { desc = "Generate tests" })
map("v", "<leader>cf", "<cmd>CodeCompanion Fix this code<cr>", { desc = "Fix selection" })

-- Expand cc → CodeCompanion in cmd line
vim.cmd.cabbrev("cc", "CodeCompanion")
vim.cmd.cabbrev("ccc", "CodeCompanionChat")
