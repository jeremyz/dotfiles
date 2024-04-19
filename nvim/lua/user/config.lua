
require('todo-comments').setup()

require('oil').setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

require('lualine').setup()

-- TELESCOPE --
local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<A-s>"] = actions.move_selection_previous,
        ["<A-t>"] = actions.move_selection_next
      }
    },
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
vim.keymap.set('n', '<leader>ts', function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end)

-- TREESITTER --
require('nvim-treesitter.configs').setup({
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
require('lspconfig.ui.windows').default_options.border = 'rounded'
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
vim.lsp.set_log_level('off')
local lsp_attach = function(event)
  local ts = require('telescope.builtin')
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end
  map('<leader>s', vim.diagnostic.goto_prev, 'Prev Diagnostic')
  map('<leader>t', vim.diagnostic.goto_next, 'Next Diagnostic')
  map("<leader>=", vim.lsp.buf.format, 'Format')
  map("<leader>l,", ts.lsp_definitions, 'Definition')  -- ,, is :pop
  -- map("<leader>l,", ts.lsp_type_definitions, 'Definition')  -- ,, is :pop
  map("<leader>le", vim.lsp.buf.hover, 'Hover')
  map("<leader>li", ts.lsp_references, 'Reference')
  map("<leader>lu", ts.lsp_workspace_symbols, 'Workspace Symbol')
  map("<leader>la", vim.lsp.buf.code_action, 'Code Action')
  map("<leader>lk", vim.lsp.buf.rename, 'Rename')
  -- map("<leader>l", vim.lsp.buf.implementation, 'Implementation')
  -- map("i", "<leader>l", vim.lsp.buf.signature_help, 'Signature Help')
  -- map("<leader>l", vim.lsp.buf.declaration, 'Declaration')
  -- map('gI', ts.lsp_implementations, '[G]oto [I]mplementation')
  -- map('<leader>ds', ts.lsp_document_symbols, '[D]ocument [S]ymbols')
  -- map('<leader>ws', ts.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  -- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- highlight references of the word under the cursor
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client and client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = event.buf,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = event.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = lsp_attach,
})
--  create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

-- MASON --
servers = {
  'clangd',
  'jdtls',
  'jsonls',
  'sqlls',
  'bashls',
  'rust_analyzer',
  'solargraph',
}
servers_setup = {
  -- help solargraph when working out of project
  solargraph = {
    root_dir = function()
      local cwd = vim.fn.getcwd()
      local root = require('lspconfig.util').root_pattern('Gemfile', '.git')(cwd)
      if root then
        return root
      end
      return vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    end
  },
}
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = servers,
  handlers = {
    function(server_name)
      local server = servers_setup[server_name] or {}
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      require('lspconfig')[server_name].setup(server)
    end,
  },
})

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
        cmp.select_next_item()
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

-- GDSCRIPT
vim.api.nvim_create_autocmd( "FileType", {
  pattern = "gdscript",
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.expandtab = false
    local map = vim.api.nvim_buf_set_keymap
    local opts = { noremap = true, silent = true }
    map(0, 'n', '<F4>', ':GodotRunLast<CR>', opts)
    map(0, 'n', '<F5>', ':GodotRun<CR>', opts)
    map(0, 'n', '<F6>', ':GodotRunCurrent<CR>', opts)
    map(0, 'n', '<F7>', ':GodotRunFZF<CR>', opts)
  end
})
-- nvim --listen /tmp/godotsocket
-- nvim --server /tmp/godotsocket --remote-send "<C-\><C-N>:n {file}<CR>:call cursor({line},{col})<CR>"
local godot_socket = '/tmp/godotsocket'
local gdproject = io.open(vim.fn.getcwd()..'/project.godot', 'r')
if gdproject then
  io.close(gdproject)
  vim.fn.serverstart(godot_socket)
end
-- :help lspconfig-setup
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/gdscript.lua
require('lspconfig').gdscript.setup {
  on_attach = lsp_attach
}
require'lspconfig'.gdshader_lsp.setup {
  on_attach = lsp_attach
}
dap.adapters.godot = {
  type = 'server',
  host = '127.0.0.1',
  port = '6006',
}
-- :help dap-configuration
dap.configurations.gdscript = {
  {
    type = 'godot',
    request = 'launch',
    name = 'Launch scene',
    project = '${workspaceFolder}',
    launch_scene = true,
  },
}
