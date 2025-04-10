return {
  'folke/zen-mode.nvim',
  opts = {
    window = {
      backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
      -- height and width can be:
      -- * an absolute number of cells when > 1
      -- * a percentage of the width / height of the editor when <= 1
      -- * a function that returns the width or the height
      width = 120, -- width of the Zen window
      height = 1, -- height of the Zen window
      -- by default, no options are changed for the Zen window
      -- uncomment any of the options below, or add other vim.wo options you want to apply
      options = {
        -- signcolumn = "no", -- disable signcolumn
        -- number = false, -- disable number column
        -- relativenumber = false, -- disable relative numbers
        -- cursorline = false, -- disable cursorline
        -- cursorcolumn = false, -- disable cursor column
        -- foldcolumn = "0", -- disable fold column
        -- list = false, -- disable whitespace characters
      },
    },
    plugins = {
      twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
      gitsigns = { enabled = true }, -- disables git signs
      -- this will change the font size on wezterm when in zen mode
      -- See alse also the Plugins/Wezterm section in this projects README
      wezterm = {
        enabled = true,
        -- can be either an absolute font size or the number of incremental steps
        font = '+2', -- (10% increase per step)
      },
    },
    -- callback where you can add custom code when the Zen window opens
    on_open = function(win)
      local cmd = [[
        $var = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("16"))
        $esc = [char]27
        $bel= [char]7
        Write-Host "$esc]1337;SetUserVar=ZEN_MODE=$var$bel"
      ]]

      vim.fn.jobstart({ 'pwsh', '-NoLogo', '-Command', cmd }, { detach = true })
    end,
    -- callback where you can add custom code when the Zen window closes
    on_close = function()
      local cmd = [[
        $var = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("-1"))
        $esc = [char]27
        $bel= [char]7
        Write-Host "$esc]1337;SetUserVar=ZEN_MODE=$var$bel"
      ]]

      vim.fn.jobstart({ 'pwsh', '-NoLogo', '-Command', cmd }, { detach = true })
    end,
  },
  dependencies = {
    {
      'folke/twilight.nvim',
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
    },
  },
}
