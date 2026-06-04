return function()
  local float_opts = { border = 'rounded' }
  local reset_float_scroll = function() end

  local function feed_insert_keys(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
  end

  local function completion_preview_win()
    local info = vim.fn.complete_info({ "preview_winid" })
    local win = info.preview_winid

    if type(win) == "number" and win > 0 and vim.api.nvim_win_is_valid(win) then
      return win
    end
  end

  local function completion_select(key)
    return function()
      if vim.fn.pumvisible() == 1 then
        vim.schedule(function()
          reset_float_scroll()
          feed_insert_keys(key)
          vim.defer_fn(reset_float_scroll, 10)
        end)
        return
      end

      feed_insert_keys('<C-x><C-o>' .. key)
    end
  end

  local function completion_page(key, fallback)
    return function()
      if vim.fn.pumvisible() == 1 then
        vim.schedule(function()
          reset_float_scroll()
          feed_insert_keys(key)
          vim.defer_fn(reset_float_scroll, 10)
        end)
        return
      end

      feed_insert_keys(fallback)
    end
  end

  reset_float_scroll = function()
    local current_win = vim.api.nvim_get_current_win()
    local preview_win = completion_preview_win()

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if win ~= current_win and vim.api.nvim_win_is_valid(win) then
        local config = vim.api.nvim_win_get_config(win)

        if win == preview_win or (config.relative ~= "" and not config.hide) then
          pcall(vim.api.nvim_win_set_cursor, win, { 1, 0 })
          pcall(vim.api.nvim_win_call, win, function()
            vim.fn.winrestview({ topline = 1 })
          end)
        end
      end
    end
  end

  local function scroll_float(amount)
    local current_win = vim.api.nvim_get_current_win()
    local target = completion_preview_win()

    if target then
      local line_count = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(target))
      local height = vim.api.nvim_win_get_height(target)

      if line_count <= height then
        target = nil
      end
    end

    if not target then
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if win ~= current_win and vim.api.nvim_win_is_valid(win) then
          local config = vim.api.nvim_win_get_config(win)

          if config.relative ~= "" and not config.hide then
            local line_count = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(win))
            local height = vim.api.nvim_win_get_height(win)

            if line_count > height then
              target = win
              break
            end
          end
        end
      end
    end

    if not target then
      return
    end

    pcall(vim.api.nvim_win_call, target, function()
      local view = vim.fn.winsaveview()
      local line_count = vim.api.nvim_buf_line_count(0)
      local height = vim.api.nvim_win_get_height(0)
      local max_topline = math.max(1, line_count - height + 1)

      local topline = math.min(max_topline, math.max(1, view.topline + amount))
      pcall(vim.api.nvim_win_set_cursor, 0, { topline, 0 })
      vim.cmd("normal! zt")
    end)
  end

  local function schedule_scroll_float(amount)
    vim.schedule(function()
      scroll_float(amount)
    end)
  end

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
      local completion_opts = { buffer = event.buf, remap = false, silent = true }

      if client and client:supports_method('textDocument/completion') then
        local complete = vim.api.nvim_get_option_value('complete', { buf = event.buf })
        local complete_items = vim.split(complete, ',', { plain = true })

        if not vim.tbl_contains(complete_items, 'o') then
          table.insert(complete_items, 'o')
          vim.api.nvim_set_option_value('complete', table.concat(complete_items, ','), { buf = event.buf })
        end

        vim.api.nvim_set_option_value('autocomplete', true, { buf = event.buf })
        vim.lsp.completion.enable(true, client.id, event.buf)

        vim.keymap.set('i', '<C-p>', completion_select('<C-p>'), completion_opts)
        vim.keymap.set('i', '<C-n>', completion_select('<C-n>'), completion_opts)
        vim.keymap.set('i', '<C-u>', completion_page('<PageUp>', '<C-u>'), completion_opts)
        vim.keymap.set('i', '<C-d>', completion_page('<PageDown>', '<C-d>'), completion_opts)
        vim.keymap.set('i', '<C-b>', function() schedule_scroll_float(-4) end, opts)
        vim.keymap.set('i', '<C-f>', function() schedule_scroll_float(4) end, opts)
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
