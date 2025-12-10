return {
    -- {
    --     -- lua REPL inside nvim, use command :Luadev to open a scratch window
    --     'bfredl/nvim-luadev',
    --     -- specifying keys means that the plugin will get loaded only after the keymap is used
    --     keys = {
    --         { '<leader>r', '<Plug>(Luadev-Run)<CR>', desc = 'Run Lua' },
    --         { '<leader>r', '<Plug>(Luadev-Run)<CR>', mode = 'v', desc = 'Run Lua' },
    --         { '<leader>R', '<Plug>(Luadev-RunWord)<CR>', desc = 'Run Lua word' },
    --     },
    -- },
    --
    -- {
    --     -- another lua REPL
    --     'mghaight/replua.nvim',
    --     config = function()
    --         require('replua').setup()
    --     end,
    -- },

    {
        -- REPL, scratchpad, debug - this looks like the best option, open with "`<CR>"
        -- lsp_lua does not get attached when opening only the scratchapd. But it does work when
        -- we open the console while some other lua file is already open
        -- The state of console is stored in "~/.local/state/nvim/lua-console.lua"
        'yarospace/lua-console.nvim',
        lazy = true,
        keys = {
            { '`', desc = 'Lua-console - toggle' },
            { '<Leader>`', desc = 'Lua-console - attach to buffer' },
        },
        opts = {
            mappings = {
                -- <S-CR> does not work for me, let's remap
                eval_buffer = "<leader>r",
            },
            buffer = {
                load_on_start = false,
                clear_before_eval = true, -- clear output before eval on the whole buffer
            }

        },
    },
}
