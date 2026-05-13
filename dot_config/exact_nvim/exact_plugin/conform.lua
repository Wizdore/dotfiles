vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
	formatters_by_ft = {
		lua             = { "stylua" },
		rust            = { "rustfmt" },
		typescript      = { "biome" },
		javascript      = { "biome" },
		typescriptreact = { "biome" },
		javascriptreact = { "biome" },
		json            = { "biome" },
		python          = { "ruff_format" },
	},

	formatters = {
		rustfmt = {
			args = { "--emit=stdout", "--edition=2024" },
		},
	},

	format_on_save = {
		timeout_ms = 2000,
		lsp_fallback = true, -- fall back to LSP formatter if no conform formatter matches
	},
})

-- Optional: manual format keymap
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = true, lsp_fallback = true })
end)
