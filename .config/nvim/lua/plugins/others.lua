return {
    {
        "numToStr/Comment.nvim",
        opts = {
            toggler = {
                line = '<leader>c',
            },
            opleader = {
                line = '<leader>c',
            },
        },
        lazy = false,
    },
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
        enabled = true,
    },
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        enabled = false,
        opts = {},
    },
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
            { 'tpope/vim-dadbod',                     lazy = true },
            { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
        },
        cmd = {
            'DBUI',
            'DBUIToggle',
            'DBUIAddConnection',
            'DBUIFindBuffer',
        },
        init = function()
            -- Your DBUI configuration
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },
}
