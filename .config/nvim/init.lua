local vim = vim

local gs = {
    mapleader = " ",
    maplocalleader = "\\",
    autoformat = true,
    markdown_recommended_style = 0,
    root_spec = { "lsp", { ".git", "lua" }, "cwd" },
}
for key, value in pairs(gs) do
    vim.g[key] = value
end

require("config.lazy")
require("config.autocmds")

local opts = {
    tabstop = 4,
    shiftwidth = 4,
    smartindent = true,
    clipboard = "unnamedplus",
    completeopt = "menu,menuone,noselect",
    conceallevel = 2,
    confirm = true,
    cursorline = true,
    expandtab = true,
    formatoptions = "jcroqlnt",
    grepformat = "%f:%l:%c:%m",
    grepprg = "rg --vimgrep",
    ignorecase = true,
    inccommand = "nosplit",
    laststatus = 3,
    list = true,
    mouse = "a",
    number = true,
    relativenumber = true,
    scrolloff = 2,
    shiftround = true,
    showmode = false,
    sidescrolloff = 8,
    signcolumn = "no",
    smartcase = true,
    spelllang = { "en" },
    splitbelow = true,
    splitright = true,
    termguicolors = true,
    timeoutlen = 300,
    undofile = true,
    undolevels = 10000,
    updatetime = 200,
    virtualedit = "block",
    wildmode = "longest:full,full",
    winminwidth = 5,
    wrap = false,
    fillchars = {
        foldopen = "",
        foldclose = "",
        fold = "⸱",
        foldsep = " ",
        diff = "╱",
        eob = " ",
    }
}
vim.opt.shortmess:append({ a = true, I = true, c = true, C = true })
for key, value in pairs(opts) do
    vim.opt[key] = value
end

vim.diagnostic.config({
    virtual_text = {
        source = "if_many",
        prefix = '',
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'if_many',
        header = '',
        prefix = '',
    },
})

vim.filetype.add({
    pattern = {
        [".*/hypr/.*%.conf"] = "hyprlang",
        [".*.rasi"] = "rasi"
    },
})

vim.cmd.colorscheme('gruvbox')
require('config.keymaps')
