return {
  "mbbill/undotree",
  config = function()
    vim.keymap.set("n", "<space>u", vim.cmd.UndotreeToggle)
  end,
}
