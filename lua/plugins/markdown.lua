return {
    -- markdown formatting inside buffer
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            file_types = { 'markdown', 'codecompanion' },
        },
    },

    -- markdown preview using Glow
    {
        'ellisonleao/glow.nvim',
        config = true,
        widht = 120,
        width_ratio = 0.9,
        style = 'light',
        border = 'single',
        cmd = 'Glow',
    },
}
