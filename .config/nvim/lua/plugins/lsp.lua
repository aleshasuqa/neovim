local map = vim.keymap.set
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
    },
    {
        "scalameta/nvim-metals",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "j-hui/fidget.nvim",
                opts = {},
            },
            {
                "mfussenegger/nvim-dap",
                config = function(self, opts)
                    -- Debug settings if you're using nvim-dap
                    local dap = require("dap")

                    dap.configurations.scala = {
                        {
                            type = "scala",
                            request = "launch",
                            name = "RunOrTest",
                            metals = {
                                runType = "runOrTestFile",
                                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
                            },
                        },
                        {
                            type = "scala",
                            request = "launch",
                            name = "Test Target",
                            metals = {
                                runType = "testTarget",
                            },
                        },
                    }
                end
            },
        },
        ft = { "scala", "sbt", "java" },
        opts = function()
            local metals_config = require("metals").bare_config()

            -- Example of settings
            metals_config.settings = {
                showImplicitArguments = true,
                excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
            }

            -- *READ THIS*
            -- I *highly* recommend setting statusBarProvider to either "off" or "on"
            --
            -- "off" will enable LSP progress notifications by Metals and you'll need
            -- to ensure you have a plugin like fidget.nvim installed to handle them.
            --
            -- "on" will enable the custom Metals status extension and you *have* to have
            -- a have settings to capture this in your statusline or else you'll not see
            -- any messages from metals. There is more info in the help docs about this
            metals_config.init_options.statusBarProvider = "off"

            -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
            metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

            metals_config.on_attach = function(client, bufnr)
                require("metals").setup_dap()

                -- LSP mappings
                map("n", "gD", vim.lsp.buf.definition)
                map("n", "E", vim.lsp.buf.hover)
                map("n", "gi", vim.lsp.buf.implementation)
                map("n", "gr", vim.lsp.buf.references)
                map("n", "gds", vim.lsp.buf.document_symbol)
                map("n", "gws", vim.lsp.buf.workspace_symbol)
                map("n", "<leader>cl", vim.lsp.codelens.run)
                map("n", "<leader>sh", vim.lsp.buf.signature_help)
                map("n", "<leader>rn", vim.lsp.buf.rename)
                map("n", "<leader>f", vim.lsp.buf.format)
                map("n", "<leader>ca", vim.lsp.buf.code_action)

                map("n", "<leader>ws", function()
                    require("metals").hover_worksheet()
                end)

                -- all workspace diagnostics
                map("n", "<leader>aa", vim.diagnostic.setqflist)

                -- all workspace errors
                map("n", "<leader>ae", function()
                    vim.diagnostic.setqflist({ severity = "E" })
                end)

                -- all workspace warnings
                map("n", "<leader>aw", function()
                    vim.diagnostic.setqflist({ severity = "W" })
                end)

                -- buffer diagnostics only
                map("n", "<leader>d", vim.diagnostic.setloclist)

                map("n", "[c", function()
                    vim.diagnostic.goto_prev({ wrap = false })
                end)

                map("n", "]c", function()
                    vim.diagnostic.goto_next({ wrap = false })
                end)

                -- Example mappings for usage with nvim-dap. If you don't use that, you can
                -- skip these
                map("n", "<leader>dc", function()
                    require("dap").continue()
                end)

                map("n", "<leader>dr", function()
                    require("dap").repl.toggle()
                end)

                map("n", "<leader>dK", function()
                    require("dap.ui.widgets").hover()
                end)

                map("n", "<leader>dt", function()
                    require("dap").toggle_breakpoint()
                end)

                map("n", "<leader>dso", function()
                    require("dap").step_over()
                end)

                map("n", "<leader>dsi", function()
                    require("dap").step_into()
                end)

                map("n", "<leader>dl", function()
                    require("dap").run_last()
                end)
            end

            return metals_config
        end,
        config = function(self, metals_config)
            local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = self.ft,
                callback = function()
                    require("metals").initialize_or_attach(metals_config)
                end,
                group = nvim_metals_group,
            })
        end

    }
}
