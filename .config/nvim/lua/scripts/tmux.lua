local vim = vim

local function openSplit(split)
    vim.cmd('!tmux split-window -'..split)
end

vim.keymap.set('n', 'mm', function ()
    openSplit('v')
end)
