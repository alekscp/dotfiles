return function()
  local treesitter = require("nvim-treesitter")
  local languages = {
    "bash",
    "c",
    "diff",
    "gitcommit",
    "gitignore",
    "json",
    "javascript",
    "lua",
    "markdown",
    "markdown_inline",
    "query",
    "rust",
    "toml",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  }

  treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })

  vim.treesitter.language.register("json", "jsonc")

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
    treesitter.install(missing, { summary = true })
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("alekscp-treesitter", { clear = true }),
    pattern = "*",
    callback = function(event)
      pcall(vim.treesitter.start, event.buf)
    end,
  })
end
