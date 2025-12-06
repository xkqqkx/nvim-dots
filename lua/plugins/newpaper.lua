return {
    'yorik1984/newpaper.nvim',
    priority = 1000,
    config = function()
        require('newpaper').setup {
            style = 'light',
            preset = {
                by_filetype = {
                    text = {},
                    task = {'scratch'}, -- yellow background
                    view = {},  -- for documents that do not need line numbers
                },
                by_filename = {
                    text = {},
                    task = {},
                    view = {},
                },
            },
        }
        -- Set the colorscheme immediately after newpaper is configured
        vim.cmd.colorscheme('newpaper')
    end,
}
