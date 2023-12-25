return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,
  config = function()
    require("rose-pine").setup({
      dark_variant = "moon",
      disable_background = true,
    })

    -- Set the colorscheme
    vim.cmd.colorscheme("rose-pine")

    -- Set the background for normal and floating windows to none
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    -- Additionally, remove background difference for active and inactive windows
    vim.api.nvim_set_hl(0, "WinActive", { bg = "none" })
    vim.api.nvim_set_hl(0, "WinInactive", { bg = "none" })

    -- Customize the MatchParen highlight group to make it more visible
    vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ebbcba", bg = "#393552", bold = true, underline = true })
  end
}
