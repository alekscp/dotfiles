----------------------------- HELPERS ------------------------------------------
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local api = vim.api

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

----------------------------- PLUGINS ------------------------------------------
require("packer").startup(function()
  -- Packer can manage itself
  if g.vscode then
    -- VSCode specific plugins
  else
    use "wbthomason/packer.nvim"

    use {
      "kyazdani42/nvim-tree.lua",
      requires = "kyazdani42/nvim-web-devicons",
      config = function() require"nvim-tree".setup {} end
    }
    use "morhetz/gruvbox"

    use "christoomey/vim-tmux-navigator"

    use {
      "nvim-telescope/telescope.nvim",
      requires = { {"nvim-lua/plenary.nvim"} }
    }
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }

    -- Post-install/update hook with neovim command
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

    -- Pairs/Tags closing
    use "windwp/nvim-autopairs"
    use "windwp/nvim-ts-autotag"

    use "neovim/nvim-lspconfig"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/nvim-cmp"
    use "L3MON4D3/LuaSnip"

    -- Snippets
    use "saadparwaiz1/cmp_luasnip"
    use "rafamadriz/friendly-snippets"

    use "lukas-reineke/indent-blankline.nvim"

    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end
    }

    use {
      "lewis6991/gitsigns.nvim",
      requires = {
        "nvim-lua/plenary.nvim"
      },
      tag = 'release' -- To use the latest release
    }

    use "tomlion/vim-solidity"

    use "f3fora/cmp-spell"

    use "kdheepak/lazygit.nvim"
  end
end)

----------------------------- PLUGINS SETUP ------------------------------------
-- telescope
require("telescope").setup {
  pickers = {
    buffers = {
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        }
      }
    }
  }
}
map("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>")
map("n", "<space>b", "<cmd>lua require('telescope.builtin').buffers()<cr>")
map("n", "<space>d", "<cmd>lua require('telescope.builtin').diagnostics()<cr>")
map("n", "<space>m", "<cmd>lua require('telescope.builtin').marks()<cr>")
map("n", "<leader>k", "<cmd>lua require('telescope.builtin').grep_string{}<cr>")

-- telescope-fzf-native
local ts = require("telescope")
ts.load_extension("fzf")

-- nvim-tree
require"nvim-tree".setup {
  update_cwd = false,
}
map("n", "<C-n>", ":NvimTreeToggle<CR>")
map("n", "<leader>r", ":NvimTreeRefresh<CR>")
map("n", "<leader>n", ":NvimTreeFindFile<CR>")

-- nvim-treesitter
require"nvim-treesitter.configs".setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true,
    disable = { "yaml" },
  },
}

-- nvim-autopairs
require("nvim-autopairs").setup {
  enable_check_bracket_line = false,
  ignored_next_char = "[%w%.]" -- will ignore alphanumeric and `.` symbol
}

-- nvim-cmp
local luasnip = require 'luasnip'
local cmp = require"cmp"
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "spell" },
    { name = "path" }
  }, {
    { name = "buffer" },
  })
})
cmp.setup.cmdline("/", {
  sources = {
    { name = 'buffer' }
  }
})
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- LuaSnip
require("luasnip.loaders.from_vscode").load()

-- indent-blankline.nvim
require("indent_blankline").setup {
  char = "|",
  buftype_exclude = { "terminal" }
}

-- gitsigns.nvim
require("gitsigns").setup()

-- nvim-ts-autotag
require"nvim-treesitter.configs".setup {
  autotag = {
    enable = true,
  }
}


-- lazygit
map("n", "<leader>g", ":LazyGit<cr>", {silent=true})

----------------------------- LSP ----------------------------------------------
local nvim_lsp = require("lspconfig")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  buf_set_keymap("n", "<space>fm", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Use a loop to conveniently call "setup" on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
  "pyright",
  "rust_analyzer",
  "tsserver",
  "dockerls",
  "dotls",
  "eslint",
  "jsonls",
  "solidity_ls",
  "sumneko_lua",
  "yamlls",
  "cssls",
}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

----------------------------- OPTIONS ------------------------------------------
local width = 120
opt.termguicolors = true
opt.number = true                   -- Show line numbers
opt.ignorecase = true
opt.smartcase = true                -- Do not ignore case with capitals
opt.autoindent = true
opt.textwidth = width               -- Maximum width of text
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true              -- Insert indents automatically
opt.spelllang = { "en_us", "fr" }
g.gruvbox_contrast_dark = "soft"
cmd[[colorscheme gruvbox]]
cmd "set encoding=utf-8"
cmd "set hidden"
cmd "set ruler"
cmd "set colorcolumn=120"
cmd "set nowritebackup"
cmd "set shortmess+=c"
cmd "set clipboard=unnamed"
cmd "set updatetime=50"
cmd "set noswapfile"
cmd "set nobackup"
cmd "set scrolloff=8"
cmd "set termguicolors"
cmd "au CursorHold,CursorHoldI,FocusGained,BufEnter * checktime"
-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
-- automatically rebalance windows on vim resize
api.nvim_command("autocmd VimResized * wincmd =")
-- .sol files support
api.nvim_command("autocmd FileType solidity setlocal ai sw=4 sts=2 et")

----------------------------- MAPPINGS -----------------------------------------
map("n", "<space>h", ":nohlsearch<CR>") -- turn off highlighting from a search
map("n", "0", "^") -- Easy access to the start of the line

-- Write the file
map("n", "<C-S>", ":w<cr>")
map("i", "<C-S>", "<esc>:w<cr>")
map("i", "<C-c>", "<Esc>")

-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv")
map("x", "K", ":move '<-2<CR>gv-gv")
----------------------------- COMMANDS -----------------------------------------
