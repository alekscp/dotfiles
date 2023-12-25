return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
    vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>")
    vim.keymap.set("n", "<leader>n", ":NvimTreeFindFile<CR>")

    require("nvim-tree").setup {
      update_cwd = false,
    }
  end,
}
