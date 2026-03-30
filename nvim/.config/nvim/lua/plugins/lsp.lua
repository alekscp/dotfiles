return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {"williamboman/mason.nvim"},
  },
  config = function()
    local float_opts = {border = 'rounded'}

    local all_printable_chars = {}
    for char_code = 32, 126 do
      table.insert(all_printable_chars, string.char(char_code))
    end

    local function completion_select(key)
      return function()
        if vim.fn.pumvisible() == 1 then
          return key
        end

        return '<C-x><C-o>' .. key
      end
    end

    local function completion_page(key, fallback)
      return function()
        if vim.fn.pumvisible() == 1 then
          return key
        end

        return fallback
      end
    end

    vim.diagnostic.config({
      severity_sort = true,
      float = {
        border = 'rounded',
        source = 'if_many',
      },
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('alekscp-lsp-attach', {clear = true}),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local opts = {buffer = event.buf, remap = false}
        local expr_opts = {buffer = event.buf, expr = true, remap = false, silent = true}

        if client and client:supports_method('textDocument/completion') then
          client.server_capabilities.completionProvider = client.server_capabilities.completionProvider or {}
          client.server_capabilities.completionProvider.triggerCharacters = all_printable_chars

          vim.lsp.completion.enable(true, client.id, event.buf, {autotrigger = true})

          vim.keymap.set('i', '<C-Space>', function()
            vim.lsp.completion.get()
          end, opts)
          vim.keymap.set('i', '<C-@>', function()
            vim.lsp.completion.get()
          end, opts)
          vim.keymap.set('i', '<C-p>', completion_select('<C-p>'), expr_opts)
          vim.keymap.set('i', '<C-n>', completion_select('<C-n>'), expr_opts)
          vim.keymap.set('i', '<C-u>', completion_page('<PageUp>', '<C-u>'), expr_opts)
          vim.keymap.set('i', '<C-d>', completion_page('<PageDown>', '<C-d>'), expr_opts)
        end

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover(float_opts) end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<space>e", function() vim.diagnostic.open_float(float_opts) end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.jump({count = 1, float = true}) end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.jump({count = -1, float = true}) end, opts)
        vim.keymap.set("n", "<space>ca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help(float_opts) end, opts)
      end,
    })

    vim.filetype.add({
      extension = {
        j2 = "jinja",
        jinja = "jinja",
        jinja2 = "jinja",
      },
    })

    require('mason').setup({})

    vim.lsp.enable({
      'lua_ls',
      'rust_analyzer',
      'ts_ls',
      'ansiblels',
      'jinja_lsp',
      'yamlls',
    })
  end,
}
