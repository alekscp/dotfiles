local gh = function(repo)
  return "https://github.com/" .. repo
end

local pack_plugin_names = function()
  local names = vim.iter(vim.pack.get())
    :map(function(plugin)
      return plugin.spec.name
    end)
    :totable()

  table.sort(names)
  return names
end

local complete_pack_plugin_names = function(arg_lead)
  return vim.iter(pack_plugin_names())
    :filter(function(name)
      return arg_lead == "" or vim.startswith(name, arg_lead)
    end)
    :totable()
end

local pack_group = vim.api.nvim_create_augroup("alekscp-pack", { clear = true })

vim.api.nvim_create_autocmd("PackChanged", {
  group = pack_group,
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind

    if kind ~= "install" and kind ~= "update" then
      return
    end

    if name == "telescope-fzf-native.nvim" then
      local build = vim.system({ "make" }, { cwd = ev.data.path, text = true }):wait()
      if build.code ~= 0 then
        local message = build.stderr ~= "" and build.stderr or build.stdout
        vim.notify(
          "Failed to build telescope-fzf-native.nvim\n" .. message,
          vim.log.levels.ERROR,
          { title = "vim.pack" }
        )
      end
      return
    end

    if name == "nvim-treesitter" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      pcall(vim.cmd, "TSUpdate")
    end
  end,
})

vim.api.nvim_create_user_command("PackUpdate", function(opts)
  local names = #opts.fargs > 0 and opts.fargs or nil
  vim.pack.update(names, { force = opts.bang })
end, {
  bang = true,
  complete = complete_pack_plugin_names,
  desc = "Update vim.pack plugins",
  nargs = "*",
})

vim.api.nvim_create_user_command("PackStatus", function()
  vim.pack.update(nil, { offline = true })
end, { desc = "Show vim.pack plugin status" })

vim.api.nvim_create_user_command("PackSync", function(opts)
  vim.pack.update(nil, { force = opts.bang, target = "lockfile" })
end, { bang = true, desc = "Sync vim.pack plugins to lockfile" })

vim.api.nvim_create_user_command("PackClean", function()
  local inactive = vim.iter(vim.pack.get())
    :filter(function(plugin)
      return not plugin.active
    end)
    :map(function(plugin)
      return plugin.spec.name
    end)
    :totable()

  if #inactive == 0 then
    vim.notify("No inactive vim.pack plugins to delete", vim.log.levels.INFO, { title = "vim.pack" })
    return
  end

  vim.pack.del(inactive)
end, { desc = "Delete inactive vim.pack plugins" })

vim.pack.add({
  { src = gh("catppuccin/nvim"), name = "catppuccin" },
  gh("nvim-lua/plenary.nvim"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("github/copilot.vim"),
  gh("lewis6991/gitsigns.nvim"),
  gh("lukas-reineke/indent-blankline.nvim"),
  gh("williamboman/mason.nvim"),
  gh("neovim/nvim-lspconfig"),
  gh("kdheepak/lazygit.nvim"),
  { src = gh("nvim-telescope/telescope.nvim"), version = "v0.2.0" },
  gh("nvim-telescope/telescope-fzf-native.nvim"),
  gh("christoomey/vim-tmux-navigator"),
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
  gh("windwp/nvim-autopairs"),
  gh("windwp/nvim-ts-autotag"),
  gh("nvim-tree/nvim-tree.lua"),
  gh("folke/trouble.nvim"),
}, { confirm = false })

require("plugins.catppuccin")()
require("plugins.gitsigns")()
require("plugins.indent-blankline")()
require("plugins.lsp")()
require("plugins.lazygit")()
require("plugins.telescope")()
require("plugins.vim-tmux-navigator")()
require("plugins.treesitter")()
require("plugins.autopairs")()
require("plugins.nvim-tree")()
require("plugins.trouble")()
