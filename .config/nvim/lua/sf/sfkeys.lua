local vim = vim
local map = vim.keymap.set
local util = require('sf.util')

map('n', ';;',
    function()
        local cont = util.retrieve({'sf', 'sobject', 'list', '--json', '--sobject', 'all'}, 'AllObjects', false).result
        local p = {}
        for _, v in ipairs(cont) do
            table.insert(p, {
                name = v,
                action = function () end
            })
        end
        util.tele_cmd({
            name = 'Select sobject',
            picks = p,
            width = 40,
            telescope_opts = require('telescope.themes').get_cursor{layout_config = {width = 40}},
            mappings = function(prompt_bufnr, nmap)
                nmap('i', '<CR>', function()
                    local actions = require 'telescope.actions'
                    local action_state = require 'telescope.actions.state'
                    local selection = action_state.get_selected_entry(prompt_bufnr)
                    actions.close(prompt_bufnr)
                    vim.cmd('SFSObjectFields ' .. selection.value.name)
                end)
                return true
            end
        })
    end
)

map('n', '..', function ()
    vim.cmd('SFLogThis')
end)

map('v', '<leader>rc', function()
    local script = '/tmp/sf/tmp.apex'
    vim.fn.setreg('a', '')
    local cmd = vim.api.nvim_replace_termcodes("\"ay", true, false, true)
    vim.api.nvim_feedkeys(cmd, 'v', true)
    vim.schedule(function()
        local code = 'SavePoint sp = Database.setSavepoint();\n\n' .. vim.fn.getreg("a") .. '\nDatabase.rollback(sp);'
        local file = assert(io.open(script, 'w+'))
        file:write(code)
        io.close(file)
        -- util.open_float(150, 80)
        vim.cmd('split')
        vim.cmd(util.hl_debug('term sf apex run --file ' .. script))
    end)
end, {})

map('n', '<leader>rs', function()
    vim.fn.setreg('s', '')
    local cmd = vim.api.nvim_replace_termcodes("vl[\"sy<Esc>", true, false, true)
    vim.api.nvim_feedkeys(cmd, 'v', true)
    vim.schedule(function()
        local query = vim.fn.getreg('s')
        -- util.open_float(150, 80)
        vim.cmd('split')
        vim.cmd('term sf data query --query \"' .. query .. '\"')
    end)
end, {})

