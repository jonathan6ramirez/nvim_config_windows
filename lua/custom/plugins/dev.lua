return {
  -- { dir = '~/AppData/Local/nvim/plugins/present.nvim' },
  {
    -- dir = '~/AppData/Local/nvim/plugins/floaterminal.nvim', --Windows
    dir = '~/.config/nvim/plugins/floaterminal.nvim/', --MacJ
    -- lazy = true,
    config = function()
      require 'floaterminal'
    end,
  },
}
