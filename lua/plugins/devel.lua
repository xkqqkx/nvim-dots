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
                eval_buffer = '<leader>r',
            },
            buffer = {
                load_on_start = false,
                clear_before_eval = true, -- clear output before eval on the whole buffer
            },
        },
    },

    {
        'NickvanDyke/opencode.nvim',
        dependencies = {
            -- Recommended for `ask()` and `select()`.
            -- Required for `snacks` provider.
            ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
            { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } },
        },
        config = function()
            ---@type opencode.Opts
            vim.g.opencode_opts = {
                -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
            }

            -- Required for `opts.events.reload`.
            vim.o.autoread = true

            -- Recommended/example keymaps.
            vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
                require('opencode').ask('@this: ', { submit = true })
            end, { desc = 'Ask opencode' })
            vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
                require('opencode').select()
            end, { desc = 'Execute opencode action…' })
            vim.keymap.set({ 'n', 'x' }, 'ga', function()
                require('opencode').prompt '@this'
            end, { desc = 'Add to opencode' })
            vim.keymap.set({ 'n', 't' }, '<C-.>', function()
                require('opencode').toggle()
            end, { desc = 'Toggle opencode' })
            vim.keymap.set('n', '<S-C-u>', function()
                require('opencode').command 'session.half.page.up'
            end, { desc = 'opencode half page up' })
            vim.keymap.set('n', '<S-C-d>', function()
                require('opencode').command 'session.half.page.down'
            end, { desc = 'opencode half page down' })
            -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
            vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment', noremap = true })
            vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement', noremap = true })
        end,
    },
}
