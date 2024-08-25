-- vim.opt.foldmethod = "expr"
--
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldcolumn = "0"
-- vim.opt.foldtext = ""
-- vim.opt.foldlevel = 99
-- vim.opt.foldlevelstart = 1
-- vim.opt.foldnestmax = 4
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.number = true
-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set linebreak")
vim.cmd("set mousescroll=ver:30")
-- vim.cmd("set so=999")
-- vim.cmd("nnoremap k kzz")
-- vim.cmd("nnoremap j jzz")


-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
})

-- vim.keymap.set('n', '<leader>h',vim.lsp.buf.hover, {})
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = { { import = "plugins" } },
  rocks = {
    hererocks = true
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "tokyonight-storm" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require("tokyonight").setup({
  style = "storm",
  plugins = {
    auto = true
  },
  transparent = false,
})

vim.cmd.colorscheme("tokyonight-storm")

-- local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
--
-- vim.keymap.set('n', '<leader>fs', ':NvimTreeOpen<CR>',{})
-- vim.cmd.colorscheme "tokyonight-storm"
-- vim.keymap.set('n', '<leader>m', ':Mason<CR>', {})
-- vim.keymap.set('n', '<leader>o',':Oil<CR>',{})

--[[ require('colorizer').setup() ]]
require("oil").setup({
  columns = {"icon"},
  win_options = {
    winblend = 0
  },
  view_options = {
    show_hidden = true,
  },
  float = {
    win_options = {
      winblend = 0
    },
    border = "none"
  },
  preview = {
    win_options = {
      winblend = 0
    },
    border = "none"
  },

})

--require("noice").setup({})

require("lualine").setup({
  options = { theme = "auto" },
  -- sections = {
  --   lualine_x = {
  --     {
  --       require("noice").api.statusline.mode.get,
  --       cond = require("noice").api.statusline.mode.has,
  --       color = { fg = "#ff9e64" },
  --     }
  --   },
  -- },
})

require("Comment").setup()

-- require("mason-lspconfig").setup({
-- ensure_installed = {"astro","bashls","cssls","cssmodules_ls","css_variables","unocss","dockerls","docker_compose_language_service","emmet_language_server","html","htmx","gopls","jsonls","biome","tsserver","lua_ls","marksman","mdx_analyzer","pyright","sqlls","svelte","taplo","tailwindcss","templ","vtsls","gitlab_ci_ls","yamlls"}
-- })

-- This is your opts table
require("telescope").setup({
  defaults = {
    border = {},
    borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
  },
  extensions = {},
})

-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("noice")

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require("go.format").goimports()
  end,
  group = format_sync_grp,
})

vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
