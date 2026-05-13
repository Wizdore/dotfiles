vim.pack.add({ "https://github.com/lewis6991/satellite.nvim" })


require('satellite').setup {
	current_only = false,
	winblend = 50,
	zindex = 40,
	excluded_filetypes = {},
	width = 3,
	handlers = {
		cursor = {
			enable = true,
			symbols = { '⎺', '⎻', '⎼', '⎽' }
		},
		search = {
			enable = true,
		},
		diagnostic = {
			enable = true,
			signs = { '-', '=', '≡' },
			min_severity = vim.diagnostic.severity.INFO,
		},
		gitsigns = {
			enable = true,
			signs = { -- can only be a single character (multibyte is okay)
				add = "│",
				change = "│",
				delete = "-",
			},
		},
		marks = {
			enable = true,
			show_builtins = false, -- shows the builtin marks like [ ] < >
			key = 'm'
		},
		quickfix = {
			signs = { '-', '=', '≡' },
		}
	},
}
