local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
require("lazy").setup {
  'nvim-lua/plenary.nvim',
  'lunarvim/darkplus.nvim',
  'morhetz/gruvbox',
  'jamessan/vim-gnupg',
  'folke/todo-comments.nvim',
  'tpope/vim-fugitive',
  'embear/vim-localvimrc',
  'stevearc/oil.nvim',
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      numhl      = true,
      word_diff = true,
    },
  },
  {
    "cbochs/grapple.nvim", -- ~/.local/share/nvim/grapple
    opts = { scope = "git", icons = true, status = true },
    keys = {
      { "<leader>p", "<cmd>Grapple toggle<cr>", desc = "Tag a file" },
      { "<leader>c", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },
      { "<A-=>", "<cmd>Grapple select index=1<cr>", desc = "Select first tag" },
      { "<A-+>", "<cmd>Grapple select index=2<cr>", desc = "Select second tag" },
      { "<A-->", "<cmd>Grapple select index=3<cr>", desc = "Select third tag" },
      { "<A-/>", "<cmd>Grapple select index=4<cr>", desc = "Select fourth tag" },
      -- { "<>", "<cmd>Grapple cycle_tags next<cr>", desc = "Go to next tag" },
      -- { "<>", "<cmd>Grapple cycle_tags prev<cr>", desc = "Go to previous tag" },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  -- gc[N][motion]
  {
    'numToStr/Comment.nvim',
    opts = { },
    lazy = false,
  },
  { 'habamax/vim-godot', event = 'VimEnter' },
  -- TELESCOPE
  {
    'nvim-telescope/telescope.nvim', -- needs ripgrep
    branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} },
  },
  -- TREESITTER
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },
  -- LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
  },
  -- CMP
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
    },
  },
  -- DAP
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
    },
  },
  -- SQL
  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-ui',   -- ~/.local/share/db_ui/connections.json
  'kristijanhusak/vim-dadbod-completion'
}
