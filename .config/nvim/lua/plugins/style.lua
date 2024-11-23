local vim = vim

return {
    {
        'sainnhe/everforest',
        lazy = false,
        priority = 1000,
        config = function()
            -- Optionally configure and load the colorscheme
            -- directly inside the plugin declaration.
            vim.g.everforest_transparent_background = 1
            vim.g.everforest_background = 'hard'
        end
    },
    {
        'AlexvZyl/nordic.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            local nordic = require('nordic')
            nordic.setup({
                italic_comments = false,
                transparent = {
                    bg = true,
                    float = false,
                }
            })
        end
    },
    {
        "gbprod/nord.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("nord").setup({
                transparent = true,
                styles = {
                    comments = { italic = false },
                    keywords = { bold = true },
                    functions = { bold = true },
                    variables = {},
                }
            })
        end,
    },
    {
        "rebelot/kanagawa.nvim",
        priority = 1001,
        config = function()
            require('kanagawa').setup {
                commentStyle = { italic = false },
                keywordStyle = { italic = false },
                statementStyle = { bold = false },
                undercurl = false,
                transparent = true,
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none",
                            },
                        },
                    },
                },
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        Boolean = { bold = false },
                        TelescopeTitle = { fg = theme.ui.special, bold = true },
                        TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                        TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                        TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                        TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                        TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                        TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
                    }
                end,
            }
            vim.cmd('colorscheme kanagawa')
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function(_, opts)
            local colors = dofile(os.getenv('HOME') .. '/.config/colors/colors.lua')

            local theme = {
                normal = {
                    a = { fg = colors.cyan, bg = "none", gui = "bold" },
                    b = { fg = colors.green, bg = "none" }, --colors.kanagawa.menu_grey },
                    c = { fg = colors.cyan, bg = "none" },    --colors.kanagawa.black },
                },
                insert = {
                    a = { fg = colors.red, bg = "none", gui = "bold" },
                },
                visual = {
                    a = { fg = colors.magenta, bg = "none", gui = "bold" },
                },
                replace = {
                    a = { fg = colors.blue, bg = "none", gui = "bold" },
                },
                inactive = {
                    a = { fg = colors.white, bg = "none", gui = "bold" },
                    b = { fg = colors.black, bg = "none" }, --colors.kanagawa.menu_grey },
                    c = { fg = colors.black, bg = "none" }, --colors.kanagawa.menu_grey },
                },
            }
            opts.options = {
                theme = theme,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            }
            opts.sections = {
                lualine_z = { "location" },
            }
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {
            indent = {
                char = "╎",
                tab_char = "╎",
            },
            scope = { enabled = false },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
            },
        },
    },
    {
        "echasnovski/mini.indentscope",
        version = false,
        opts = function(_, opts)
            local indent = require("mini.indentscope")
            opts.delay = 0
            opts.symbol = "╎"
            opts.options = { try_as_border = true }
            opts.draw = { animation = indent.gen_animation.none() }
        end,
    }
}
