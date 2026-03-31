return function()
  require("catppuccin").setup({
    flavour = "macchiato",
    transparent_background = true,
    float = {
      transparent = true,
    },
    custom_highlights = function(colors)
      return {
        NormalFloat = { bg = colors.base },
        FloatBorder = { bg = colors.base, fg = colors.surface1 },
        FloatTitle = { bg = colors.base, fg = colors.blue },
        Pmenu = { bg = colors.base, fg = colors.text },
        PmenuBorder = { bg = colors.base, fg = colors.surface1 },
        PmenuSel = { bg = colors.surface0, fg = colors.text, bold = true },
        PmenuSbar = { bg = colors.mantle },
        PmenuThumb = { bg = colors.surface1 },
      }
    end,
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
    },
    integrations = {
      gitsigns = true,
      nvimtree = true,
      telescope = true,
    },
  })

  vim.cmd.colorscheme("catppuccin-nvim")
  vim.api.nvim_set_hl(0, "MatchParen", { fg = "#e78284", bg = "#414559", bold = true, underline = true })
end
