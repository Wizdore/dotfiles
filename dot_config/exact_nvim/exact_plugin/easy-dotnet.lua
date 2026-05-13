vim.pack.add({ "https://github.com/GustavEikaas/easy-dotnet.nvim" })

local dotnet = require("easy-dotnet")
vim.keymap.set("n", "<C-p>", function()
	dotnet.run_project()
end)

dotnet.setup({
	managed_terminal = {
		auto_hide = true, -- auto hides terminal if exit code is 0
		auto_hide_delay = 1000, -- delay before auto hiding, 0 = instant
	},
	external_terminal = nil,
	lsp = {
		enabled = true,                -- Enable builtin roslyn lsp
		set_fold_expr = false,
		preload_roslyn = true,         -- Start loading roslyn before any buffer is opened
		roslynator_enabled = true,     -- Automatically enable roslynator analyzer
		easy_dotnet_analyzer_enabled = true, -- Enable roslyn analyzer from easy-dotnet-server
		auto_refresh_codelens = true,
		analyzer_assemblies = {},      -- Any additional roslyn analyzers you might use like SonarAnalyzer.CSharp
		config = {},
	},
	debugger = {
		-- Path to custom coreclr DAP adapter
		-- easy-dotnet-server falls back to its own netcoredbg binary if bin_path is nil
		bin_path = nil,
		console = "integratedTerminal", -- Controls where the target app runs: "integratedTerminal" (Neovim buffer) or "externalTerminal" (OS window)
		apply_value_converters = true,
		auto_register_dap = true,
		mappings = {
			open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
		},
	},
	---@type TestRunnerOptions
	test_runner = {
		auto_start_testrunner = true,
		hide_legend = false,
		---@type "split" | "vsplit" | "float" | "buf"
		viewmode = "float",
		---@type number|nil
		vsplit_width = nil,
		---@type string|nil "topleft" | "topright"
		vsplit_pos = nil,
		icons = {
			passed = "",
			skipped = "",
			failed = "",
			success = "",
			reload = "",
			test = "",
			sln = "󰘐",
			project = "󰘐",
			dir = "",
			package = "",
			class = "",
			build_failed = "󰒡",
		},
		mappings = {
			run_test_from_buffer = { lhs = "<leader>tr", desc = "run test from buffer" },
			run_all_tests_from_buffer = { lhs = "<leader>tt", desc = "Run all tests in file" },
			get_build_errors = { lhs = "<leader>te", desc = "get build errors" },
			debug_test_from_buffer = { lhs = "<leader>td", desc = "run test from buffer" },
			cancel = { lhs = "<C-c>", desc = "cancel in-flight operation" },
		}
	},
	new = {
		project = {
			prefix = "sln" -- "sln" | "none"
		}
	},
	csproj_mappings = true,
	fsproj_mappings = true,
	auto_bootstrap_namespace = {
		--block_scoped, file_scoped
		type = "block_scoped",
		enabled = true,
		use_clipboard_json = {
			behavior = "prompt", --'auto' | 'prompt' | 'never',
			register = "+", -- which register to check
		},
	},
	server = {
		---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
		log_level = nil,
	},
	-- choose which picker to use with the plugin
	-- possible values are "telescope" | "fzf" | "snacks" | "basic"
	-- if no picker is specified, the plugin will determine
	-- the available one automatically with this priority:
	--  snacks -> fzf -> telescope ->  basic
	picker = "snacks",
	background_scanning = true,
	notifications = {
		--Set this to false if you have configured lualine to avoid double logging
		handler = function(start_event)
			local spinner = require("easy-dotnet.ui-modules.spinner").new()
			spinner:start_spinner(start_event.job.name)
			---@param finished_event JobEvent
			return function(finished_event)
				spinner:stop_spinner(finished_event.result.msg, finished_event.result.level)
			end
		end,
	},
	diagnostics = {
		default_severity = "error",
		setqflist = false,
	},
	outdated = {
		mappings = {
			upgrade = { lhs = "<leader>pu", desc = "upgrade package under cursor" },
			upgrade_all = { lhs = "<leader>pa", desc = "upgrade all outdated packages" },
		},
	},
})
