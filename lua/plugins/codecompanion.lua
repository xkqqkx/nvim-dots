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
                    gemini = function()
                        return require('codecompanion.adapters').extend('gemini', {
                            name = 'gemini',
                            env = {
                                api_key = 'GEMINI_API_KEY',
                            },
                            schema = {
                                model = {
                                    default = 'gemini-2.5-flash',
                                    choices = {
                                        'gemini-2.5-flash',
                                        'gemini-2.5-pro',
                                    },
                                },
                            },
                        })
                    end,
                    openrouter = function()
                        return require('codecompanion.adapters').extend('openai', {
                            name = 'openrouter',
                            url = 'https://openrouter.ai/api/v1/chat/completions',
                            env = {
                                api_key = 'OPENROUTER_API_KEY',
                            },
                            -- headers = {
                            --   ["HTTP-Referer"] = "https://github.com/yourusername", -- Optional
                            --   ["X-Title"] = "CodeCompanion",  -- Optional
                            -- },
                            schema = {
                                model = {
                                    default = 'minimax/minimax-m2:free',
                                    -- some of the free models require settigs in privacy (e.g. allow logging of prompts)
                                    choices = {
                                        ['minimax/minimax-m2:free'] = {
                                            formatted_name = 'minimax M2',
                                            opts = { can_reason = true },
                                        },
                                        'qwen/qwen3-235b-a22b:free',
                                        'qwen/qwen3-coder:free',
                                        'deepseek/deepseek-chat-v3.1:free', -- provider uses data for training
                                        -- "deepseek/deepseek-chat", -- paid model
                                        -- "x-ai/grok-code-fast-1", -- paid model
                                        -- "x-ai/grok-4-fast",
                                        -- "x-ai/grok-4",
                                        -- "nousresearch/hermes-3-llama-3.1-405b:free,"
                                    },
                                },
                            },
                        })
                    end,

                    xai = function()
                        return require('codecompanion.adapters').extend('xai', {
                            name = 'xai',
                            env = {
                                api_key = 'XAI_API_KEY',
                            },
                            schema = {
                                model = {
                                    default = 'grok-code-fast-1',
                                    choices = {
                                        'grok-code-fast-1',
                                        'grok-4-fast-reasoning',
                                        'groi-4-fast-non-reasoning',
                                    },
                                },
                            },
                        })
                    end,

                    deepseek = function()
                        return require('codecompanion.adapters').extend('deepseek', {
                            name = 'deepseek',
                            env = {
                                api_key = 'DEEPSEEK_API_KEY',
                            },
                            schema = {
                                model = {
                                    default = 'deepseek-chat',
                                    choices = {
                                        'deepseek-chat',
                                        'deepseek-reasoner',
                                    },
                                },
                            },
                        })
                    end,
                    -- minimax_m2 = function()
                    --     return require('codecompanion.adapters').extend('openai', {
                    --         name = 'minimax_m2',
                    --         url = 'https://openrouter.ai/api/v1/chat/completions',
                    --         env = {
                    --             api_key = 'OPENROUTER_API_KEY',
                    --         },
                    --         schema = {
                    --             model = {
                    --                 default = 'minimax/minimax-m2:free',
                    --             },
                    --             -- critical: preserve reasoning content
                    --             -- openrouter automatically handles <think> blocks
                    --         },
                    --         handlers = {
                    --             -- custom handler to ensure reasoning is preserved
                    --             on_stdout = function(self, data)
                    --                 -- default handler - preserves all content including <think> tags
                    --                 if data and data.choices and data.choices[1] then
                    --                     local content = data.choices[1].message.content
                    --                     -- do not strip <think>...</think> tags
                    --                     -- keep them intact for next turn
                    --                     return content
                    --                 end
                    --             end,
                    --         },
                    --     })
                    -- end,
                    --
                    opts = {
                        timeout = 40000,
                        show_model_choices = true,
                    },
                },
            },
            strategies = {
                agent = { adapter = 'anthropic' },
                inline = {
                    adapter = 'gemini',
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
                    adapter = 'gemini',
                    keymaps = {
                        clear = {
                            modes = { n = 'gX' },
                            description = 'Clear chat',
                        },
                    },
                },
                diff = {
                    provider = 'mini.diff',
                },
            },
            extensions = {
                mcphub = {
                    callback = 'mcphub.extensions.codecompanion',
                    opts = {
                        -- MCP Tools
                        make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
                        show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
                        add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
                        show_result_in_chat = true, -- Show tool results directly in chat buffer
                        format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
                        -- MCP Resources
                        make_vars = true, -- Convert MCP resources to #variables for prompts
                        -- MCP Prompts
                        make_slash_commands = true, -- Add MCP prompts as /slash commands
                    },
                },
            },
        },
        config = function(_, opts)
            require('codecompanion').setup(opts)
            require('codecompanion_modes').setup()
        end,
    },
}
