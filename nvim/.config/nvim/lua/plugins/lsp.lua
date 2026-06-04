return function()
  local float_opts = { border = 'rounded' }

  vim.diagnostic.config({
    severity_sort = true,
    float = {
      border = 'rounded',
      source = 'if_many',
    },
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('alekscp-lsp-attach', { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      local opts = { buffer = event.buf, remap = false }

      if client and client:supports_method('textDocument/completion') then
        local complete = vim.api.nvim_get_option_value('complete', { buf = event.buf })
        local complete_items = vim.split(complete, ',', { plain = true })

        if not vim.tbl_contains(complete_items, 'o') then
          table.insert(complete_items, 'o')
          vim.api.nvim_set_option_value('complete', table.concat(complete_items, ','), { buf = event.buf })
        end

        vim.api.nvim_set_option_value('autocomplete', true, { buf = event.buf })
        vim.lsp.completion.enable(true, client.id, event.buf)
      end

      vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
      vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
      vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover(float_opts) end, opts)
      vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
      vim.keymap.set("n", "<space>e", function() vim.diagnostic.open_float(float_opts) end, opts)
      vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
      vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
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
end
