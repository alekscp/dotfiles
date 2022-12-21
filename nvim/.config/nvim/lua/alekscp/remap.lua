vim.keymap.set("n", "<space>h", vim.cmd.nohlsearch)

vim.keymap.set("n", "0", "^")

-- Copilot
vim.keymap.set("i", "‘", "<Plug>(copilot-next)")
vim.keymap.set("i", "“", "<Plug>(copilot-previous)")

vim.keymap.set("n", "<C-s>", vim.cmd.w)
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>")

-- Move text up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without losing current paste buffer
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
