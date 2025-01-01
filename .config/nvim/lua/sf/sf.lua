local vim = vim
local map = vim.keymap.set
local util = require('sf.util')

local commands = {
    {
        name = 'open org',
        action = function() vim.cmd('SFOpenOrg') end
    },
    {
        name = 'dev console',
        action = function() vim.cmd('SFDevConsole') end
    },
    {
        name = 'login',
        action = function() vim.cmd('SFLogin') end
    },
    {
        name = 'login sandbox',
        action = function() vim.cmd('SFLoginSandbox') end
    },
    {
        name = 'deploy force-app',
        action = function() vim.cmd('SFDeploy') end
    },
    {
        name = 'deploy this',
        action = function() vim.cmd('SFDeployThis') end
    },
    {
        name = 'deploy select',
        action = function() vim.cmd('SFDeploySelect') end
    },
    {
        name = 'retrieve force-app',
        action = function() vim.cmd('SFRetrieve') end
    },
    {
        name = 'org browser',
        action = function() vim.cmd('SFOrgBrowser') end
    },
    {
        name = 'test class',
        action = function()
            vim.cmd('SFTestClass')
        end
    },
    {
        name = 'test method',
        action = function() vim.cmd('SFTestMethod') end
    },
    {
        name = 'get logs',
        action = function() vim.cmd('SFGetLogs') end
    },
    {
        name = 'create class',
        action = function()
            local class = vim.fn.input('Class name: ')
            vim.cmd('SFCreateClass ' .. class)
        end
    },
    {
        name = 'create trigger',
        action = function()
            local trigger = vim.fn.input('Trigger name: ')
            local sobject = vim.fn.input('SObjct: ')
            vim.cmd('SFCreateTrigger ' .. trigger .. ' ' .. sobject)
        end
    },
    {
        name = 'create lwc',
        action = function()
            local lwc = vim.fn.input('LWC name: ')
            vim.cmd('SFCreateLWC ' .. lwc)
        end
    },
    {
        name = 'set org',
        action = function() vim.cmd('SFSetOrg') end
    },
}


local function getCurOrg()
    local cmd_out = vim.system({ 'sf', 'config', 'list', '--json' },
        { text = true }):wait().stdout
    local res = vim.json.decode(cmd_out).result
    for _, v in ipairs(res) do
        print(v.name)
        if v.name == 'target-org' then
            return v.value
        end
    end
end

map({'n', 'v'}, "<leader>ss", function ()
    util.tele_cmd({
        name = 'SF (' .. getCurOrg() .. ')',
        picks = commands,
        width = 40,
        telescope_opts = require("telescope.themes").get_dropdown{layout_config = {width = 40}},
        mappings = function(prompt_bufnr, nmap)
            nmap('i', '<CR>', function()
                require('telescope.actions').close(prompt_bufnr)
                local selection = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
                selection.value.action()
            end)
            return true
        end
    })
end)

require('sf.commands')
require('sf.sfkeys')
