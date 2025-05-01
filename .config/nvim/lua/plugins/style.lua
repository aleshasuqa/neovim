local vim = vim

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

return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        opts = {},
        config = function()
            require("gruvbox").setup({
                transparent_mode = true,
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
            })
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function(_, opts)
            opts.options = {
                theme = make_theme(require 'lualine.themes.gruvbox'),
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            }
            opts.sections = {
                lualine_z = { "location" },
            }
        end,
    },
}
