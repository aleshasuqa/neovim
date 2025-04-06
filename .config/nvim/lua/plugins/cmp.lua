return {
    -- {
    --     "zbirenbaum/copilot.lua",
    --     lazy = false,
    --     config = function()
    --         require("copilot").setup({
    --             suggestion = { enabled = false, auto_trigger = false },
    --             panel = { enabled = false },
    --         })
    --     end,
    -- },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {
                "zbirenbaum/copilot-cmp",
                config = function()
                    require("copilot_cmp").setup()
                end
            },
            {
                "L3MON4D3/LuaSnip",
                build = 'make install_jsregexp',
                dependencies = {
                    {
                        "rafamadriz/friendly-snippets",
                        config = function()
                            local ls = require('luasnip')
                            ls.filetype_extend('templ', { 'html' })
                            require("luasnip.loaders.from_vscode").lazy_load()
                        end,
                    },
                },
                opts = {
                    history = true,
                    delete_check_events = "TextChanged",
                },
                -- stylua: ignore

                keys = {
                    {
                        "<tab>",
                        function()
                            return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
                        end,
                        expr = true,
                        silent = true,
                        mode = "i",
                    },
                    { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
                    { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
                },
            },
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<CR>'] = cmp.mapping.confirm({ select = false })
                }),
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                sources = cmp.config.sources({
                    { name = 'copilot' },
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                })

            })
        end
    },

}
