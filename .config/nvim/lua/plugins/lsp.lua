local vim = vim
local map = vim.keymap.set

local function lsp_servers()
    local servers = {
        { name = "pyright" },
        { name = "clangd" },
        { name = "jsonls" },
        { name = "rust_analyzer" },
        { name = "lua_ls" },
        { name = "templ" },
        { name = "gopls" },
        { name = "bashls" },
        { name = "yamlls" },
        { name = "ts_ls" },
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
    }

    local names = {}
    for i, s in pairs(servers) do
        names[i] = s.name
    end
    return servers, names
end

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
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        lazy = false,
        dependencies = {
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function(_, opts)
            local caps = require('blink.cmp').get_lsp_capabilities()

            local servers, names = lsp_servers()

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
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                rust = { "rustfmt", lsp_format = "fallback" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
            },
        },

        config = function(_, opts)
            vim.api.nvim_create_user_command("Format", function(args)
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = {
                        start = { args.line1, 0 },
                        ["end"] = { args.line2, end_line:len() },
                    }
                end
                require("conform").format({ async = true, lsp_format = "fallback", range = range })
            end, { range = true })
        end,

        keys = {
            { '<leader>f', '<cmd>Format<cr>' }
        }
    }
}
