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

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    local opt = { buffer = ev.buf }
                    local telescope = require('telescope.builtin')
                    map('n', 'gD', vim.lsp.buf.declaration, opt)
                    map('n', 'gd', function() telescope.lsp_definitions({ jump_type = "vsplit" }) end, opt)
                    map('n', 'E', vim.lsp.buf.hover, opt)
                    map('n', 'gi', telescope.lsp_implementations, opt)
                    map({ 'n', 'i' }, '<C-s>', vim.lsp.buf.signature_help, opt)
                    map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opt)
                    map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opt)
                    map('n', '<space>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opt)
                    map('n', '<space>D', vim.lsp.buf.type_definition, opt)
                    map('n', '<space>rn', vim.lsp.buf.rename, opt)
                    map({ 'n', 'v' }, '<space>va', vim.lsp.buf.code_action, opt)
                    map('n', 'gr', telescope.lsp_references, opt)
                end,
            })
        end,
    },
    {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
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
