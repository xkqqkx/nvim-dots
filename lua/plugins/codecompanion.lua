-- CodeCompanion plugin configuration for Neovim
-- Integrates Claude AI (via Anthropic API) for code assistance
-- Features: chat interface, inline suggestions, and agent capabilities
-- Keybindings: <leader>at (toggle chat), <leader>aa (add to chat), <leader>ay/an (accept/reject inline changes)
-- See the plugin files in ~/.local/share/nvim/lazy/codecompanion.nvim/lua/
return {
    {
        'olimorris/codecompanion.nvim',
        cmd = 'CodeCompanion',
        dependencies = { 'nvim-lua/plenary.nvim' },

        keys = {
            { '<leader>at', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle CodeCompanion chat' },
            { '<leader>aa', '<cmd>CodeCompanionChat Add<cr>', desc = 'Add to CodeCompanion chat', mode = 'x' },
            { '<leader>ax', '<cmd>CodeCompanionActions<cr>', desc = 'Open CodeCompanion actions' },
        },
        opts = {
            log_level = 'DEBUG',
            adapters = {
                http = {
                    anthropic = function()
                        return require('codecompanion.adapters').extend('anthropic', {
                            env = {
                                api_key = 'ANTHROPIC_API_KEY',
                            },
                            schema = {
                                model = {
                                    default = 'claude-haiku-4-5-20251001',
                                },
                            },
                        })
                    end,
                    opts = {
                        timeout = 40000,
                    },
                },
            },
            strategies = {
                agent = { adapter = 'anthropic' },
                inline = {
                    adapter = 'anthropic',
                    keymaps = {
                        accept_change = {
                            modes = { n = '<leader>ay' },
                            description = 'Accept the suggested change',
                        },
                        always_accept = {
                            modes = { n = '<leader>aY' },
                            description = 'Accept and enable auto mode',
                        },
                        reject_change = {
                            modes = { n = '<leader>an' },
                            description = 'Reject the suggested change',
                        },
                    },
                },
                chat = {
                    adapter = 'anthropic',
                    keymaps = {
                        clear = {
                            modes = { n = 'gX' },
                            description = 'Clear chat',
                        },
                    },
                },
                diff = {
                    provider = 'diffview',
                },
            },
        },
    },
}
