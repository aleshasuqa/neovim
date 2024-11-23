return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        version = false,
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            {
                'nvim-lua/plenary.nvim',
            }
        },
        config = function()
            local telescope = require("telescope")
            local actions = require('telescope.actions')
            telescope.setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<esc>"] = actions.close,
                            ["<C-p>"] = false,
                            ["<C-e>"] = actions.move_selection_previous,
                            ["<Tab>"] = actions.toggle_selection,
                        }
                    },
                    file_ignore_patterns = {
                        "node_modules",
                        ".git"
                    }
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                }
            }
            telescope.load_extension("fzf")
        end
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    }
}
