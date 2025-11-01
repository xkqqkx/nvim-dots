-- work with git from nvim
return   {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      "sindrets/diffview.nvim",

      -- Only one of these is needed, not both.
      -- 'nvim-telescope/telescope.nvim',
      'ibhagwan/fzf-lua', -- optional
    },
    integrations = {diffview=true},
    -- config = true,
}
