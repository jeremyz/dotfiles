vim.opt.swapfile = false                        -- creates a swapfile
vim.opt.backup = false                          -- creates a backup file
vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.undofile = false                        -- persistent undo
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file

vim.opt.mouse = ""                              -- disable the mouse usage
vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard

vim.opt.number = true                           -- set numbered lines
vim.opt.relativenumber = true                   -- set relative numbered lines
vim.opt.numberwidth = 4                         -- set number column width to 2 {default 4}

vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.shiftwidth = 2                          -- the number of spaces inserted for each indentation
vim.opt.tabstop = 3                             -- displays 2 spaces for a tab
vim.opt.softtabstop = 3                         -- insert 2 spaces for a tab key
vim.opt.showtabline = 3                         -- always show tabs

vim.opt.wrap = false                            -- display lines as one long line

vim.opt.cursorline = true                       -- highlight the current line
vim.opt.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.colorcolumn = "80"                      -- vertical bar

vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
vim.opt.ignorecase = false                      -- ignore case in search patterns
vim.opt.smartcase = true                        -- search is case sensitive if the search term contains uppercase letter
-- vim.opt.completeopt = { "menuone", "noselect" }  -- mostly just for cmp
-- vim.opt.conceallevel = 0                         -- so that `` is visible in markdown files

vim.opt.smartindent = false                     -- make indenting smarter

vim.opt.cmdheight = 2                           -- more space in the neovim command line for displaying messages
vim.opt.pumheight = 10                          -- pop up menu height
vim.opt.showmode = true                         -- we don't need to see things like -- INSERT -- anymore
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window

vim.opt.guifont = "monospace:h17"               -- the font used in graphical neovim applications
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)

vim.opt.updatetime = 200                        -- faster completion (4000ms default)
vim.opt.timeoutlen = 400                        -- time to wait for a mapped sequence to complete (in milliseconds)

vim.opt.scrolloff = 8                           -- # lines above under the cursor
vim.opt.sidescrolloff = 8
vim.opt.ruler = true
vim.opt.laststatus = 2

vim.opt.shortmess:append "c"

vim.opt.list = true
vim.opt.listchars = {
  tab = '▸ ',
  trail = '·',
  extends = '→',
  precedes = '←',
  nbsp = '␣'
  --eol = '⤶',
}

--bool Object::_predelete() {
--	_predelete_ok = 1;
--	notification(NOTIFICATION_PREDELETE, true);
--	if (_predelete_ok) {

-- vim.cmd [[set iskeyword+=-]]                -- word split definition
-- vim.cmd "set whichwrap+=<,>,[,],h,l"        -- change line with left/right moves
