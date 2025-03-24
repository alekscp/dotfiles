local width = 120

vim.opt.termguicolors = true
vim.opt.number = true                   -- Show line numbers
vim.opt.ignorecase = true
vim.opt.smartcase = true                -- Do not ignore case with capitals
vim.opt.autoindent = true
vim.opt.textwidth = width               -- Maximum width of text
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true              -- Insert indents automatically
vim.opt.spelllang = { "en_us", "fr" }
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.opt.mouse = ""
vim.opt.guicursor = ""

vim.opt.incsearch = true

vim.opt.colorcolumn = tostring(width)

-- Avoid clash with <C-c> binding from SQLComplete
vim.g.omni_sql_no_default_maps = 1

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.encoding= "utf-8"
vim.opt.hidden = true                   -- Enable background buffers
vim.opt.ruler = true                    -- Show the cursor position all the ti
vim.opt.colorcolumn = "120"
vim.opt.clipboard = "unnamed"
vim.opt.updatetime = 50
vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.opt.shell = "/bin/bash" -- Performance boost

vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- automatically rebalance windows on vim resize
vim.api.nvim_command("autocmd VimResized * wincmd =")

vim.api.nvim_command("au CursorHold,CursorHoldI,FocusGained,BufEnter * checktime")
-- -- .sol files support
-- api.nvim_command("autocmd FileType solidity setlocal ai sw=4 sts=2 et")
-- -- Open all folds on file/buffer open
-- api.nvim_command("autocmd BufReadPost,FileReadPost * normal zi")
