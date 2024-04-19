function ApplyColorscheme(scheme)
  scheme = scheme or 'darkplus'
  vim.cmd.colorscheme(scheme)

  local hl = vim.api.nvim_set_hl
  local c = require('darkplus.palette')

  hl(0, 'Normal', { bg = 'none' })
  hl(0, 'NormalFloat', { bg = 'none' })
  hl(0, 'CursorLine', { bg = '#3a3a3a' })
  hl(0, 'CursorLineNr', { bg = '#8a4a59' })
  hl(0, 'ColorColumn', { bg = '#3a3a3a' })
  -- hl(0, 'IncSearch', { bg = 'peru', fg = 'wheat' })
  -- hl(0, 'Search', { bg = 'peru', fg = 'wheat' })
  hl(0, 'Search', { bg = '#9fa97f', fg = 'black' })
  hl(0, 'NonText', { fg = '#4a4a59' })
  hl(0, 'netrwMarkFile', { bg = '#ede99d', fg = 'black' })
  vim.cmd[[match ExtraWhitespace /\s\+$/]]
  hl(0, 'ExtraWhitespace', { bg = '#bb7a44', fg = 'black' })
  hl(0, 'FloatBorder', { fg = 'red' })
  -- hl(0, 'NormalFloat', { bg='#334f17' })
  hl(0, 'TelescopeBorder', { fg='red' })
  hl(0, 'LspReferenceText', { bg='#606060' })
  hl(0, 'LspReferenceRead', { bg='#606000' })
  hl(0, 'LspReferenceWrite', { bg='#066000' })

end

--ApplyColorscheme('gruvbox')
ApplyColorscheme()
