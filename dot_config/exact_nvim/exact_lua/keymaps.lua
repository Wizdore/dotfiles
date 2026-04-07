local function map(mode, keys, func, desc)
	vim.keymap.set(mode, keys, func, { desc = desc, noremap = true, silent = true })
end

-- General
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")
map("n", "<leader>q", vim.diagnostic.setloclist, "Open diagnostic quickfix")
map("n", "x", '"_x', "Delete char without copying")

-- Files
map("n", "<C-s>", function()
	vim.cmd("w")
end, "Save file")
map("i", "<C-s>", function()
	vim.cmd("w")
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "n", true)
end, "Save file")
map("n", "U", "<C-r>", "redo")

-- Navigation (Windows)
map("n", "<C-h>", "<C-w><C-h>", "Move to left window")
map("n", "<C-l>", "<C-w><C-l>", "Move to right window")
map("n", "<C-j>", "<C-w><C-j>", "Move to lower window")
map("n", "<C-k>", "<C-w><C-k>", "Move to upper window")

-- Terminal
map("t", "<Esc><Esc>", [[<C-\><C-n>]], "Exit terminal mode")

-- Lsp
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Show signature" })
-- Add borders to the hover and signature windows globally
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, { border = "rounded" })
