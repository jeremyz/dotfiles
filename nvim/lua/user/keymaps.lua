-- Leader key
vim.keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- windows move, resize, ...
vim.keymap.set('n', ',t', '<C-w>j')
vim.keymap.set('n', ',s', '<C-w>k')
vim.keymap.set('n', ',c', '<C-w>h')
vim.keymap.set('n', ',r', '<C-w>l')
vim.keymap.set('n', ',<SPACE>', ':split<CR>')
vim.keymap.set('n', ',<CR>', ':vsplit<CR>')
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize +2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize -2<CR>")

-- lsp
vim.keymap.set('n', ',,', ':pop<CR>')

-- search
-- vim.keymap.set('n', 'nN', ':nohl<CR>')

-- buffers
-- vim.keymap.set("n", "<S-H>", ":bnext<CR>")
-- vim.keymap.set("n", "<S-Q>", ":bprevious<CR>")

-- paste in visual mode yanks into void register
vim.keymap.set("v", "p", '"_dP')

-- replace what under the cursor in the whole file
vim.keymap.set("n", "<leader>/", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- stay in visual mode when indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- do not move the cursor when append line below
vim.keymap.set("n", "T", "mzJ`z")

-- stay centered on page up / dow or search
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- move visual block
vim.keymap.set("v", "<A-t>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-s>", ":m '<-2<CR>gv=gv")

-- chmod +x current file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- yank to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>") FIXME
