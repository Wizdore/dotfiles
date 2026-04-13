vim.pack.add({
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mfussenegger/nvim-dap",
	{ src = "https://github.com/igorlfs/nvim-dap-view", version = vim.version.range("^1") },
	"https://github.com/jay-babu/mason-nvim-dap.nvim",
	"https://github.com/mfussenegger/nvim-dap-python",
	"https://github.com/theHamsta/nvim-dap-virtual-text",
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

require("nvim-dap-virtual-text").setup({
	enabled = true,
	enabled_commands = true,
	all_frames = false,
	virt_text_pos = "eol",
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
	windows = {
		terminal = {
			hide = { "debugpy", "codelldb" },
		},
	},
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
vim.keymap.set("n", "<F4>", dap.step_over, { desc = "Debug: Step over" })
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
vim.keymap.set("n", "<F6>", dap_view.toggle, { desc = "Debug: Toggle view" })
vim.keymap.set("n", "<F7>", dap.step_into, { desc = "Debug: Step into" })
vim.keymap.set("n", "<F8>", dap.toggle_breakpoint, { desc = "Debug: Toggle breakpoint" })
vim.keymap.set("n", "<F9>", dap.step_out, { desc = "Debug: Step out" })
vim.keymap.set("n", "<F10>", dap.run_to_cursor, { desc = "Debug: Run to cursor" })
vim.keymap.set("n", "<F1>", dap.terminate, { desc = "Debug: Terminate" })

-- Conditional breakpoint (Shift + Toggle Breakpoint key)
vim.keymap.set("n", "<F20>", function() -- Shift+F8
	dap.set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "Debug: Conditional breakpoint" })
