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
        -- command :TinyInlineDiag (toggle, disable, enable)
        'rachartier/tiny-inline-diagnostic.nvim',
        event = 'VeryLazy',
        priority = 1000,
        config = function()
            require('tiny-inline-diagnostic').setup()
            vim.diagnostic.config { virtual_text = false } -- Disable Neovim's default virtual text diagnostics
        end,
    },

    -- Copilot
    {
        'zbirenbaum/copilot.lua',
        event = 'InsertEnter',
        opts = {
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = '<M-.>',
                    accept_word = '<M-w>',
                    accept_line = '<M-l>',
                    next = '<M-]>',
                    prev = '<M-[>',
                    -- dismiss = '<C-/>',
                },
            },
            panel = {
                enabled = true,
            },
            filetypes = {
                markdown = true,
                yaml = true,
            },
        },
        config = function(_, opts)
            require('copilot').setup(opts)
        end,
    },

    --  Opencode
    {
        'NickvanDyke/opencode.nvim',
        config = function()
            vim.g.opencode_opts = {
                -- port = '50000',
            }
            vim.o.autoread = true
        end,
    }
}
