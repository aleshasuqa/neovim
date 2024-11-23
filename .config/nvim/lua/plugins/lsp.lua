return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "css", "rust", "python", "apex", "soql" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
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
                    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
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
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                }, {
                    { name = 'buffer' },
                })
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        lazy = false,
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function(_, opts)
            local servers = {
                { name = "pylsp",         custom = false },
                -- { name = "clangd",        custom = false },
                -- { name = "jsonls",        custom = false },
                -- { name = "rust_analyzer", custom = false },
                { name = "lua_ls",        custom = false },
                -- { name = "templ",         custom = false },
                -- { name = "tailwindcss",   custom = true },
                -- { name = "ts_ls",         custom = false },
                { name = "html",          custom = true },
                -- { name = "htmx",          custom = true },
                -- { name = "gopls",         custom = true },
                { name = "bashls", custom = false },
                { name = "hyprls", custom = false },
                { name = "yamlls", custom = false },
            }
            local names = {}
            for i, s in pairs(servers) do
                names[i] = s.name
            end
            local caps = require('cmp_nvim_lsp').default_capabilities()

            require('mason-lspconfig').setup({
                ensure_installed = names,
                capabilities = caps,
            })



            local lspconfig = require('lspconfig')
            for _, lsp in ipairs(servers) do
                if lsp.custom == false then
                    lspconfig[lsp.name].setup {}
                end
            end
            lspconfig.gopls.setup {
                cmd = {"/home/asq/go/bin/gopls"},
                on_attach = function(client, bufnr)
                    if not client.server_capabilities.semanticTokensProvider then
                        local semantic = client.config.capabilities.textDocument.semanticTokens
                        client.server_capabilities.semanticTokensProvider = {
                            full = true,
                            legend = {
                                tokenTypes = semantic.tokenTypes,
                                tokenModifiers = semantic.tokenModifiers,
                            },
                            range = true,
                        }
                    end
                end,
                filetypes = { "go", "gomod", "gowork", "gotmpl", "templ" },
                settings = {
                    gopls = {
                        completeUnimported = true,
                        usePlaceholders = true,
                        staticcheck = true,
                        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                        semanticTokens = true,
                        gofumpt = true,
                        codelenses = {
                            gc_details = false,
                            generate = true,
                            regenerate_cgo = true,
                            run_govulncheck = true,
                            test = true,
                            tidy = true,
                            upgrade_dependency = true,
                            vendor = true,
                        },
                        analyses = {
                            fieldalignment = true,
                            nilness = true,
                            unusedparams = true,
                            unusedwrite = true,
                            useany = true,
                        },
                    },
                },
            }
            lspconfig.tailwindcss.setup {
                filetypes = { "templ", "astro", "javascript", "typescript", "react" },
                settings = {
                    tailwindCSS = {
                        includeLanguages = {
                            templ = "html",
                        },
                    },
                },
            }
            lspconfig.html.setup {
                filetypes = { "html", "templ" }
            }
            lspconfig.htmx.setup {
                filetypes = { "html", "templ" }
            }
            lspconfig.cssls.setup{
                capabilities = caps,
            }
        end,
    }
}
