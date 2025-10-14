return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "macchiato",
      transparent_background = true,
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

    -- Set the colorscheme
    vim.cmd.colorscheme("catppuccin")

    -- Customize the MatchParen highlight group to make it more visible
    vim.api.nvim_set_hl(0, "MatchParen", { fg = "#e78284", bg = "#414559", bold = true, underline = true })
  end,
}
