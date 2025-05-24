  -- file manager
return {
    {
    'stevearc/oil.nvim',
    config = function()
        local keymap = vim.keymap.set

        local function toggle_detail()
        detail = not detail
        if detail then
            require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
        else
            require('oil').set_columns { 'icon' }
        end
        end

        require('oil').setup {
        view_options = {
            show_hidden = true,
            is_always_hidden = function(name, bufnr)
            if name == '..' then
                return true
            else
                return false
            end
            end,
            keymaps = {
            ['gd'] = { callback = toggle_detail, mode = 'n', desc = 'Toggle file detail view' },
            },
        },
        }
        keymap('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })

        -- keymap('n', 'gd', toggle_detail, { desc = 'Toggle file detail view' })
    end
    }
}
