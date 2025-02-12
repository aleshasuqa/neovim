return {
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        version = false,
        dependencies = {
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
            },
            {
                'nvim-lua/plenary.nvim',
            }
        },
        config = function()
            local telescope = require('telescope')
            local actions = require('telescope.actions')
            telescope.setup {
                defaults = {
                    mappings = {
                        i = {
                            ['<esc>'] = actions.close,
                            ['<C-j>'] = actions.move_selection_next,
                            ['<C-k>'] = actions.move_selection_previous,
                            ['<Tab>'] = actions.toggle_selection,
                        }
                    },
                    file_ignore_patterns = {
                        'node_modules',
                        '.git'
                    }
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = 'smart_case',
                    },
                }
            }
            telescope.load_extension('fzf')
        end
    },
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local harpoon = require('harpoon')
            local map = vim.keymap.set

            harpoon:setup()
            map('n', '<leader>a', function() harpoon:list():add() end)
            map('n', 't', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        end,
        keys = {
            { 't', function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, ft = 'netrw' },
            { 'r', function() require('harpoon'):list():select(1) end,                                ft = 'harpoon' },
            { 'e', function() require('harpoon'):list():select(2) end,                                ft = 'harpoon' },
            { 'w', function() require('harpoon'):list():select(3) end,                                ft = 'harpoon' },
            { 'd', 'dd',                                                                              ft = 'harpoon' },
            { 'q', ':wq<CR>',                                                                         ft = 'harpoon' }
        }
    }
}
