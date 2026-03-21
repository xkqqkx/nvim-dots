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
        width = 120,
        height = 150,
        width_ratio = 0.95, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
        height_ratio = 0.95,
        style = 'light',
        border = 'single',
        cmd = 'Glow',
    },
}
