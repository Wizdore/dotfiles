vim.pack.add({
	"https://github.com/zbirenbaum/copilot.lua",
})

require("copilot").setup({
	suggestion = {
		enabled = true,
		auto_trigger = true,
		hide_during_completion = true,
		debounce = 75,
		keymap = {
			accept = "<Tab>",
			accept_word = "<M-w>",
			accept_line = "<M-l>",
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
	panel = {
		enabled = true,
		auto_refresh = false,
		keymap = {
			open = "<M-CR>",
			accept = "<CR>",
			jump_next = "]]",
			jump_prev = "[[",
			refresh = "gr",
		},
		layout = { position = "right", ratio = 0.30 },
	},
	filetypes = {
		yaml = false,
		markdown = false,
		help = false,
		gitcommit = false,
		gitrebase = false,
		sh = function()
			if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env") then
				return false
			end
			return true
		end,
	},
	server_opts_overrides = {
		settings = {
			advanced = { inlineSuggestCount = 3 },
		},
	},
})
