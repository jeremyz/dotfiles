require 'user.options'
require 'user.keymaps'
require 'user.bepo'
require 'user.lazy'
require 'user.config'
require 'user.colors'
-- require 'user.netrw'

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    -- if vim.bo.ft ~= "netrw" then
    --   return
    -- end
    local mark = vim.api.nvim_buf_get_mark(0, "\"")
    if mark then
        vim.cmd("normal g`\"")
    end
  end,
})
