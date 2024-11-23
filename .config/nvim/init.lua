-- bootstrap lazy.nvim, LazyVim and your plugins
local vim = vim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy")
require("config.autocmds")

-- vim.cmd('hi! LineNr guibg=bg')

-- Enable LazyVim auto format
vim.g.autoformat = true

vim.filetype.add({ extension = { templ = "templ" } })

-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

vim.g.netrw_bufsettings = 'noma nomod nu rnu nobl nowrap ro'

local opt = vim.opt

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

opt.clipboard = "unnamedplus"  -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2           -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true             -- Confirm to save changes before exiting modified buffer
opt.cursorline = true          -- Enable highlighting of the current line
opt.expandtab = true           -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true      -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3         -- global statusline
opt.list = true            -- Show some invisible characters (tabs...
opt.mouse = "a"            -- Enable mouse mode
opt.number = true          -- Print line number
opt.relativenumber = true  -- Relative line numbers
opt.scrolloff = 2          -- Lines of context
opt.shiftround = true      -- Round indent
opt.shortmess:append({ a = true, I = true, c = true, C = true })
opt.showmode = false       -- Dont show mode since we have a statusline
opt.sidescrolloff = 8      -- Columns of context
opt.signcolumn = "no"      -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true       -- Don't ignore case with capitals
opt.spelllang = { "en" }
opt.splitbelow = true      -- Put new windows below current
opt.splitright = true      -- Put new windows right of current
opt.termguicolors = true   -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200               -- Save swap file and trigger CursorHold
opt.virtualedit = "block"          -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5                -- Minimum window width
opt.wrap = false                   -- Disable line wrap
opt.fillchars = {
    foldopen = "",
    foldclose = "",
    -- fold = "⸱",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
}

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

require('cmp').setup.filetype({ "sql" }, {
    sources = {
        { name = 'vim-dadbod-completion' },
        { name = 'buffer' },
    }
})

vim.filetype.add({
    pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

vim.filetype.add({
    pattern = { [".*.rasi"] = "rasi" },
})

vim.cmd.colorscheme('everforest')
require('config.keymaps')
require('sf.sf')
