return {
  "nvim-telescope/telescope.nvim", tag = "v0.2.0",
  -- If you need older Neovim (<0.10), pin to an older tag like v0.1.6
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
  },

  config = function()
    local telescope = require("telescope")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<C-p>", builtin.git_files, {})
    vim.keymap.set("n", "<leader>ff", function()
      builtin.find_files({ hidden = true });
    end)
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    vim.keymap.set("n", "<leader>fd", builtin.diagnostics, {})
    vim.keymap.set("n", "<leader>k", builtin.grep_string, {})
    vim.keymap.set("n", "<space>b", builtin.buffers, {})
    vim.keymap.set("n", "<space>m", builtin.marks, {})

    telescope.setup {
      defaults = {
        file_ignore_patterns = {
          ".git/", "node_modules/", ".npm/"
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden"
        }
      },
      pickers = {
        buffers = {
          mappings = {
            i = {
              ["<M-d>"] = require("telescope.actions").delete_buffer,
            }
          }
        },
        marks = {
          mappings = {
            i = {
              ["<M-d>"] = require("telescope.actions").delete_mark,
            }
          }
        }
      }
    }

    require("telescope").load_extension("fzf")
  end,
}
