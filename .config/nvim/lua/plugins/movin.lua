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
            { 'nvim-lua/plenary.nvim' }
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
                        '.git',
                        'venv'
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
        end,

        keys = {
            {
                '<C-f>',
                function()
                    require('telescope.builtin').find_files({
                        hidden = true,
                        layout_config = {
                            width = 0.9,
                            height = 0.9
                        }
                    })
                end
            },
            {
                '<leader>fg',
                function()
                    require('telescope.builtin').live_grep({
                        layout_strategy = 'vertical',
                        layout_config = {
                            mirror = true,
                            preview_cutoff = 1,
                            width = 0.8,
                            height = 0.99
                        },
                        additional_args = { '--hidden' }
                    })
                end
            },
            {
                '<leader>fh',
                function()
                    require('telescope.builtin').help_tags({
                        layout_strategy = 'vertical',
                        layout_config = {
                            mirror = true,
                            preview_cutoff = 1,
                            width = 0.5,
                            height = 0.99
                        }
                    })
                end
            },

            {
                "<leader>vs",
                function()
                    vim.cmd(":vsplit<CR>")
                    require('telescope.builtin').find_files({ hidden = true })
                end
            },
            {
                "<leader>hs",
                function()
                    vim.cmd(":split<CR>")
                    require('telescope.builtin').find_files({ hidden = true })
                end
            },
            { '<leader>q', require('telescope.builtin').quickfix }
        }
    },
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        lazy = false,
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
    },
    {
        "ggandor/leap.nvim",
        enabled = true,
        keys = {
            { "s",  mode = { "n", "x", "o" }, desc = "Leap forward to" },
            { "S",  mode = { "n", "x", "o" }, desc = "Leap backward to" },
            { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
        },
        config = function(_, opts)
            local leap = require("leap")
            for k, v in pairs(opts) do
                leap.opts[k] = v
            end
            leap.add_default_mappings(true)
            vim.keymap.del({ "x", "o" }, "x")
            vim.keymap.del({ "x", "o" }, "X")
        end,
    },
}
