local telescope = require('telescope')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ff', function()
	builtin.find_files({ hidden = true });
end)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>k', builtin.grep_string, {})
vim.keymap.set('n', '<space>b', builtin.buffers, {})
vim.keymap.set('n', '<space>m', builtin.marks, {})

telescope.setup {
	defaults = {
		file_ignore_patterns = {
			'.git/', 'node_modules/', '.npm/'
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
					["<C-d>"] = require('telescope.actions').delete_buffer,
				}
			}
		}
	}
}

require('telescope').load_extension('fzf')
