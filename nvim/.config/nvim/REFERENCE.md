# Neovim Reference

KISS reference for this config. `<leader>` is not set in the config, so it uses Vim's default: `\`.

## Package Commands

| Command | What it does |
| --- | --- |
| `:PackStatus` | Show installed plugins and pending updates without fetching. |
| `:PackUpdate` | Fetch updates and open the confirmation buffer. Confirm with `:w`; cancel with `:q`. |
| `:PackUpdate!` | Apply plugin updates immediately, skipping confirmation. |
| `:PackUpdate plugin-name` | Update only one plugin. |
| `:PackSync` | Sync installed plugins to `nvim-pack-lock.json`; confirm with `:w`. |
| `:PackSync!` | Sync to the lockfile immediately. |
| `:PackClean` | Delete inactive plugins no longer loaded by the config. |

Notes:

- `nvim-pack-lock.json` is the plugin lockfile. Commit it after updates.
- `telescope-fzf-native.nvim` runs `make` after install/update.
- `nvim-treesitter` runs `:TSUpdate` after install/update.

## General Keys

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `<space>h` | Clear search highlight. |
| Normal | `0` | Go to first non-blank character. |
| Normal | `<C-s>` | Save file. |
| Insert | `<C-s>` | Save file and return to normal mode. |
| Insert | `<C-c>` | Escape insert mode. |
| Normal | `<space>u` | Open Undotree, if the optional package is installed. |
| Normal | `J` | Join line and keep cursor position centered. |
| Normal | `<C-d>` | Scroll down and center cursor. |
| Normal | `<C-u>` | Scroll up and center cursor. |
| Normal | `n` | Next search result and center. |
| Normal | `N` | Previous search result and center. |
| Visual | `J` | Move selected lines down. |
| Visual | `K` | Move selected lines up. |
| Visual | `<leader>p` | Paste without replacing the unnamed register. |
| Normal | `<leader>s` | Substitute word under cursor across file. |

## Files And Buffers

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `<C-p>` | Telescope Git files. |
| Normal | `<leader>ff` | Telescope find files, including hidden files. |
| Normal | `<leader>fg` | Telescope live grep. |
| Normal | `<leader>fh` | Telescope help tags. |
| Normal | `<leader>fd` | Telescope diagnostics. |
| Normal | `<leader>k` | Grep word under cursor. |
| Normal | `<space>b` | Telescope buffers. |
| Normal | `<space>m` | Telescope marks. |
| Telescope insert | `<M-d>` | Delete selected buffer or mark. `<M>` means Option/Alt. |
| Normal | `<C-n>` | Toggle NvimTree. |
| Normal | `<leader>r` | Refresh NvimTree. |
| Normal | `<leader>n` | Reveal current file in NvimTree. |

Useful commands:

- `:LazyGit`
- `:NvimTreeToggle`
- `:NvimTreeFindFile`
- `:NvimTreeRefresh`
- `:Telescope`
- `:Trouble`
- `:TSUpdate`

## LSP And Completion

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `gd` | Go to definition. |
| Normal | `gr` | References. |
| Normal | `gi` | Implementation. |
| Normal | `K` | Hover docs. Press `K` again to focus the hover popup. |
| Normal | `<leader>vws` | Workspace symbols. |
| Normal | `<space>e` | Diagnostic float. |
| Normal | `[d` | Next diagnostic. |
| Normal | `]d` | Previous diagnostic. |
| Normal | `<space>ca` | Code action. |
| Normal | `<leader>vrn` | Rename symbol. |
| Insert | `<C-h>` | Signature help. |
| Insert completion | `<C-x><C-o>` | Manually trigger LSP/omni completion. |
| Insert completion | `<C-n>` | Next completion item. |
| Insert completion | `<C-p>` | Previous completion item. |
| Insert completion | `<PageDown>` | Page down in completion menu. |
| Insert completion | `<PageUp>` | Page up in completion menu. |

Popup notes:

- Completion menu scrolling and docs popup scrolling are separate.
- Completion uses Neovim's native LSP autocomplete. There are no custom completion movement mappings.
- Use `<C-n>/<C-p>/<PageUp>/<PageDown>` for the completion menu.
- Use the mouse to scroll long completion docs or hover docs.
- For keyboard-only fallback, use `<C-w><C-w>` to enter a popup window when Neovim allows it, then use normal Vim movement.
- Use `K` to open hover docs in normal mode.
- In focused LSP hover popups, `q` closes the popup.

Enabled LSP configs:

- `lua_ls`
- `rust_analyzer`
- `ts_ls`
- `ansiblels`
- `jinja_lsp`
- `yamlls`

## Git And Trouble

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `<leader>g` | Open LazyGit. |
| Normal | `<leader>xx` | Toggle workspace diagnostics in Trouble. |
| Normal | `<leader>xX` | Toggle current buffer diagnostics in Trouble. |
| Normal | `<leader>cs` | Toggle document symbols in Trouble. |
| Normal | `<leader>cl` | Toggle LSP definitions/references/etc. in Trouble. |
| Normal | `<leader>xL` | Toggle location list in Trouble. |
| Normal | `<leader>xQ` | Toggle quickfix list in Trouble. |

## Tmux Navigation

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `<C-h>` | Move to left tmux/vim pane. |
| Normal | `<C-j>` | Move to lower tmux/vim pane. |
| Normal | `<C-k>` | Move to upper tmux/vim pane. |
| Normal | `<C-l>` | Move to right tmux/vim pane. |
| Normal | `<C-\>` | Move to previous tmux/vim pane. |

## Copilot And Pairs

| Mode | Key | Action |
| --- | --- | --- |
| Insert | `‘` | Copilot next suggestion. |
| Insert | `“` | Copilot previous suggestion. |
| Insert | `<M-e>` | nvim-autopairs fast wrap. `<M>` means Option/Alt. |

## Misc Setup

- Clipboard uses the system clipboard: `unnamed`.
- Mouse is enabled.
- Line numbers are enabled.
- Indent width is 2 spaces by default.
- Text width and color column are 120.
- Completion uses built-in LSP autocomplete with popup docs.
- Treesitter auto-installs configured parsers and starts for every filetype.
- `jsonc` uses the `json` Treesitter parser.
- `nginx` files use 4-space indentation.
