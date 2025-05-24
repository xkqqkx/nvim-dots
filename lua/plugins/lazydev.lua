-- `lazydev` configures Lua LSP config, runtime and plugins
-- used for completion, annotations and signatures of Neovim apis (note, neovim APIs only!)
return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
}
