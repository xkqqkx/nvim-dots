-- CodeCompanion plugin configuration for Neovim
-- Integrates Claude AI (via Anthropic API) for code assistance
-- Features: chat interface, inline suggestions, and agent capabilities
-- Keybindings: <leader>at (toggle chat), <leader>aa (add to chat), <leader>ay/an (accept/reject inline changes)
-- See the plugin files in ~/.local/share/nvim/lazy/codecompanion.nvim/lua/
--
-- 2025-11-30 commented out model choices in custom adapters (they are not shown anymore for some reason)
return {
    {
        'olimorris/codecompanion.nvim',
        cmd = 'CodeCompanion',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'j-hui/fidget.nvim',
            'ravitemer/codecompanion-history.nvim', -- save/summarize/load chats
        },

        keys = {
            { '<leader>at', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle CodeCompanion chat' },
            { '<leader>aa', '<cmd>CodeCompanionChat Add<cr>', desc = 'Add to CodeCompanion chat', mode = 'x' },
            { '<leader>ax', '<cmd>CodeCompanionActions<cr>', desc = 'Open CodeCompanion actions' },
        },
        opts = {
            log_level = 'DEBUG',
            adapters = {
                acp = {
                    gemini_cli = function()
                        return require('codecompanion.adapters').extend('gemini_cli', {
                            env = {
                                api_key = 'GEMINI_API_KEY',
                            },
                            defaults = {
                                auth_method = 'gemini-api-key',
                            },
                        })
                    end,
                },
                http = {
                    opts = {
                        timeout = 40000,
                        show_model_choices = true,
                    },
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
                            env = {
                                api_key = 'GEMINI_API_KEY',
                            },
                            schema = {
                                model = {
                                    default = 'gemini-2.5-flash',
                                },
                            },
                        })
                    end,
                    gemini_bjd = function()
                        return require('codecompanion.adapters').extend('gemini', {
                            env = {
                                api_key = 'GENAI_API_KEY',
                            },
                            schema = {
                                model = {
                                    default = 'gemini-3-pro-preview',
                                    -- choices = {
                                    --     'gemini-2.5-flash',
                                    --     'gemini-2.5-pro',
                                    --     'gemini-3-pro-preview',
                                    -- },
                                },
                            },
                        })
                    end,
                    openrouter = function()
                        return require('codecompanion.adapters').extend('openai', {
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
                                    default = 'openai/gpt-oss-20b:free',
                                    -- some of the free models require settigs in privacy (e.g. allow logging of prompts)
                                    choices = {
                                        -- ['minimax/minimax-m2:free'] = {
                                        --     formatted_name = 'minimax M2',
                                        --     opts = { can_reason = true },
                                        -- },
                                        'openai/gpt-oss-20b:free',
                                        'qwen/qwen3-235b-a22b:free',
                                        'qwen/qwen3-coder:free',
                                    },
                                },
                            },
                        })
                    end,

                    xai = function()
                        return require('codecompanion.adapters').extend('xai', {
                            env = {
                                api_key = 'XAI_API_KEY',
                            },
                            schema = {
                                model = {
                                    default = 'grok-code-fast-1',
                                    choices = {
                                        'grok-code-fast-1',
                                        'grok-4-fast-reasoning',
                                        'grok-4-fast-non-reasoning',
                                    },
                                },
                            },
                        })
                    end,

                    deepseek = function()
                        return require('codecompanion.adapters').extend('deepseek', {
                            env = {
                                api_key = 'DEEPSEEK_API_KEY',
                            },
                        })
                    end,
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
                -- see here https://github.com/ravitemer/codecompanion-history.nvim for recognized options
                history = {
                    enabled = true,
                    opts = {
                        auto_generate_titles = true,
                        title_generation_opts = {
                            adapter = 'gemini',
                            model = 'gemini-2.5-flash',
                        },
                        summary = {
                            generation_opts = {
                                adapter = 'gemini',
                                model = 'gemini-2.5-flash',
                                context_size = 90000, -- max tokens that the model supports
                                include_references = true, -- include slash command content
                                include_tool_outputs = true, -- include tool execution results
                                system_prompt = nil, -- custom system prompt (string or function)
                                format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
                            },
                        },
                    },
                },
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
            memory = {
                opts = {
                    -- add memory to chat buffer. By default AGENT.md or AGENTS.md files
                    -- are recognized as memory files.
                    chat = {
                        enabled = true,
                    },
                },
            },
        },

        init = function()
            require('plugins.custom.spinner'):init()
        end,

        config = function(_, opts)
            require('codecompanion').setup(opts)
            require('codecompanion_modes').setup()
        end,
    },
}
