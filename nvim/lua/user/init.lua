require 'user.options'
require 'user.keymaps'
require 'user.bepo'
require 'user.lazy'
require 'user.colors'
-- require 'user.netrw'

vim.filetype.add({
  extension = {
    gd = "gdscript",
    tscn = "gdscript",
  },
})

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

vim.api.nvim_create_autocmd("VimLeave", {
  pattern = "**/task/notes/*.md",
  callback = function()
    local file_path = vim.fn.expand("%")
    if file_path == "" or vim.fn.filereadable(file_path) == 0 then
      return
    end
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    if #lines <= 1 and lines[1] == "" then
      os.remove(file_path)
    end
  end,
})
