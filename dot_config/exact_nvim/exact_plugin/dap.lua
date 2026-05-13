vim.pack.add({
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mfussenegger/nvim-dap",
	{ src = "https://github.com/igorlfs/nvim-dap-view", version = vim.version.range("^1") },
	"https://github.com/jay-babu/mason-nvim-dap.nvim",
	"https://github.com/mfussenegger/nvim-dap-python",
})

-- ── Mason ─────────────────────────────────────────────────────────────
require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-nvim-dap").setup({
	ensure_installed = { "python", "codelldb" },
	automatic_installation = true,
	handlers = {
		function(config)
			require("mason-nvim-dap").default_setup(config)
		end,
		python = function() end, -- handled by nvim-dap-python below
	},
})

-- ── DAP ───────────────────────────────────────────────────────────────
local dap = require("dap")

-- Python (debugpy via Mason)
require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

-- Rust (codelldb via Mason)
local codelldb = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"

dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = codelldb,
		args = { "--port", "${port}" },
	},
}

dap.configurations.rust = {
	{
		name = "Launch binary",
		type = "codelldb",
		request = "launch",
		program = function()
			local cargo = vim.fn.system("cargo metadata --no-deps --format-version 1 2>/dev/null")
			local ok, meta = pcall(vim.json.decode, cargo)
			if ok and meta and meta.packages and meta.packages[1] then
				return vim.fn.getcwd() .. "/target/debug/" .. meta.packages[1].name
			end
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
	{
		name = "Launch binary (with args)",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
		end,
		args = function()
			return vim.split(vim.fn.input("Arguments: "), " ")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}

-- ── Breakpoint highlights ─────────────────────────────────────────────
-- Defined inside ColorScheme autocmd so they survive colorscheme reloads
local function set_dap_highlights()
	vim.api.nvim_set_hl(0, "DapBreakpointLine", { bg = "#241a1e" })  -- faint red
	vim.api.nvim_set_hl(0, "DapBreakpointCondLine", { bg = "#221a24" }) -- faint purple
	vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#1a201b" })     -- faint green
	vim.api.nvim_set_hl(0, "DapLogLine", { bg = "#181d26" })         -- faint blue
end

vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = set_dap_highlights })
set_dap_highlights()

-- Single sign_define block — no text, only line highlights
vim.fn.sign_define("DapBreakpoint", { text = "", linehl = "DapBreakpointLine", texthl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", linehl = "DapBreakpointCondLine", texthl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", linehl = "DapBreakpointLine", texthl = "" })
vim.fn.sign_define("DapLogPoint", { text = "", linehl = "DapLogLine", texthl = "" })
vim.fn.sign_define("DapStopped", { text = "", linehl = "DapStoppedLine", texthl = "" })

-- ── nvim-dap-view ─────────────────────────────────────────────────────
require("dap-view").setup({
	winbar = {
		show = true,
		sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
		default_section = "scopes",
		show_keymap_hints = true,
		separators = nil,
		base_sections = {
			breakpoints = { label = "Breakpoints", keymap = "B" },
			scopes      = { label = "Scopes", keymap = "S" },
			exceptions  = { label = "Exceptions", keymap = "E" },
			watches     = { label = "Watches", keymap = "W" },
			threads     = { label = "Threads", keymap = "T" },
			repl        = { label = "REPL", keymap = "R" },
			sessions    = { label = "Sessions", keymap = "K" },
			console     = { label = "Console", keymap = "C" },
		},
		custom_sections = {},
		controls = {
			enabled = false,
			position = "right",
			buttons = {
				"play", "step_into", "step_over", "step_out",
				"step_back", "terminate",
			},
			custom_buttons = {},
		},
	},
	windows = {
		size = 0.25,
		position = "below",
		terminal = {
			size = 0.5,
			position = "below",
			hide = {},
		},
	},
	icons = {
		collapsed  = "󰅂 ",
		disabled   = "",
		disconnect = "",
		enabled    = "",
		expanded   = "󰅀 ",
		filter     = "󰈲",
		negate     = " ",
		pause      = "",
		play       = "",
		run_last   = "",
		step_back  = "",
		step_into  = "",
		step_out   = "",
		step_over  = "",
		terminate  = "",
	},
	help = { border = nil },
	render = {
		sort_variables = nil,
		threads = {
			format = function(name, lnum, path)
				return {
					{ part = name, separator = " " },
					{ part = path, hl = "FileName",  separator = ":" },
					{ part = lnum, hl = "LineNumber" },
				}
			end,
			align = true,
		},
	},
	virtual_text = {
		enabled = true,
		format = function(variable, _, _)
			return " " .. variable.value
		end,
	},
	switchbuf = "usetab,uselast",
	auto_toggle = true, -- handles open/close automatically, no manual listeners needed
	follow_tab = false,
})

-- ── Keymaps ───────────────────────────────────────────────────────────
local dap_view = require("dap-view")

vim.keymap.set({ "n", "v" }, "<F1>", dap_view.toggle, { desc = "Debug: Toggle view" })
vim.keymap.set({ "n", "v" }, "<F2>", dap.toggle_breakpoint, { desc = "Debug: Toggle breakpoint" })
vim.keymap.set({ "n", "v" }, "<F3>", function() require("dap.ui.widgets").hover() end, { desc = "Debug: Hover info" })
vim.keymap.set({ "n", "v" }, "<F4>", dap.step_out, { desc = "Debug: Step out" })
vim.keymap.set({ "n", "v" }, "<F5>", dap.step_into, { desc = "Debug: Step into" })
vim.keymap.set({ "n", "v" }, "<F6>", dap.step_over, { desc = "Debug: Step over" })
vim.keymap.set({ "n", "v" }, "<F7>", dap.continue, { desc = "Debug: Continue" })
vim.keymap.set({ "n", "v" }, "<F8>", dap.run_to_cursor, { desc = "Debug: Run to cursor" })
vim.keymap.set({ "n", "v" }, "<F9>", function() require("dap-view").add_expr() end, { desc = "Debug: Watch expression" })
vim.keymap.set({ "n", "v" }, "<F10>", dap.terminate, { desc = "Debug: Terminate" })
vim.keymap.set({ "n", "v" }, "<F11>", function() require("dap-view").virtual_text_toggle() end,
	{ desc = "Debug: Toggle virtual text" })

-- Close dap-float windows with 'q'
vim.api.nvim_create_autocmd("FileType", {
	pattern = "dap-float",
	callback = function(ev)
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
	end,
})
