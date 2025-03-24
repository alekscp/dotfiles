return {
 "folke/trouble.nvim",
 dependencies = { "nvim-tree/nvim-web-devicons" },
 cmd = "Trouble",
 keys = {
   {
     "<leader>xw",
     "<cmd>Trouble diagnostics toggle<cr>",
     desc = "Diagnostics (Trouble)",
   },
 },
 config = function()
   require("trouble").setup()
   -- vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
   -- {silent = true, noremap = true}
   -- )
 end,
}
