local vim = vim
local map = vim.keymap.set

map('n', '<leader>h', ':noh<CR>', { silent = true })

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "<leader>wq", ":wq<CR>")
-- map("n", "<C-u>", "<C-u>zz")
-- map("n", "<C-d>", "<C-d>zz")

map("x", "p", '"_dP')
map("i", "<C-c>", "<Esc>")
map("n", "<leader>k", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left><Left>]])

map("n", "<leader>e", vim.cmd.Ex)
map("n", "<leader>vs", function()
    vim.cmd(":vsplit<CR>")
    require('telescope.builtin').find_files({ hidden = true })
end)
map("n", "<leader>hs", function()
    vim.cmd(":split<CR>")
    require('telescope.builtin').find_files({ hidden = true })
end)
map("n", "<leader>so", ":source ~/.config/nvim/init.lua<CR>", { silent = true })



-- ===== lsp =====
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = ev.buf }
        local telescope = require('telescope.builtin')
        map('n', 'gD', vim.lsp.buf.declaration, opts)
        map('n', 'gd', function() telescope.lsp_definitions({ jump_type = "vsplit" }) end, opts)
        map('n', 'E', vim.lsp.buf.hover, opts)
        map('n', 'gi', telescope.lsp_implementations, opts)
        map({'n', 'i'}, '<C-s>', vim.lsp.buf.signature_help, opts)
        map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        map('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        map('n', '<space>D', vim.lsp.buf.type_definition, opts)
        map('n', '<space>rn', vim.lsp.buf.rename, opts)
        map({ 'n', 'v' }, '<space>va', vim.lsp.buf.code_action, opts)
        map('n', 'gr', telescope.lsp_references, opts)
        map('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})


-- ===== telescope =====
local builtin = require('telescope.builtin')
map('n', '<C-f>', function()
    builtin.find_files({
        hidden = true,
        layout_config = {
            width = 0.9,
            height = 0.9
        }
    })
end, {})
map('n', '<leader>fg', function()
    builtin.live_grep({
        layout_strategy = 'vertical',
        layout_config = {
            mirror = true,
            preview_cutoff = 1,
            width = 0.8,
            height = 0.99
        },
        additional_args = { '--hidden' }
    })
end, {})
map('n', '<leader>fh', function()
    builtin.help_tags({
        layout_strategy = 'vertical',
        layout_config = {
            mirror = true,
            preview_cutoff = 1,
            width = 0.5,
            height = 0.99
        }
    })
end, {})

