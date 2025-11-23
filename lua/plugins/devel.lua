return {
    {
        -- lua REPL inside nvim, use command :Luadev to open a scratch window
        'bfredl/nvim-luadev',
        -- specifying keys means that the plugin will get loaded only after the keymap is used
        keys = {
            { '<leader>r', '<Plug>(Luadev-Run)<CR>', desc = 'Run Lua' },
            { '<leader>r', '<Plug>(Luadev-Run)<CR>', mode='v',desc = 'Run Lua' },
            { '<leader>R', '<Plug>(Luadev-RunWord)<CR>', desc = 'Run Lua word' },
        },
    },

    {
        -- another lua REPL
        'mghaight/replua.nvim',
        config = function()
            require('replua').setup()
        end,
    },
}
