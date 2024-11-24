local vim = vim

-- local opts = {
--     split = 'v|h',
--     cmd = 'ls -la',
-- }

local M = {}

function M.send2split(opts)
    local split = 'silent !tmux split-window -'
    local send = ' \\; send \''
    local enter = '\' ENTER'
    vim.cmd(split .. opts.split .. send .. opts.cmd .. enter)
end

return M
