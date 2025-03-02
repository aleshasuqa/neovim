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
                { name = "pyright" },
                { name = "clangd" },
                { name = "jsonls" },
                { name = "rust_analyzer" },
                { name = "lua_ls" },
                { name = "templ" },
                {
                    name = "tailwindcss",
                    setup = {
                        filetypes = { "templ", "astro", "javascript", "typescript", "react", "typescriptreact" },
                        settings = {
                            tailwindCSS = {
                                includeLanguages = {
                                    templ = "html",
                                },
                            },
                        },
                    }
                },
                { name = "ts_ls" },
                {
                    name = "html",
                    setup = {
                        filetypes = { "html", "templ" }
                    }
                },
                {
                    name = "htmx",
                    setup = {
                        filetypes = { "html", "templ" }
                    }
                },
                {
                    name = "gopls",
                    setup = {
                        cmd = { "/home/asq/go/bin/gopls" },
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
                },
                { name = "bashls" },
                { name = "yamlls" },
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
                if lsp.setup then
                    lspconfig[lsp.name].setup(lsp.setup)
                else
                    lspconfig[lsp.name].setup {}
                end
            end
        end,
    }
}
