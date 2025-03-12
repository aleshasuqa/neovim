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
        -- keys = {
        --     { "<C-Left>",  "<cmd>TmuxNavigateLeft<cr>" },
        --     { "<C-Down>",  "<cmd>TmuxNavigateDown<cr>" },
        --     { "<C-Up>",  "<cmd>TmuxNavigateUp<cr>" },
        --     { "<C-Right>",  "<cmd>TmuxNavigateRight<cr>" },
        --     { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
        -- }
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
    {
        "karb94/neoscroll.nvim",
        lazy = false,
        opts = {
            duration_multiplier = 0.4,
        }
    },
}
