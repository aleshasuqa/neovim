local vim = vim


function merge(t1, t2)
    for k, v in pairs(t2) do
        if (type(v) == "table") and (type(t1[k] or false) == "table") then
            merge(t1[k], t2[k])
        else
            t1[k] = v
        end
    end
    return t1
end

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
        "thesimonho/kanagawa-paper.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            require('kanagawa-paper').setup({
                transparent = true,
            })
        end
    },
    {
        'sainnhe/gruvbox-material',
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_background = 'hard'
            vim.g.gruvbox_material_transparent_background = 1
            vim.cmd.colorscheme('gruvbox-material')
        end
    },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        opts = {},
        config = function()
            require("gruvbox").setup({
                transparent_mode = true,
            })
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
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
            require("rose-pine").setup({
                styles = {
                    bold = true,
                    italic = false,
                    transparency = true,
                },
            })
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function(_, opts)
            -- local colors = dofile(os.getenv('HOME') .. '/.config/colors/colors.lua')
            local gruvbox = require 'lualine.themes.gruvbox-material'

            local function make_theme(theme)
                return {
                    normal = {
                        a = { fg = theme.normal.a.bg, bg = "none", gui = "bold" },
                        b = { fg = theme.insert.a.bg, bg = "none" },
                        c = { fg = theme.visual.a.bg, bg = "none" },
                    },
                    insert = {
                        a = { fg = theme.insert.a.bg, bg = "none", gui = "bold" },
                    },
                    visual = {
                        a = { fg = theme.visual.a.bg, bg = "none", gui = "bold" },
                    },
                    replace = {
                        a = { fg = theme.replace.a.bg, bg = "none", gui = "bold" },
                    },
                    command = {
                        a = { fg = theme.command.a.bg, bg = 'none', gui = 'bold' },
                    },
                    inactive = {
                        a = { fg = theme.inactive.a.fg, bg = "none", gui = "bold" },
                        b = { fg = theme.inactive.b.fg, bg = "none" },
                        c = { fg = theme.inactive.c.fg, bg = "none" },
                    },
                }
            end

            opts.options = {
                theme = make_theme(gruvbox),
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            }
            opts.sections = {
                lualine_z = { "location" },
            }
        end,
    },
}
