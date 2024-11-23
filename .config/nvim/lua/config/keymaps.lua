-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local vim = vim
local map = vim.keymap.set

-- ===== colemak =====
local function swap(lhs, rhs)
    map('', lhs, rhs, { noremap = true })
    map('', rhs, lhs, { noremap = true })
    map('', string.upper(lhs), string.upper(rhs), { noremap = true })
    map('', string.upper(rhs), string.upper(lhs), { noremap = true })
end

swap("n", "j")
swap("e", "k")
swap("i", "l")

map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
map("n", "<C-e>", "<cmd>TmuxNavigateUp<cr>")
map("n", "<C-n>", "<cmd>TmuxNavigateDown<cr>")
map("n", "<C-i>", "<cmd>TmuxNavigateRight<cr>")


-- ===== goodies =====
map('n', '<leader>nh', ':noh<CR>', { silent = true })

map("v", "N", ":m '>+1<CR>gv=gv")
map("v", "E", ":m '<-2<CR>gv=gv")

map("n", "<C-l>", "<C-u>zz")
map("n", "<C-m>", "<C-d>zz")

map("x", "p", '"_dP')
map("i", "<C-c>", "<Esc>")
map("n", "<leader>k", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left><Left>]])

map("n", "<leader>e", vim.cmd.Ex)
map("n", "<leader>wq", ":wq<CR>")
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
        map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
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

local harpoon = require('harpoon')
harpoon:setup({})
map("n", "<leader>a", function() harpoon:list():add() end)
map("n", "<leader>d", function() harpoon:list():clear() end)

local get_paths = function()
    local files = harpoon:list()
    local paths = {}
    for _, item in ipairs(files.items) do
        table.insert(paths, item.value)
    end
    return paths
end

map("n", "<C-t>", function()
    local Menu = require("snipe.menu")
    local menu = Menu:new {
        position = "center",
        open_win_override = {
            title = "",
        },
    }
    local items = get_paths()
    if #items == 0 then
        print('no tabs saved')
        return
    end
    menu:add_new_buffer_callback(function(m)
        map("n", "<esc>", function()
            m:close()
        end, { nowait = true, buffer = m.buf })

        map("n", "q", function()
            m:close()
        end, { nowait = true, buffer = m.buf })

        map("n", "<C-d>", function()
            harpoon:list():remove_at(m:hovered())
            m.items = get_paths()
            m:reopen()
        end, { nowait = true, buffer = m.buf })
    end)


    local _, cur = harpoon:list():get_by_value(vim.fn.expand("%"))
    print(cur)
    menu:open(items, function(m, i)
        m:close()
        harpoon:list():select(i)
    end, function(item)
        local path = item

        local file_name = ""
        for part in path:gmatch("([^/]+)") do
            file_name = part
        end
        return file_name
    end, cur or 1
    )
end)
