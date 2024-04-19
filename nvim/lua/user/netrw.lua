vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 15
--vim.g.netrw_browse_init = expand("%:p:h")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(0, 'n', 's', 'k', opts)
    vim.api.nvim_buf_set_keymap(0, 'n', 't', 'j', opts)
    -- https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/
    -- vim.cmd[[nmap <buffer> <TAB> mf]]                 -- mark
    -- vim.cmd[[nmap <buffer> <Leader><TAB> mu]]         -- un-mark
    -- vim.cmd[[p <buffer> ff %:w<CR>:buffer #<CR>]]     -- create and write file
    -- vim.cmd[[p <buffer> fe R]]                        -- rename
    -- vim.cmd[[p <buffer> fc mc]]                       -- copy marked
    -- vim.cmd[[p <buffer> fC mtmc]]                     -- copy marked into
    -- vim.cmd[[p <buffer> fx mm]]                       -- move marked
    -- vim.cmd[[p <buffer> fX mtmm]]                     -- move marked into
    -- vim.cmd[[p <buffer> f; mx]]                       -- execute on
  end,
})

local function open_current_dir_netrw()
  local is_netrw_buffer = string.match(vim.api.nvim_buf_get_name(0), ".*Netrw.*")
  if (is_netrw_buffer) then
    vim.cmd(":Lexplore ")
  else
    local current_file_path = vim.api.nvim_buf_get_name(0)
    local current_dir = vim.fn.fnamemodify(current_file_path, ":h")
    vim.cmd(":Lexplore " .. current_dir)
  end
end
vim.keymap.set("n", "<A-f>", open_current_dir_netrw)
-- vim.keymap.set("n", "<A-f>", vim.cmd.Lexplore)
