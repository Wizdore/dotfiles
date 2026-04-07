-- Global/Leader Settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Indentation (4-char tabs)
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = false

-- Visuals
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.cursorline = false
vim.o.showmode = false
vim.o.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
vim.opt.foldcolumn = "0"
vim.opt.foldenable = true
vim.opt.fillchars = { eob = " " }
vim.opt.cursorline = false
vim.o.winborder = "single"
vim.opt.cmdheight = 0

-- Behavior & Search
vim.o.mouse = "a"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.undofile = true
vim.o.breakindent = true
vim.o.confirm = true
vim.o.inccommand = "split"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.scrolloff = 5
vim.o.updatetime = 200
vim.o.timeoutlen = 300
-- Disable timeout for mappings (Leader will wait forever)
vim.o.timeout = false
vim.o.ttimeout = true
vim.o.ttimeoutlen = 50
-- scroll 10 lines only
vim.o.scroll = 10
-- Clipboard (Async for performance)
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", on_macro = true, timeout = 300 })
	end,
})

-- Keep the scroll size consistent to 10 even after resize
vim.api.nvim_create_autocmd("VimResized", {
	callback = function()
		vim.o.scroll = 10
	end,
})
