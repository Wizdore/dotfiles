vim.pack.add({
	"https://github.com/christoomey/vim-tmux-navigator",
})

local function map(mode, keys, func, desc)
	vim.keymap.set(mode, keys, func, { desc = desc, noremap = true, silent = true })
end

map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", "Move to left window")
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", "Move to right window")
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", "Move to lower window")
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", "Move to upper window")


