local vim = vim

-- local opts = {
--     split = 'v|h',
--     cmd = 'ls -la',
-- }

local M = {}

function M.send2split(opts)
    local panes = tonumber(select(2, vim.system({'tmux', 'list-panes'}, {text = true}):wait().stdout:gsub('\n', '\n')))
    local cmd = '\'' .. opts.cmd .. '\' ENTER'
    if panes > 1 then
        vim.cmd('silent !tmux send-keys -t {next} ' .. cmd)
    else
        local split = 'silent !tmux split-window -'
        local send = ' \\; send '
        vim.cmd(split .. opts.split .. send .. cmd)
    end
end

return M
