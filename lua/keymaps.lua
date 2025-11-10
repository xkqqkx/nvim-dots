-- Remap for dealing with word wrap and adding jumps to the jumplist.
vim.keymap.set('n', 'j', [[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']], { expr = true })
vim.keymap.set('n', 'k', [[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']], { expr = true })

-- Keeping the cursor centered.
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll downwards' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll upwards' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous result' })

-- Indent while remaining in visual mode.
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Formatting.
vim.keymap.set('n', 'gQ', 'mzgggqG`z<cmd>delmarks z<cr>zz', { desc = 'Format buffer' })

-- Open the package manager.
vim.keymap.set('n', '<leader>L', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- Open Neogit.
vim.keymap.set('n', '<leader>N', '<cmd>Neogit<cr>', { desc = 'Neogit' })

-- Switch between windows.
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to the left window', remap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to the bottom window', remap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to the top window', remap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to the right window', remap = true })

-- Tab navigation.
-- (m.s.) I don't use tabs, commenting this out
--vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<cr>', { desc = 'Close tab page' })
--vim.keymap.set('n', '<leader>tn', '<cmd>tab split<cr>', { desc = 'New tab page' })
--vim.keymap.set('n', '<leader>to', '<cmd>tabonly<cr>', { desc = 'Close other tab pages' })

-- Poweful <esc>.
vim.keymap.set({ 'i', 's', 'n' }, '<esc>', function()
    if require('luasnip').expand_or_jumpable() then
        require('luasnip').unlink_current()
    end
    vim.cmd 'noh'
    return '<esc>'
end, { desc = 'Escape, clear hlsearch, and stop snippet session', expr = true })

-- Make U opposite to u.
vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo' })

-- Escape and save changes.
vim.keymap.set({ 's', 'i', 'n', 'v' }, '<C-s>', '<esc>:w<cr>', { desc = 'Exit insert mode and save changes.' })
vim.keymap.set({ 's', 'i', 'n', 'v' }, '<C-S-s>', '<esc>:wa<cr>', { desc = 'Exit insert mode and save all changes.' })

-- Quickly go to the end of the line while in insert mode.
vim.keymap.set({ 'i', 'c' }, '<C-l>', '<C-o>A', { desc = 'Go to the end of the line' })

-- Floating terminal.
vim.keymap.set({ 'n', 't' }, '<leader>T', function()
    require('float_term').float_term('bash', { cwd = vim.fn.expand '%:p:h' })
end, { desc = 'Toggle floating terminal' })

vim.keymap.set('t', '<leader>tn', '<C-\\><C-n>', { noremap = true, silent = true, desc = 'Terminal Normal Mode' }) -- Standard C-\ C-n sequence does not work for me

vim.keymap.set('n', '<leader><space>', ':buffer #<CR>', { desc = 'move to previously used buffer' })
vim.keymap.set('n', '<F5>', [["=strftime("%Y-%m-%d")<CR>P]], { desc = 'insert date' })
vim.keymap.set('i', '<F5>', [[<C-R>=strftime("%Y-%m-%d")<CR>]], { desc = 'insert date' })

-- Toggle gutter
-- see https://stackoverflow.com/questions/74159815/how-can-i-create-a-toggle-to-completely-show-hide-the-line-number-gutter
vim.keymap.set('n', '<leader>n', function()
    vim.o.signcolumn = vim.o.signcolumn == 'yes' and 'no' or 'yes'
    vim.o.foldcolumn = vim.o.foldcolumn == '0' and '1' or '0'
    vim.o.number = not vim.o.number
    vim.o.list = not vim.o.list
    if vim.o.number then
        vim.o.signcolumn = 'yes'
    else
        vim.o.signcolumn = 'no'
    end
    vim.cmd 'IBLToggle'
end, { desc = 'Toggle gutter' })
