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
        end,
        keys = {
        }
    },
    {
        "ggandor/leap.nvim",
        enabled = true,
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
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
            view_options = {
                show_hidden = false,
                is_hidden_file = function(name, bufnr)
                    return false
                end,
            }
        },
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        lazy = false,
    },
    { 'mrjones2014/smart-splits.nvim' },
}
