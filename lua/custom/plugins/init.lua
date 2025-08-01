-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
require('custom.winbar').setup()
return {

  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>gl', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          '<leader>gH',
          function()
            require('harpoon'):list():add()
          end,
          desc = 'Harpoon File',
        },
        {
          '<leader>gh',
          function()
            local harpoon = require 'harpoon'
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = 'Harpoon Quick Menu',
        },
      }

      for i = 1, 5 do
        table.insert(keys, {
          '<leader>' .. i,
          function()
            local harpoon = require 'harpoon'
            local list = harpoon:list()
            if list then
              list:select(i)
            else
              vim.notify('Harpoon list is not intiailized yet', vim.log.levels.WARN)
              -- require('harpoon'):list():select(i)
            end
          end,
          desc = 'Harpoon to File ' .. i,
        })
      end
      return keys
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local colors = {
        background = '#222436',
        foreground = '#c8d3f5',
        cursor = '#c8d3f5',
        split = '#82aaff',
        selection = '#2d3f76',
        red = '#ff757f',
        green = '#c3e88d',
        yellow = '#ffc777',
        blue = '#82aaff',
        magenta = '#c099ff',
        cyan = '#86e1fc',
        white = '#c8d3f5',
        gray = '#545c7e',
        darkgray = '#1b1d2b',
      }

      local tokyo_moon_theme = {
        normal = {
          a = { fg = colors.background, bg = colors.blue, gui = 'bold' },
          b = { fg = colors.foreground, bg = colors.darkgray },
          c = { fg = colors.foreground, bg = colors.background },
        },
        insert = {
          a = { fg = colors.background, bg = colors.green, gui = 'bold' },
        },
        visual = {
          a = { fg = colors.background, bg = colors.yellow, gui = 'bold' },
        },
        replace = {
          a = { fg = colors.background, bg = colors.red, gui = 'bold' },
        },
        command = {
          a = { fg = colors.background, bg = colors.magenta, gui = 'bold' },
        },
        inactive = {
          a = { fg = colors.gray, bg = colors.background, gui = 'bold' },
          b = { fg = colors.gray, bg = colors.darkgray },
          c = { fg = colors.gray, bg = colors.background },
        },
      }

      local bubbles_theme = {
        normal = {
          a = { fg = '#7e9cd8', bg = 'NONE', gui = 'bold' },
          b = { fg = '#c8c093', bg = 'NONE' },
          c = { fg = '#dcd7ba', bg = 'NONE' },
        },

        insert = {
          a = { fg = '#76946a', bg = 'NONE', gui = 'bold' },
        },

        visual = {
          a = { fg = '#c0a36e', bg = 'NONE', gui = 'bold' },
        },

        replace = {
          a = { fg = '#c34043', bg = 'NONE', gui = 'bold' },
        },

        command = {
          a = { fg = '#957fb8', bg = 'NONE', gui = 'bold' },
          b = { fg = '#c8c093', bg = 'NONE' },
          c = { fg = '#dcd7ba', bg = 'NONE' },
        },

        inactive = {
          a = { fg = '#727169', bg = 'NONE', gui = 'bold' },
          b = { fg = '#c8c093', bg = 'NONE' },
          c = { fg = '#727169', bg = 'NONE' },
        },
      }
      -- local kanagawa_paper = require 'lualine.themes.kanagawa-paper-ink'
      -- NOTE: if you want to change the color back on lualine change the theme

      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = tokyo_moon_theme,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          -- component_separators = { left = '', right = '' },
          -- section_separators = { left = '', right = '' },
          -- component_separators = '|',
          -- section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          },
        },

        sections = {
          lualine_a = { { 'mode', separator = { left = '', right = '' }, right_padding = 2 } },
          -- lualine_a = { 'mode' },
          lualine_b = { 'branch', { 'filename', path = 1 } },
          lualine_c = {},
          lualine_x = {
            {
              -- function()
              --   -- invoke `progress` here.
              --   return require('lsp-progress').progress()
              -- end,
            },
          },
          lualine_y = {
            -- clients_lsp,
            -- 'filetype',
            'diagnostics',
            'progress',
          },
          lualine_z = { { 'datetime', style = '%a, %b %d %I:%M%p' }, { 'location', separator = { right = '' }, left_padding = 0 } },
        },

        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },

        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      }
    end,
  },
  {
    'linrongbin16/lsp-progress.nvim',
    config = function()
      require('lsp-progress').setup()
    end,
  },
  {
    'karb94/neoscroll.nvim',
    opts = {},
    config = function()
      require('neoscroll').setup {
        mappings = { -- Keys to be mapped to their corresponding default scrolling animation
          '<C-u>',
          '<C-d>',
          '<C-b>',
          '<C-f>',
          '<C-y>',
          '<C-e>',
          'zt',
          'zz',
          'zb',
        },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        duration_multiplier = 1.0, -- Global duration multiplier
        easing = 'linear', -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
        performance_mode = false, -- Disable "Performance Mode" on all buffers.
        ignored_events = { -- Events ignored while scrolling
          'WinScrolled',
          'CursorMoved',
        },
      }
    end,
  },
  -- {
  --   'MTDL9/vim-log-highlighting',
  --   opts = {},
  -- },
  --
}
