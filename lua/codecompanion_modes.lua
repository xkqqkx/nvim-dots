-- Save as ~/.config/nvim/lua/codecompanion_modes.lua
-- This allows you to switch system prompts on the fly
-- This is loaded by codecompanion.lua
-- Save as ~/.config/nvim/lua/codecompanion_modes.lua
-- This allows you to switch system prompts on the fly

local M = {}

-- Define different modes with their prompts
M.prompts = {
    coding = [[You are an expert coding assistant focused on:
- Writing clean, efficient code
- Following best practices
- Providing clear explanations
- Debugging and optimization]],

    general = [[You are a helpful and versatile AI assistant. You can help with:
- General questions and research
- Writing and editing text
- Explanations on any topic
- Creative tasks
- Technical and non-technical queries
You are not limited to coding tasks.]],

    writing = [[You are a professional writing assistant. You help with:
- Creating and editing documents
- Improving writing style and clarity
- Grammar and structure
- Creative writing
- Technical documentation]],

    explain = [[You are an expert teacher who explains complex topics simply.
Focus on:
- Clear, beginner-friendly explanations
- Using examples and analogies
- Breaking down complex concepts
- Answering follow-up questions patiently]],

    minimax_m2 = [[You are MiniMax M2, an AI assistant optimized for coding and agentic workflows.
Your strengths include:
- End-to-end coding and debugging
- Multi-step tool use and task execution
- Planning, acting, and verifying complex workflows
- Shell, browser, and Python interpreter interaction

Use your <think>...</think> blocks to show your reasoning process.
Break down complex tasks into clear steps.]],
}

-- Update system prompt in the current chat
function M.set_mode(mode_name)
    local prompt = M.prompts[mode_name]
    if not prompt then
        vim.notify('Unknown mode: ' .. mode_name, vim.log.levels.ERROR)
        return
    end

    -- Get the current chat buffer
    local ok, chat = pcall(require('codecompanion').buf_get_chat, 0)
    if not ok or not chat then
        vim.notify('No active CodeCompanion chat', vim.log.levels.WARN)
        return
    end

    -- Update the system prompt
    -- Find and update the system message
    for i, msg in ipairs(chat.messages) do
        if msg.role == 'system' then
            chat.messages[i].content = prompt
            vim.notify('Switched to ' .. mode_name .. ' mode', vim.log.levels.INFO)
            return
        end
    end

    -- If no system message found, insert one at the beginning
    table.insert(chat.messages, 1, {
        role = 'system',
        content = prompt,
    })
    vim.notify('Switched to ' .. mode_name .. ' mode', vim.log.levels.INFO)
end

-- Create a picker to select mode
function M.select_mode()
    local modes = vim.tbl_keys(M.prompts)
    table.sort(modes)

    vim.ui.select(modes, {
        prompt = 'Select CodeCompanion mode:',
    }, function(choice)
        if choice then
            M.set_mode(choice)
        end
    end)
end

-- Setup function to create commands
function M.setup()
    -- Create user command
    vim.api.nvim_create_user_command('CodeCompanionMode', function(opts)
        if opts.args == '' then
            M.select_mode()
        else
            M.set_mode(opts.args)
        end
    end, {
        nargs = '?',
        complete = function()
            return vim.tbl_keys(M.prompts)
        end,
    })

    -- Optional: Create keymaps
    vim.keymap.set('n', '<leader>am', M.select_mode, { desc = 'Change CodeCompanion mode' })
end

return M
