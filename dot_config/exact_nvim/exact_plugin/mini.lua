vim.pack.add({
	"https://github.com/echasnovski/mini.ai",
	"https://github.com/echasnovski/mini.surround",
	"https://github.com/echasnovski/mini.pairs",
	"https://github.com/echasnovski/mini.icons",
	"https://github.com/echasnovski/mini.diff",
})

require("mini.ai").setup()
require("mini.surround").setup()
require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()
require("mini.diff").setup()
require("mini.pairs").setup()
