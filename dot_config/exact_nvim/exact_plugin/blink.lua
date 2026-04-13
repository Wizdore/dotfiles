vim.pack.add({
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/xzbdmw/colorful-menu.nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("^1"),
	},
})

require("blink.cmp").setup({
	keymap = { preset = "enter" },
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		accept = { auto_brackets = { enabled = true } },
		keyword = { range = "full" },
		documentation = { auto_show = true, auto_show_delay_ms = 500 },
		ghost_text = { enabled = false },
		menu = {
			draw = {
				-- We don't need label_description now because label and label_description are already
				-- combined together in label by colorful-menu.nvim.
				columns = { { "kind_icon" }, { "label", gap = 1 } },
				components = {
					label = {
						text = function(ctx)
							return require("colorful-menu").blink_components_text(ctx)
						end,
						highlight = function(ctx)
							return require("colorful-menu").blink_components_highlight(ctx)
						end,
					},
				},
			},
		},
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		per_filetype = {
			codecompanion = { "codecompanion" },
		},
		providers = {
			codecompanion = {
				name = "CodeCompanion",
				module = "codecompanion.providers.completion.blink",
				enabled = true,
			},
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
	signature = { enabled = true },
})
