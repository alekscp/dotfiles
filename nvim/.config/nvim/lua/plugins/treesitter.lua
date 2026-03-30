return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    local languages = {
      "c",
      "javascript",
      "lua",
      "markdown",
      "markdown_inline",
      "rust",
      "typescript",
    }

    treesitter.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    local installed = {}
    for _, lang in ipairs(treesitter.get_installed("parsers")) do
      installed[lang] = true
    end

    local missing = {}
    for _, lang in ipairs(languages) do
      if not installed[lang] then
        table.insert(missing, lang)
      end
    end

    if #missing > 0 then
      treesitter.install(missing, {summary = true})
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("alekscp-treesitter", {clear = true}),
      pattern = "*",
      callback = function(event)
        pcall(vim.treesitter.start, event.buf)
      end,
    })
  end,
}
