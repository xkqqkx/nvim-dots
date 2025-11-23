return {
    'yorik1984/newpaper.nvim',
    priority = 1000,
    config = function()
        require('newpaper').setup {
            style = 'light',
            preset = {
                by_filetype = {
                    text = {},
                    task = {'scratch'},
                    view = {'markdown'},
                },
                by_filename = {
                    text = {},
                    task = {},
                    view = {},
                },
            },
        }
    end,
}
