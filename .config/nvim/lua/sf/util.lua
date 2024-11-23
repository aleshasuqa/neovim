local P = {}
local vim = vim

local function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end

local function read_all(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

function P.hl_debug(cmd)
    local color = '$(echo -e "\\033[0;36m")'
    local nc = '$(echo -e "\\033[0m")'
    return cmd .. ' | sed -E "s/(.*DEBUG)/' .. color .. '\\1' .. nc .. '/g"'
end

function P.hl_word(word, col)
    local color = '$(echo -e "\\033[0;' .. col .. 'm")'
    local nc = '$(echo -e "\\033[0m")'
    return ' | sed -E "s/' .. word .. '/' .. color .. word .. nc .. '/g"'
end

function P.term(cmds)
    vim.cmd('term bash -c \'' .. table.concat(cmds, ';') .. '\'')
end

function P.retrieve(cmd, data, update)
    -- print(vim.inspect(cmd))
    local cont = ""
    local tmpFile = '/tmp/sf/' .. data .. '.json'
    if file_exists(tmpFile) and not update then
        cont = read_all(tmpFile)
    else
        local obj = vim.system(cmd, { text = true }):wait()
        print(vim.inspect(obj))
        cont = obj.stdout
        local file = assert(io.open(tmpFile, "w+"))
        file:write(cont)
    end
    -- print(cont)
    return vim.json.decode(cont)
end

function P.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function P.open_float(width, height)
    -- local width = 50
    -- local height = 10

    local buf = vim.api.nvim_create_buf(false, true)

    local ui = vim.api.nvim_list_uis()[1]

    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = (ui.width/2) - (width/2),
        row = (ui.height/2) - (height/2),
        anchor = 'NW',
        -- style = 'minimal',
        border = 'single',
    }
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', {silent = true, nowait = true, noremap = true})
    vim.api.nvim_open_win(buf, 1, opts)
end

function P.tele_cmd(det)
    -- local d = {
    --     name = '',
    --     picks = {},
    --     width = 25,
    --     telescope_opts = {},
    --     mappings = function () end
    -- }

    local pickers = require 'telescope.pickers'
    local finders = require 'telescope.finders'

    local entry_display = require 'telescope.pickers.entry_display'
    local displayer = entry_display.create {
        separator = "",
        items = {
            { width = det.width },
            -- The final column can be set to fill the remaining space
            { remaining = false },
        },
    }

    local finder = finders.new_table {
        results = det.picks,
        entry_maker = function(entry)
            return {
                value = entry,
                display = function(ent)
                    return displayer {
                        ent.value.name,
                    }
                end,
                ordinal = entry.name,
            }
        end,
    }
    -- det.telescope_opts -- require("telescope.themes").get_cursor{layout_config = {width = 25}}

    local conf = require 'telescope.config'.values

    pickers.new(det.telescope_opts, {
        prompt_title = det.name,
        finder = finder,
        -- Use the default sorter
        sorter = conf.generic_sorter(det.telescope_opts),
        attach_mappings = det.mappings,
    }):find()
end

return P
