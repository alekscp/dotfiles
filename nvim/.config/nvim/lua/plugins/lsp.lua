return {
  "VonHeikemen/lsp-zero.nvim",
  branch = 'v3.x',
  dependencies = {
    -- LSP Support
    {"neovim/nvim-lspconfig"},
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},

    -- Autocompletion
    {"hrsh7th/nvim-cmp"},
    {"hrsh7th/cmp-buffer"},
    {"hrsh7th/cmp-path"},
    {"saadparwaiz1/cmp_luasnip"},
    {"hrsh7th/cmp-nvim-lsp"},
    {"hrsh7th/cmp-nvim-lua"},

    -- Snippets
    {"L3MON4D3/LuaSnip"},
    {"rafamadriz/friendly-snippets"},
  },
  config = function()
    local lsp_zero = require('lsp-zero')

    lsp_zero.on_attach(function(_, bufnr)
      local opts = {buffer = bufnr, remap = false}

      vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
      vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
      vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
      vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
      vim.keymap.set("n", "<space>e", function() vim.diagnostic.open_float() end, opts)
      vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
      vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
      vim.keymap.set("n", "<space>ca", function() vim.lsp.buf.code_action() end, opts)
      vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
      vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end)

    require('mason').setup({})
    require('mason-lspconfig').setup({
      ensure_installed = {'ts_ls', 'rust_analyzer'},
      handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
          local lua_opts = lsp_zero.nvim_lua_ls()
          require('lspconfig').lua_ls.setup(lua_opts)
        end,
        ansiblels = function()
          local lspconfig = require('lspconfig')
          lspconfig.ansiblels.setup({
            filetypes = {'yaml', 'ansible'},
            root_dir = lspconfig.util.root_pattern('ansible.cfg', 'inventories', 'roles', 'playbooks'),
          })
        end,
        ['jinja_lsp'] = function()
          local lspconfig = require('lspconfig')
          lspconfig.jinja_lsp.setup({
            filetypes = {'jinja', 'jinja2', 'j2'},
          })
        end,
        yamlls = function()
          local lspconfig = require('lspconfig')
          lspconfig.yamlls.setup({
            filetypes = {'yaml', 'yml'},
            format = {
              enable = true,
            }
          })
        end
      }
    })

    local cmp = require('cmp')
    local cmp_select = {behavior = cmp.SelectBehavior.Select}

    cmp.setup({
      sources = {
        {name = 'path'},
        {name = 'nvim_lsp'},
        {name = 'nvim_lua'},
      },
      formatting = lsp_zero.cmp_format(),
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        -- disable completion with tab
        -- this helps with copilot setup
        ["<Tab>"] = nil,
        ["<S-Tab>"] = nil
      }),
    })

    lsp_zero.setup()

    vim.filetype.add({
      extension = {
        j2 = "jinja",
      },
    })
  end,
}
