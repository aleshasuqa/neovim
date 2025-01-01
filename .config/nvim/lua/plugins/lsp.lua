local servers = {
    hyprls = { enabled = false, config = {} },
    gopls = { enabled = false, config = {} },
    clangd = { enabled = false, config = {} },
    rust_analyzer = { enabled = false, config = {} },
    templ = { enabled = false, config = {} },

    htmx = {
        enabled = false,
        config = {
            filetypes = { "html", "templ" }
        }
    },

    pylsp = { enabled = true, config = {} },
    jsonls = { enabled = true, config = {} },
    lua_ls = { enabled = true, config = {} },
    bashls = { enabled = true, config = {} },
    yamlls = { enabled = true, config = {} },
    ts_ls = { enabled = true, config = {} },

    tailwindcss = {
        enabled = true,
        config = {
            filetypes = { "templ", "astro", "javascript", "typescript", "react" },
            settings = {
                tailwindCSS = {
                    includeLanguages = {
                        templ = "html",
                    },
                },
            },
        }
    },
    html = {
        enabled = true,
        config = {
            filetypes = { "html", "templ" },
        }
    },
    apex_ls = {
        enabled = true,
        config = {
            filetypes = { 'apex', 'apexcode', 'apexc', 'cls', 'trigger', 'soql' },
        }
    },
}

return {
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },
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
            local handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {}
                end,
            }
            local lspconfig = require('lspconfig')

            for k, v in pairs(servers) do
                if v.enabled and v.config ~= {} then
                    handlers[k] = function()
                        lspconfig[k].setup(v.config)
                    end
                end
            end

            local names = {}
            for k, v in pairs(servers) do
                if v.enabled then
                    table.insert(names, k)
                end
            end

            local caps = require('cmp_nvim_lsp').default_capabilities()

            require('mason-lspconfig').setup({
                ensure_installed = names,
                capabilities = caps,
                handlers = handlers
            })
        end,
    }
}
