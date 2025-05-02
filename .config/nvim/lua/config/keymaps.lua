local vim = vim
local map = vim.keymap.set

map('n', '<leader>h', ':noh<CR>', { silent = true })

map("v", "N", ":m '>+1<CR>gv=gv")
map("v", "E", ":m '<-2<CR>gv=gv")

map("x", "p", '"_dP')
map("i", "<C-c>", "<Esc>")
map("n", "<leader>k", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>]])

map("n", "<leader>e", ':Oil<CR>')
map("n", "<leader>so", ":source ~/.config/nvim/init.lua<CR>", { silent = true })

map('n', '<leader>d', vim.diagnostic.open_float)

map('n', '<C-h>', require('smart-splits').move_cursor_left)
map('n', '<C-n>', require('smart-splits').move_cursor_down)
map('n', '<C-e>', require('smart-splits').move_cursor_up)
map('n', '<C-i>', require('smart-splits').move_cursor_right)

-- telescope
local telescope_builtin = require('telescope.builtin')
map('n', '<C-f>',
    function()
        telescope_builtin.find_files({
            hidden = true,
            layout_config = {
                width = 0.9,
                height = 0.9
            }
        })
    end)
map('n', '<leader>fg',
    function()
        telescope_builtin.live_grep({
            layout_strategy = 'vertical',
            layout_config = {
                mirror = true,
                preview_cutoff = 1,
                width = 0.8,
                height = 0.99
            },
            additional_args = { '--hidden' }
        })
    end)
map('n', '<leader>fh',
    function()
        telescope_builtin.help_tags({
            layout_strategy = 'vertical',
            layout_config = {
                mirror = true,
                preview_cutoff = 1,
                width = 0.5,
                height = 0.99
            }
        })
    end)
map('n', "<leader>vs",
    function()
        vim.cmd(":split<CR>")
        telescope_builtin.find_files({ hidden = true })
    end)
map('n', "<leader>hs",
    function()
        vim.cmd(":vsplit<CR>")
        telescope_builtin.find_files({ hidden = true })
    end)
map('n', '<leader>q', telescope_builtin.quickfix)

-- harpoon
local harpoon = require('harpoon')
map('n', '<leader>a', function() harpoon:list():add() end)
map('n', 't', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "harpoon" },
    callback = function()
        map('n', 'n', function() harpoon:list():select(1) end, { buffer = true })
        map('n', 's', function() harpoon:list():select(2) end, { buffer = true })
        map('n', 'i', function() harpoon:list():select(3) end, { buffer = true })
        map('n', 'd', 'dd', { buffer = true })
        map('n', 'q', ':wq<CR>', { buffer = true })
    end
})

-- lsp
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opt = { buffer = ev.buf }
        local telescope = require('telescope.builtin')
        map('n', 'gD', vim.lsp.buf.declaration, opt)
        map('n', 'gd', function() telescope.lsp_definitions({ jump_type = "vsplit" }) end, opt)
        map('n', 'E', vim.lsp.buf.hover, opt)
        map('n', 'gi', telescope.lsp_implementations, opt)
        map({ 'n', 'i' }, '<C-s>', vim.lsp.buf.signature_help, opt)
        map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opt)
        map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opt)
        map('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opt)
        map('n', '<space>D', vim.lsp.buf.type_definition, opt)
        map('n', '<space>rn', vim.lsp.buf.rename, opt)
        map({ 'n', 'v' }, '<space>va', vim.lsp.buf.code_action, opt)
        map('n', 'gr', telescope.lsp_references, opt)
    end,
})
