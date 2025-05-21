return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'kristijanhusak/vim-dadbod-completion',
    },
    -- override the options table that is used in the `require("cmp").setup()` call
    opts = function(_, opts)
      -- opts parameter is the default options table
      -- the function is lazy loaded so cmp is able to be required
      local cmp = require 'cmp'
      -- modify the sources part of the options table
      opts.sources = cmp.config.sources {
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', priority = 750 },
        { name = 'buffer', priority = 500 },
        { name = 'path', priority = 250 },
        { name = 'vim-dadbod-completion' }, -- add new source
      }

      cmp.setup.filetype({ 'sql', 'mysql', 'plsql' }, {
        sources = {
          { name = 'vim-dadbod-completion' },
          { name = 'buffer' },
        },
      })
      -- return the new table to be used
      return opts
    end,
  },
}
