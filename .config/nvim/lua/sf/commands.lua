local vim = vim
local util = require('sf.util')

local command = vim.api.nvim_create_user_command
local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)

command('SFLogThis',
    function ()
    local date = os.date("*t")
    local tmpFile = '/tmp/sf_log/' .. date.day .. '.'
    .. date.month .. '_'
    .. date.hour .. ':'
    .. date.min .. ':'
    .. date.sec .. '.txt'
    local file = assert(io.open(tmpFile, "w+"))
    local cont = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    file:write(table.concat(cont, "\n"))
end, {})

local ex = vim.fn.expand

command('SFRun', function ()
    local file = ex('%:p')
    -- util.open_float(150, 35)
    vim.cmd('split')
    vim.cmd(util.hl_debug('term sf apex run --file ' .. file))
end, {})

command('SFQuery', function ()
    local file = ex('%:p')
    vim.cmd('split')
    vim.cmd('term sf data query --file ' .. file)
end, {})

command('SFSObjectFields', function (args)
    local class = args.fargs[1]

    local cont = util.retrieve({'sf', 'sobject', 'describe', '--sobject', class}, class, false)
    local desc = cont.fields
    local fields = {}
    for _, v in ipairs(desc) do
        table.insert(fields,
            {
                name = v.name,
                action = function() end
            }
        )
    end

    local selected = {}

    util.tele_cmd({
        name = class .. ' fields',
        picks = fields,
        width = 40,
        telescope_opts = require("telescope.themes").get_cursor{layout_config = {width = 40}},
        mappings = function(prompt_bufnr, map)
            map('i', '<CR>', function()
                local actions = require 'telescope.actions'
                local action_utils = require "telescope.actions.utils"
                action_utils.map_selections(prompt_bufnr, function(entry, _)
                    table.insert(selected, entry.value.name)
                end)
                actions.close(prompt_bufnr)
                local cmd = "a"
                for i, v in ipairs(selected) do
                    cmd = cmd .. v
                    if i ~= #selected then
                        cmd = cmd .. ', '
                    end
                end
                cmd = cmd .. ' ' .. vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
                vim.api.nvim_feedkeys(cmd, 'n', true)
            end)
            return true
        end})
end, { nargs = 1 })

command('SFOpenOrg', function ()
    util.open_float(80, 5)
    vim.cmd('term sf org open')
end, {})

command('SFLogin', function ()
    util.open_float(80, 5)
    vim.cmd('term sf org login web --set-default')
end, {})

command('SFLoginSandbox', function ()
    util.open_float(80, 5)
    vim.cmd('term SF_USE_GENERIC_UNIX_KEYCHAIN=true sf org login web --set-default -r https://test.salesforce.com')
end, {})

command('SFTestClass', function ()
    local class = ex('%:t:r')
    vim.cmd('split')
    vim.cmd('term echo Running tests ...')
    local cmd_out = vim.system({'sf', 'apex', 'run', 'test', '-c', '-v', '--json', '-n', class}, {text = true}):wait().stdout
    local id = vim.json.decode(cmd_out).result.testRunId
    local msg = 'echo Running tests ...'
    local out = 'sf apex get test -c -i ' .. id .. util.hl_word('Pass', '32') .. util.hl_word('Fail', '31')
    -- local log = 'sf apex get log --number 1'
    util.term({msg, out})
end, {})

command('SFTestMethod', function ()
    local class = ex('%:t:r')
    vim.api.nvim_feedkeys("?isTest" .. cr .. "/(" .. cr .. "h", 'n', true)
    vim.schedule(function ()
        local method = ex('<cword>')
        vim.cmd('noh')
        vim.cmd('split')
        -- util.open_float(150, 35)
        local msg = 'echo Running test ...'
        local cmd_out = vim.system({'sf', 'apex', 'run', 'test', '-c', '-v', '--json', '-t', class .. '.' .. method}, {text = true}):wait().stdout
        local id = vim.json.decode(cmd_out).result.testRunId
        local out = 'sf apex get test -c -i ' .. id .. util.hl_word('Pass', '32') .. util.hl_word('Fail', '31')
        local log = 'sf apex get log --number 1'
        util.term({msg, out, log})
    end)
end, {})

command('SFDeploy', function ()
    local root = vim.lsp.get_active_clients()[1].config.cmd_cwd
    util.open_float(150, 35)
    local cmd = 'term sf project deploy start --source-dir ' .. root .. '/force-app'
    vim.cmd(cmd)
end, {})

command('SFDeploySelect', function ()
    local dir = vim.lsp.get_active_clients()[1].config.cmd_cwd .. '/force-app/main/default/classes'
    local files = vim.system({'ls', dir}, {text = true}):wait()
    local picks = {}
    for f in string.gmatch(files.stdout, '(.-)\n') do
        local sp = util.split(f, '.')
        if #sp == 2 and sp[2] == 'cls' then
            table.insert(picks,
                {
                    name = sp[1],
                    action = function() end
                }
            )
        end
    end
    local selected = {}
    util.tele_cmd({
        name = 'Classe',
        picks = picks,
        width = 30,
        telescope_opts = require("telescope.themes").get_dropdown{layout_config = {width = 30}},
        mappings = function(prompt_bufnr, map)
            map('i', '<CR>', function()
                local actions = require 'telescope.actions'
                local action_utils = require "telescope.actions.utils"
                action_utils.map_selections(prompt_bufnr, function(entry, _)
                    table.insert(selected, '--metadata=ApexClass:' .. entry.value.name)
                end)
                actions.close(prompt_bufnr)
                -- cmd = cmd .. ' ' .. vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
                -- vim.api.nvim_feedkeys(cmd, 'n', true)
                util.open_float(150, 35)
                local cmd = 'term sf project deploy start ' .. table.concat(selected, ' ')
                vim.cmd(cmd)
            end)
            return true
        end})
end, {})

command('SFDeployThis', function ()
    local class = ex('%:t:r')
    util.open_float(150, 35)
    local cmd = 'term sf project deploy start --metadata \'ApexClass:' .. class .. '*\''
    vim.cmd(cmd)
end, {})

command('SFGetLogs', function ()
    vim.cmd('split')
    vim.cmd('term sf apex get log --number 1')
end, {})

command('SFRetrieve', function ()
    local root = vim.lsp.get_active_clients()[1].config.cmd_cwd
    util.open_float(150, 35)
    local cmd = 'term sf project retrieve start --source-dir ' .. root .. '/force-app'
    vim.cmd(cmd)
end, {})

command('SFOrgBrowser', function ()
    local mdts = util.retrieve({'sf', 'org', 'list', 'metadata-types', '--json'}, 'MDTypes', false).result.metadataObjects
    local mdt_picks = {}
    for _, v in ipairs(mdts) do
        table.insert(mdt_picks, {
            name = v.xmlName,
            action = function() end
        })
    end
    local mdt_selected = {}
    local all = false
    util.tele_cmd({
        name = 'Metadata-types',
        picks = mdt_picks,
        width = 30,
        telescope_opts = require("telescope.themes").get_dropdown{layout_config = {width = 30}},
        mappings = function(prompt_bufnr, map)
            map('i', '<CR>', function()
                local actions = require 'telescope.actions'
                local action_utils = require "telescope.actions.utils"
                action_utils.map_selections(prompt_bufnr, function(entry, _)
                    table.insert(mdt_selected, entry.value.name)
                end)
                if #mdt_selected == 0 then
                    local action_state = require 'telescope.actions.state'
                    local selection = action_state.get_selected_entry(prompt_bufnr)
                    table.insert(mdt_selected, selection.value.name)
                else
                    all = true
                end

                actions.close(prompt_bufnr)

                if all then
                    local cmds = {}
                    for _, v in ipairs(mdt_selected) do
                        print(v)
                        table.insert(cmds, 'sf project retrieve start --metadata=' .. v)
                    end
                    util.open_float(150, 35)
                    print(vim.inspect(cmds))
                    -- vim.cmd('term bash -c \'' .. table.concat(cmds, ';') .. '\'')
                    util.term(cmds)
                else
                    print('start retrive' .. vim.inspect(mdt_selected))
                    local md = util.retrieve({'sf', 'org', 'list', 'metadata', '--metadata-type', mdt_selected[1], '--json'}, mdt_selected[1], false)
                    print('end retrive')
                    local data = md.result

                    if data == nil then
                        print('Nothing of this type exists')
                        return
                    end

                    local md_picks = {}
                    for _, v in ipairs(data) do
                        table.insert(md_picks, {
                            name = v.fullName,
                            action = function() end
                        })
                    end

                    local data_selected = {}
                    util.tele_cmd({
                        name = 'Metadata',
                        picks = md_picks,
                        width = 30,
                        telescope_opts = require("telescope.themes").get_dropdown{layout_config = {width = 30}},
                        mappings = function(nprompt_bufnr, nmap)
                            nmap('i', '<CR>', function()
                                action_utils.map_selections(nprompt_bufnr, function(entry, _)
                                    table.insert(data_selected, '--metadata=' .. mdt_selected[1] .. ':' .. entry.value.name)
                                end)
                                actions.close(nprompt_bufnr)
                                util.open_float(150, 35)
                                local cmd = 'term sf project retrieve start ' .. table.concat(data_selected, ' ')
                                vim.cmd(cmd)
                            end)
                            return true
                        end})
                end
            end)
            return true
        end})
end, {})

command('SFCreateClass', function (args)
    local root = vim.lsp.get_active_clients()[1].config.cmd_cwd
    local class = args.fargs[1]
    local cmd = '!sf apex generate class --name ' .. class .. ' --output-dir ' .. root .. '/force-app/main/default/classes'
    local cmdTest = '!sf apex generate class --name ' .. class .. 'Test --output-dir ' .. root .. '/force-app/main/default/classes'
    vim.cmd(cmd)
    vim.cmd(cmdTest)
    vim.cmd('e ' .. root .. '/force-app/main/default/classes/' .. class .. '.cls')
end, { nargs = 1 })

command('SFCreateTrigger', function (args)
    local root = vim.lsp.get_active_clients()[1].config.cmd_cwd
    local trigger = args.fargs[1]
    local sobject = args.fargs[2]
    local cmd = '!sf apex generate trigger --name ' .. trigger
    .. ' --sobject ' .. sobject
    .. ' --event "before insert" --output-dir '  .. root .. '/force-app/main/default/triggers'
    vim.cmd(cmd)
    vim.cmd('e ' .. root .. '/force-app/main/default/triggers/' .. trigger .. '.trigger')
end, { nargs = "*" })

command('SFCreateLWC', function (args)
    local root = vim.lsp.get_active_clients()[1].config.cmd_cwd
    local lwc = args.fargs[1]
    local cmd = '!sf lightning generate component --name ' .. lwc
    .. ' --type lwc --output-dir ' .. root
    .. '/force-app/main/default/lwc'
    vim.cmd(cmd)
    vim.cmd('e ' .. root .. '/force-app/main/default/lwc/' .. lwc .. '/' .. lwc .. '.js')
end, { nargs = 1 })
