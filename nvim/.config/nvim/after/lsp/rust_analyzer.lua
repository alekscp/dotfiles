return {
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local cargo_crate_dir = vim.fs.root(fname, { 'Cargo.toml' })

    if cargo_crate_dir == nil then
      on_dir(vim.fs.root(fname, { 'rust-project.json' }) or vim.fs.dirname(fname))
      return
    end

    local cmd = {
      'cargo',
      'metadata',
      '--no-deps',
      '--format-version',
      '1',
      '--manifest-path',
      cargo_crate_dir .. '/Cargo.toml',
    }

    vim.system(cmd, { text = true }, function(output)
      if output.code == 0 and output.stdout then
        local result = vim.json.decode(output.stdout)
        if result.workspace_root then
          on_dir(vim.fs.normalize(result.workspace_root))
          return
        end
      end

      on_dir(cargo_crate_dir)
    end)
  end,
}
