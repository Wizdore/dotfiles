vim.pack.add({
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mfussenegger/nvim-dap",
	{ src = "https://github.com/igorlfs/nvim-dap-view", version = vim.version.range("^1") },
	"https://github.com/jay-babu/mason-nvim-dap.nvim",
	"https://github.com/mfussenegger/nvim-dap-python",
})

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

local dap = require("dap")
local dap_view = require("dap-view")

-- ── Mason: auto-install debuggers ─────────────────────────────────────
require("mason-nvim-dap").setup({
	ensure_installed = { "python", "codelldb" },
	automatic_installation = true,
	handlers = {
		-- default handler covers everything not explicitly listed
		function(config)
			require("mason-nvim-dap").default_setup(config)
		end,
		-- skip python — handled by nvim-dap-python below
		python = function() end,
	},
})

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "", cursorhl = "" })

-- ── Python (debugpy) ──────────────────────────────────────────────────
-- nvim-dap-python handles adapter + config automatically
require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

-- ── Rust (codelldb via Mason) ─────────────────────────────────────────
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
			-- auto-find the debug binary from cargo metadata
			local cargo = vim.fn.system("cargo metadata --no-deps --format-version 1 2>/dev/null")
			local ok, meta = pcall(vim.json.decode, cargo)
			if ok and meta and meta.packages and meta.packages[1] then
				local name = meta.packages[1].name
				return vim.fn.getcwd() .. "/target/debug/" .. name
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
			local args = vim.fn.input("Arguments: ")
			return vim.split(args, " ")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}

-- ── nvim-dap-view ─────────────────────────────────────────────────────
dap_view.setup({
	winbar = {
		show = true,
		-- You can add a "console" section to merge the terminal with the other views
		sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
		-- Must be one of the sections declared above
		default_section = "watches",
		-- Append hints with keymaps within the labels
		show_keymap_hints = true,
		-- List of up to 2 strings, defining left and right separators
		separators = nil,
		-- Configure each section individually
		base_sections = {
			-- Labels can be set dynamically with functions
			-- Each function receives the window's width and the current section as arguments
			breakpoints = { label = "Breakpoints", keymap = "B" },
			scopes = { label = "Scopes", keymap = "S" },
			exceptions = { label = "Exceptions", keymap = "E" },
			watches = { label = "Watches", keymap = "W" },
			threads = { label = "Threads", keymap = "T" },
			repl = { label = "REPL", keymap = "R" },
			sessions = { label = "Sessions", keymap = "K" },
			console = { label = "Console", keymap = "C" },
		},
		-- Add your own sections
		custom_sections = {},
		controls = {
			enabled = false,
			position = "right",
			buttons = {
				"play",
				"step_into",
				"step_over",
				"step_out",
				"step_back",
				"run_last",
				"terminate",
				"disconnect",
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
			-- List of debug adapters for which the terminal should be ALWAYS hidden
			hide = {},
		},
	},
	icons = {
		collapsed = "󰅂 ",
		disabled = "",
		disconnect = "",
		enabled = "",
		expanded = "󰅀 ",
		filter = "󰈲",
		negate = " ",
		pause = "",
		play = "",
		run_last = "",
		step_back = "",
		step_into = "",
		step_out = "",
		step_over = "",
		terminate = "",
	},
	help = {
		border = nil,
	},
	render = {
		-- Optionally a function that takes two `dap.Variable`'s as arguments
		-- and is forwarded to a `table.sort` when rendering variables in the scopes view
		sort_variables = nil,
		-- Full control of how frames are rendered, see the "Custom Formatting" page
		threads = {
			-- Choose which items to display and how
			format = function(name, lnum, path)
				return {
					{ part = name, separator = " " },
					{ part = path, hl = "FileName",  separator = ":" },
					{ part = lnum, hl = "LineNumber" },
				}
			end,
			-- Align columns
			align = true,
		},
		-- Full control of how breakpoints are rendered, see the "Custom Formatting" page
		breakpoints = {
			-- Choose which items to display and how
			format = function(line, lnum, path)
				return {
					{ part = path, hl = "FileName" },
					{ part = lnum, hl = "LineNumber" },
					{ part = line, hl = true },
				}
			end,
			-- Align columns
			align = true,
		},
	},
	-- Requires neovim 0.12+
	virtual_text = {
		-- Control with `DapViewVirtualTextToggle`
		enabled = true,
		-- Supported options include "inline", "eol", and "eol_right_align"
		-- position = "inline",
		format = function(variable, _, _)
			return " " .. variable.value
		end,
		-- Prepend the variable name (when using eol positioning)
		-- prefix = function(position, node, bufnr)
		-- 	if position == "eol" or position == "eol_right_align" then
		-- 		local name = vim.treesitter.get_node_text(node, bufnr)
		--
		-- 		return name .. " ="
		-- 	end
		-- end,
		-- Add commas between variables (when using eol positioning)
		-- suffix = function(position, _, _, var_index, num_var_line)
		-- 	if position == "eol" or position == "eol_right_align" then
		-- 		return var_index == num_var_line and "" or ","
		-- 	end
		-- end,
	},
	-- Controls how to jump when selecting a breakpoint or navigating the stack
	-- Comma separated list, like the built-in 'switchbuf'. See :help 'switchbuf'
	-- Only a subset of the options is available: newtab, useopen, usetab and uselast
	-- Can also be a function that takes the current winnr and the destination bufnr
	-- If a function, should return the winnr of the destination window
	switchbuf = "usetab,uselast",
	-- Auto open when a session is started and auto close when all sessions finish
	-- Alternatively, can be a string:
	-- - "keep_terminal": as above, but keeps the terminal when the session finishes
	-- - "open_term": open the terminal when starting a new session, nothing else
	auto_toggle = true,
	-- Reopen dapview when switching to a different tab
	-- Can also be a function to dynamically choose when to follow, by returning a boolean
	-- If a function, receives the name of the adapter for the current session as an argument
	follow_tab = false,
})

-- auto open when session starts, auto close when it ends
dap.listeners.after.event_initialized["dap_view"] = function()
	dap_view.open()
end
dap.listeners.before.event_terminated["dap_view"] = function()
	dap_view.close()
end
dap.listeners.before.event_exited["dap_view"] = function()
	dap_view.close()
end

-- Optimized for Miryoku Fun Layer Home/Top rows
vim.keymap.set("n", "<F1>", dap_view.toggle, { desc = "Debug: Toggle view" })
vim.keymap.set("n", "<F2>", dap.toggle_breakpoint, { desc = "Debug: Toggle breakpoint" })
-- vim.keymap.set("n", "<F3>", dap.set_breakpoint(vim.fn.input("Condition: ")), { desc = "Debug: Conditional breakpoint" })
vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Debug: Step out" })
vim.keymap.set("n", "<F5>", dap.step_into, { desc = "Debug: Step into" })
vim.keymap.set("n", "<F6>", dap.step_over, { desc = "Debug: Step over" })
vim.keymap.set("n", "<F7>", dap.continue, { desc = "Debug: Continue" })
vim.keymap.set("n", "<F8>", dap.run_to_cursor, { desc = "Debug: Run to cursor" })
