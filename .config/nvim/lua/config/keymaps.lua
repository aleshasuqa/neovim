local vim = vim
local map = vim.keymap.set

map('n', '<leader>h', ':noh<CR>', { silent = true })

map("v", "N", ":m '>+1<CR>gv=gv")
map("v", "E", ":m '<-2<CR>gv=gv")

map("x", "p", '"_dP')
map("i", "<C-c>", "<Esc>")
map("n", "<leader>k", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>]])

map("n", "<leader>e", vim.cmd.Ex)
map("n", "<leader>so", ":source ~/.config/nvim/init.lua<CR>", { silent = true })

map('n', '<leader>d', vim.diagnostic.open_float)
