-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local vim = vim

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', {}),
    pattern = '*',
    callback = function()
        vim.highlight.on_yank { higroup = 'IncSearch', timeout = 100 }
    end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = "*/waybar/*",
    callback = function()
        vim.cmd("silent exec \"!killall -SIGUSR2 waybar\"")
    end
})

