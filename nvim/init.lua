local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- ───────────────────────────────────────────────────────────────────────────
  -- Themes
  -- ───────────────────────────────────────────────────────────────────────────

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- Options: storm, moon, night, day
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help", "terminal", "packer" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
      })
      vim.cmd.colorscheme("desert")
    end,
  },


  -- ───────────────────────────────────────────────────────────────────────────
  -- File Explorer
  -- ───────────────────────────────────────────────────────────────────────────
  { "nvim-tree/nvim-tree.lua" },
  { "nvim-tree/nvim-web-devicons" },

  -- ───────────────────────────────────────────────────────────────────────────
  -- Telescope
  -- ───────────────────────────────────────────────────────────────────────────
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  { 
    "ThePrimeagen/harpoon", 
    branch = "harpoon2", 
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  -- ───────────────────────────────────────────────────────────────────────────
  -- Treesitter
  -- ───────────────────────────────────────────────────────────────────────────

-- In your lazy.setup section

{
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSUpdate", "TSUpdateSync" },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.config").setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
},

  -- ───────────────────────────────────────────────────────────────────────────
  -- LSP
  -- ───────────────────────────────────────────────────────────────────────────
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },

  -- ───────────────────────────────────────────────────────────────────────────
  -- Autocompletion
  -- ───────────────────────────────────────────────────────────────────────────
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- ───────────────────────────────────────────────────────────────────────────
  -- Autopairs
  -- ───────────────────────────────────────────────────────────────────────────
  -- ───────────────────────────────────────────────────────────────────────────
  -- Git
  -- ───────────────────────────────────────────────────────────────────────────
  { "lewis6991/gitsigns.nvim" },

  -- ───────────────────────────────────────────────────────────────────────────
  -- Statusline
  -- ───────────────────────────────────────────────────────────────────────────

  -- ───────────────────────────────────────────────────────────────────────────
  -- Copilot
  -- ───────────────────────────────────────────────────────────────────────────
  { "github/copilot.vim" },
})

-- ─────────────────────────────────────────────────────────────────────────────
-- Basic Settings
-- ─────────────────────────────────────────────────────────────────────────────
vim.opt.number = true
vim.opt.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.g.mapleader = " "



-- ─────────────────────────────────────────────────────────────────────────────
-- LSP Configuration
-- ─────────────────────────────────────────────────────────────────────────────
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "clangd" },
  automatic_installation = true,
})

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config.clangd = {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
  },
  capabilities = capabilities,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
  callback = function()
    vim.lsp.enable("clangd")
  end,
})

-- ─────────────────────────────────────────────────────────────────────────────
-- Git Signs
-- ─────────────────────────────────────────────────────────────────────────────
require("gitsigns").setup({
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
})

-- ─────────────────────────────────────────────────────────────────────────────
-- NvimTree with Tokyo Night styling
-- ─────────────────────────────────────────────────────────────────────────────
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  filters = {
    dotfiles = false,
  },
})

-- ─────────────────────────────────────────────────────────────────────────────
-- Keymaps
-- ─────────────────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>")


-- ─────────────────────────────────────────────────────────────────────────────
-- Harpoon Keymaps
-- ─────────────────────────────────────────────────────────────────────────────
local harpoon = require("harpoon")
harpoon:setup()

-- Add current file to harpoon
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)

-- Open harpoon menu (see all marked files)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- Jump to specific files
vim.keymap.set("n", "<C-y>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-u>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-i>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-o>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<C-p>", function() harpoon:list():select(5) end)

-- Navigate through harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)


-- ─────────────────────────────────────────────────────────────────────────────
-- LSP Keymaps
-- ─────────────────────────────────────────────────────────────────────────────
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Find references' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
