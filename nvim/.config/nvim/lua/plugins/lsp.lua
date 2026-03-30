return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},

    {"hrsh7th/nvim-cmp"},
    {"hrsh7th/cmp-buffer"},
    {"hrsh7th/cmp-path"},
    {"saadparwaiz1/cmp_luasnip"},
    {"hrsh7th/cmp-nvim-lsp"},
    {"hrsh7th/cmp-nvim-lua"},

    {"L3MON4D3/LuaSnip"},
    {"rafamadriz/friendly-snippets"},
  },
  config = function()
    local cmp = require('cmp')
    local cmp_select = {behavior = cmp.SelectBehavior.Select}
    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('alekscp-lsp-attach', {clear = true}),
      callback = function(event)
        local opts = {buffer = event.buf, remap = false}

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
      end,
    })

    vim.filetype.add({
      extension = {
        j2 = "jinja",
        jinja = "jinja",
        jinja2 = "jinja",
      },
    })

    vim.lsp.config('*', {
      capabilities = lsp_capabilities,
    })

    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          telemetry = {enable = false},
          runtime = {
            version = 'LuaJIT',
            path = runtime_path,
          },
          diagnostics = {
            globals = {'vim'},
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.fn.expand('$VIMRUNTIME/lua'),
              vim.fn.stdpath('config') .. '/lua',
            },
          },
        },
      },
    })

    vim.lsp.config('ansiblels', {
      filetypes = {'yaml', 'yaml.ansible', 'ansible'},
      root_markers = {
        {'ansible.cfg', 'inventories', 'roles', 'playbooks'},
      },
    })

    vim.lsp.config('jinja_lsp', {
      filetypes = {'jinja', 'jinja2', 'j2'},
    })

    vim.lsp.config('yamlls', {
      settings = {
        yaml = {
          format = {enable = true},
        },
      },
    })

    require('mason').setup({})
    require('mason-lspconfig').setup({
      ensure_installed = {'lua_ls', 'ts_ls', 'rust_analyzer'},
      automatic_enable = false,
    })

    vim.lsp.enable({
      'lua_ls',
      'rust_analyzer',
      'ts_ls',
      'ansiblels',
      'jinja_lsp',
      'yamlls',
    })

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      sources = {
        {name = 'path'},
        {name = 'nvim_lsp'},
        {name = 'nvim_lua'},
      },
      formatting = {
        fields = {'abbr', 'menu', 'kind'},
        format = function(entry, item)
          if entry.source.name == 'nvim_lsp' then
            item.menu = '[LSP]'
          elseif entry.source.name == 'nvim_lua' then
            item.menu = '[nvim]'
          else
            item.menu = string.format('[%s]', entry.source.name)
          end

          return item
        end,
      },
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
  end,
}
