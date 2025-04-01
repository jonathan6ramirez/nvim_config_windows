return {
  -- { dir = '~/AppData/Local/nvim/plugins/present.nvim' },
  {
    dir = '~/AppData/Local/nvim/plugins/floaterminal.nvim',
    -- lazy = true,
    config = function()
      require 'floaterminal'
    end,
  },
}
