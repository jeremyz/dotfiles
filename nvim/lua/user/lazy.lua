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
require("lazy").setup({
  ui = {
    border = "rounded",
  },
  'nvim-lua/plenary.nvim',
  'lunarvim/darkplus.nvim',
  'morhetz/gruvbox',
  'jamessan/vim-gnupg',
  {
    'folke/todo-comments.nvim',
    config = function()
      require('todo-comments').setup()
    end,
  },
  'tpope/vim-fugitive',
  'embear/vim-localvimrc',
  {
    'stevearc/oil.nvim',
    config = function()

      require('oil').setup({
        view_options = {
          show_hidden = true,
        },
        float = {
          border = "rounded",
          max_width = 0.5,
          max_height = 0.5,
        }
      })
      vim.keymap.set("n", "-", require('oil').toggle_float, { desc = "Open parent directory" })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      numhl = true,
      word_diff = false,
      preview_config = {
        border = 'rounded',
      },
      current_line_blame_formatter = '    <author>, <author_time:%R> - <summary>',
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')
        vim.keymap.set('n', '<leader>gt', gitsigns.next_hunk, {})
        vim.keymap.set('n', '<leader>gs', gitsigns.prev_hunk, {})
        vim.keymap.set('n', '<leader>ga', gitsigns.stage_hunk, {})
        vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, {})
        vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, {})
        vim.keymap.set('n', '<leader>gb', gitsigns.toggle_current_line_blame, {})
      end
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
    config = function()
      require('lualine').setup()
    end,
  },
  -- GODOT
  { 'habamax/vim-godot', event = 'VimEnter' },
  -- TELESCOPE
  {
    'nvim-telescope/telescope.nvim', -- needs ripgrep
    requires = { {'nvim-lua/plenary.nvim'} },
  },
  -- TREESITTER
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },
  -- MASON
  {
    'williamboman/mason.nvim',
    config = function()
      require("mason").setup({
        ui = { border = "rounded" }
      })
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "jdtls",
          "jsonls",
          "sqlls",
          "bashls",
          "rust_analyzer",
          "solargraph",
        },
        automatic_installation = true,
      })
    end,
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
})

-- TELESCOPE --
local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      "%.git/",
      "%.class",
      "target/",
      "build/",
    },
    mappings = {
      i = {
        ["<A-s>"] = actions.move_selection_previous,
        ["<A-t>"] = actions.move_selection_next,
        ["<A-d>"] = actions.delete_buffer
      },
    },
    path_display = { "shorten" },
    dynamic_preview_title = true,
  },
  pickers = {
    find_files = {
      follow = true
    }
  },
  highlights = {
    TelescopeBorder = {
      guifg = '#FF0000',  -- Border color (example: red)
      guibg = '#000000',  -- Background color (example: black)
    },
  },
}
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>tf', builtin.find_files)
vim.keymap.set('n', '<leader>tb', function() builtin.buffers(require('telescope.themes').get_dropdown{previewer = true}) end, {})
vim.keymap.set('n', '<leader>tg', builtin.git_files)
vim.keymap.set('n', '<leader>th', builtin.help_tags)
vim.keymap.set('n', '<leader>ts', function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end) -- needs ripgrep !!!

-- TREESITTER --
require('nvim-treesitter').setup({
  ensure_installed = { 'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc', 'java', 'ruby', 'rust' },
  -- Autoinstall languages that are not installed
  auto_install = true,
  highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --  If you are experiencing weird indenting issues, add the language to
    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
    additional_vim_regex_highlighting = { 'ruby' },
  },
  indent = { enable = true, disable = { 'ruby', 'gdscript' } },
})

-- LSP UI --
vim.diagnostic.config({
  virtual_text = false,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- LSP --
vim.lsp.config('*', {
  root_markers = { '.git', 'Gemfile'},
})

-- vim.lsp.log.set_level("debug")
local lsp_attach = function(event)
  local bufnr = type(event) == "table" and event.buf or event
  if type(bufnr) ~= "number" then
      return
  end
  local ts = require('telescope.builtin')
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end
  map('<leader>s', vim.diagnostic.goto_prev, 'Prev Diagnostic')
  map('<leader>t', vim.diagnostic.goto_next, 'Next Diagnostic')
  map("<leader>=", vim.lsp.buf.format, 'Format')
  map("<leader>l,", ts.lsp_definitions, 'Definition')  -- ,, is :pop
  map("<leader>le", vim.lsp.buf.hover, 'Hover')
  map("<leader>li", ts.lsp_references, 'Reference')
  map("<leader>lu", function() ts.lsp_dynamic_workspace_symbols({ default_text = vim.fn.expand("<cword>") }) end, 'Workspace Symbol')
  map("<leader>la", vim.lsp.buf.code_action, 'Code Action')
  map("<leader>lk", vim.lsp.buf.rename, 'Rename')
  map("<leader>lg", function() ts.live_grep({ default_text = vim.fn.expand("<cword>") }) end, 'Live Grep')
  -- map("<leader>l,", ts.lsp_type_definitions, 'Definition')  -- ,, is :pop
  -- map("<leader>l", vim.lsp.buf.implementation, 'Implementation')
  -- map("i", "<leader>l", vim.lsp.buf.signature_help, 'Signature Help')
  -- map("<leader>l", vim.lsp.buf.declaration, 'Declaration')
  -- map('gI', ts.lsp_implementations, '[G]oto [I]mplementation')
  -- map('<leader>ds', ts.lsp_document_symbols, '[D]ocument [S]ymbols')
  -- map('<leader>ws', ts.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  -- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = lsp_attach,
})
--  create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

local java_executable = '/usr/lib/jvm/java-26-openjdk/bin/java'
local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local lombok_jar = vim.fn.glob(jdtls_path .. '/lombok.jar')
local config_dir = jdtls_path .. '/config_linux/'
local workspace_dir = vim.fn.stdpath('cache') .. '/jdtls/workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local jdtls_config = {
  cmd = {
    java_executable,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true', -- Enable protocol logging (useful for debugging)
    '-Dlog.level=ALL',
    '-Xms1G', -- Initial heap size for JDTLS server
    '-Xmx2G', -- Max heap size for JDTLS server
    -- "--enable-native-access=ALL-UNNAMED", -- silences warnings
    "-javaagent:" .. lombok_jar,
    '-jar', launcher_jar,
    '-configuration', config_dir,
    '-data', workspace_dir,
  },
  filetypes = { 'java' },
  settings = {
    java = {
      format = {
        enabled = true
      }
    }
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
    vim.bo[bufnr].shiftwidth = 2
    vim.bo[bufnr].tabstop = 2
    vim.bo[bufnr].softtabstop = 2
    vim.bo[bufnr].expandtab = true
  end
}

local lsp_configs = {
  bashls = {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'sh', 'bash' },
  },
  clangd = {
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  },
  gdscript = {
    cmd = { vim.fn.exepath('nc'), '127.0.0.1', '6005' },
    filetypes = { 'gdscript' },
    root_markers = { 'project.godot', '.git' },
  },
  jdtls = jdtls_config,
  jsonls = {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json' },
  },
  rust_analyzer = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
    root_dir = vim.fs.root(0, { "Cargo.toml", "rust-project.json" }),
    settings = {
      ["rust-analyzer"] = {
        check = {  -- Changed from checkOnSave
          command = "clippy",  -- Changed from checkOnSave.command
        },
        linkedProjects = { "Cargo.toml" },
      },
    },
  },
  sqlls = {
    cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
    filetypes = { 'sql' },
    settings = {
      sqlls = {
        dialect = 'postgresql',
      },
    },
  },
  solargraph = {
    cmd = { 'solargraph', 'stdio' },
    filetypes = { 'ruby' },
  },
}

for name, config in pairs(lsp_configs) do
  vim.lsp.config(name, config)
  vim.lsp.enable(name)
end

-- CMP --
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}
local cmp = require('cmp')
cmp.setup {
  mapping = {
    ['<A-s>'] = cmp.mapping.select_prev_item(),
    ['<A-t>'] = cmp.mapping.select_next_item(),
    -- ["<A-Enter>"] = cmp.mapping.complete(),
    -- ["<A-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true })
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = function(entry, vim_item)
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
  experimental = {
    ghost_text = true,    -- grey autosuggestion
    native = true,
  },
}

cmp.setup.filetype({'sql'}, {
  sources = {
    { name = "vim-dadbod-completion" },
    { name = "buffer" },
  },
})

-- DAP
local dap = require 'dap'
local dapui = require 'dapui'

require('mason-nvim-dap').setup {
  automatic_setup = true,
  -- see mason-nvim-dap README for more information
  handlers = {},
  ensure_installed = {},
}

vim.keymap.set('n', '<F19>', dapui.toggle, { desc = 'Debug: See last session result.' })
vim.keymap.set('n', '<F18>', dap.continue, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>è', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>È', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Debug: Set Breakpoint' })

-- :help nvim-dap-ui|
dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- GDSCRIPT Logic --
vim.api.nvim_create_autocmd( "FileType", {
  pattern = "gdscript",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = false
    local opts = { buffer = true, noremap = true, silent = true }
    vim.keymap.set('n', '<F4>', ':GodotRunLast<CR>', opts)
    vim.keymap.set('n', '<F5>', ':GodotRun<CR>', opts)
    vim.keymap.set('n', '<F6>', ':GodotRunCurrent<CR>', opts)
    vim.keymap.set('n', '<F7>', ':GodotRunFZF<CR>', opts)
  end
})

--- nvim --listen /tmp/godotsocket
--- nvim --server /tmp/godotsocket --remote-send "<C-\><C-N>:n {file}<CR>:call cursor({line},{col})<CR>"
-- Godot Socket for External Editor communication
local godot_socket = '/tmp/godotsocket'
if vim.fn.filereadable(vim.fn.getcwd()..'/project.godot') == 1 then
  vim.fn.serverstart(godot_socket)
end

-- :help dap-configuration
dap.adapters.godot = {
  type = 'server',
  host = '127.0.0.1',
  port = '6006',
}

dap.configurations.gdscript = {
  {
    type = 'godot',
    request = 'launch',
    name = 'Launch scene',
    project = '${workspaceFolder}',
    launch_scene = true,
  },
}
