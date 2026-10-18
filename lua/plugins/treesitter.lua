-- Highlight, edit, and navigate code.
local ensure_installed = {
    'bash',
    'c',
    'cpp',
    'fish',
    'gitcommit',
    'graphql',
    'html',
    'java',
    'javascript',
    'json',
    'json5',
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'query',
    'rasi',
    'regex',
    'rust',
    'scss',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'yaml',
}

-- Treesitter unindents Yaml lists for some reason.
local indent_disabled_filetypes = { yaml = true }

-- The `main` branch dropped the old incremental_selection module, so it's
-- reimplemented here on top of the public `vim.treesitter` node API.
local selection_stacks = {}

local function select_node(node)
    local srow, scol, erow, ecol = node:range()
    vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
    if vim.fn.mode() ~= 'v' then
        vim.cmd('normal! v')
    end
    vim.api.nvim_win_set_cursor(0, { erow + 1, math.max(ecol - 1, scol) })
end

local function expand_selection()
    local bufnr = vim.api.nvim_get_current_buf()
    local stack = selection_stacks[bufnr]
    local node = stack and stack[#stack]:parent() or vim.treesitter.get_node()
    if not node then
        return
    end
    stack = stack or {}
    table.insert(stack, node)
    selection_stacks[bufnr] = stack
    select_node(node)
end

local function shrink_selection()
    local bufnr = vim.api.nvim_get_current_buf()
    local stack = selection_stacks[bufnr]
    if not stack or #stack < 2 then
        return
    end
    table.remove(stack)
    select_node(stack[#stack])
end

return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        dependencies = {
            {
                'nvim-treesitter/nvim-treesitter-context',
                opts = {
                    -- Avoid the sticky context from growing a lot.
                    max_lines = 3,
                    -- Match the context lines to the source code.
                    multiline_threshold = 1,
                    -- Disable it when the window is too small.
                    min_window_height = 20,
                },
                keys = {
                    {
                        '[c',
                        function()
                            -- Jump to previous change when in diffview.
                            if vim.wo.diff then
                                return '[c'
                            else
                                vim.schedule(function()
                                    require('treesitter-context').go_to_context()
                                end)
                                return '<Ignore>'
                            end
                        end,
                        desc = 'Jump to upper context',
                        expr = true,
                    },
                },
            },
        },
        lazy = false,
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter').install(ensure_installed)

            local group = vim.api.nvim_create_augroup('mariasolos/treesitter', { clear = true })
            vim.api.nvim_create_autocmd('FileType', {
                group = group,
                callback = function(event)
                    if not pcall(vim.treesitter.start) then
                        return
                    end

                    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

                    if not indent_disabled_filetypes[event.match] then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end

                    local map_opts = { buffer = event.buf }
                    vim.keymap.set('n', '<cr>', expand_selection, vim.tbl_extend('force', map_opts, {
                        desc = 'Init incremental selection',
                    }))
                    vim.keymap.set('x', '<cr>', expand_selection, vim.tbl_extend('force', map_opts, {
                        desc = 'Increment selection',
                    }))
                    vim.keymap.set('x', '<bs>', shrink_selection, vim.tbl_extend('force', map_opts, {
                        desc = 'Decrement selection',
                    }))
                end,
            })

            vim.api.nvim_create_autocmd({ 'InsertEnter', 'BufLeave' }, {
                group = group,
                desc = 'Reset incremental selection',
                callback = function()
                    selection_stacks[vim.api.nvim_get_current_buf()] = nil
                end,
            })
        end,
    },
}
