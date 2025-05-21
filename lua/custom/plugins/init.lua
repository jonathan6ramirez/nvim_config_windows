-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
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
            require('harpoon'):list():select(i)
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
      -- local colors = {
      --   black = '#282828',
      --   white = '#ebdbb2',
      --   red = '#fb4934',
      --   green = '#b8bb26',
      --   blue = '#83a598',
      --   yellow = '#fe8019',
      --   gray = '#a89984',
      --   darkgray = '#3c3836',
      --   lightgray = '#504945',
      --   inactivegray = '#7c6f64',
      -- }
      local colors = {
        background = '#414a4c',
        background_transparent = '#1f1f28', -- fallback since lualine doesn't support rgba
        foreground = '#dcd7ba',
        cursor = '#c8c093',
        selection_bg = '#2d4f67',
        scrollbar_thumb = '#16161d',
        split = '#232b2b',
        red = '#c34043',
        green = '#76946a',
        yellow = '#c0a36e',
        blue = '#7e9cd8',
        magenta = '#957fb8',
        cyan = '#6a9589',
        white = '#c8c093',
        bright_white = '#dcd7ba',
        gray = '#727169',
      }

      local bubbles_theme = {
        normal = {
          a = { fg = colors.split, bg = colors.blue, gui = 'bold' },
          b = { fg = colors.foreground, bg = colors.split },
          c = { fg = colors.foreground, bg = colors.split },
        },

        insert = { a = { fg = colors.split, bg = colors.green, gui = 'bold' } },
        visual = { a = { fg = colors.split, bg = colors.yellow, gui = 'bold' } },
        replace = { a = { fg = colors.split, bg = colors.red, gui = 'bold' } },
        command = { a = { fg = colors.split, bg = colors.magenta, gui = 'bold' } },

        inactive = {
          a = { fg = colors.gray, bg = colors.background, gui = 'bold' },
          b = { fg = colors.gray, bg = colors.split },
          c = { fg = colors.gray, bg = colors.background },
        },
      }

      -- local function lsp_progress()
      --   local messages = vim.lsp.util.get_progress_messages()
      --   if #messages == 0 then
      --     return
      --   end
      --   local status = {}
      --   for _, msg in pairs(messages) do
      --     table.insert(status, (msg.percentage or 0) .. '%% ' .. (msg.title or ''))
      --   end
      --   local spinners = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
      --   local ms = vim.loop.hrtime() / 1000000
      --   local frame = math.floor(ms / 120) % #spinners
      --   return table.concat(status, ' | ') .. ' ' .. spinners[frame + 1]
      -- end
      local clients_lsp = function()
        local bufnr = vim.api.nvim_get_current_buf()

        local clients = vim.lsp.buf_get_clients(bufnr)
        if next(clients) == nil then
          return ''
        end

        local c = {}
        for _, client in pairs(clients) do
          table.insert(c, client.name)
        end
        return '\u{f085} ' .. table.concat(c, '|')
      end
      -- local kanagawa_paper = require 'lualine.themes.kanagawa-paper-ink'
      -- NOTE: if you want to change the color back on lualine change the theme

      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = bubbles_theme,
          -- component_separators = { left = '', right = '' },
          -- section_separators = { left = '', right = '' },
          -- component_separators = { left = '', right = '' },
          -- section_separators = { left = '', right = '' },
          component_separators = '|',
          section_separators = { left = '', right = '' },
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
          lualine_b = { 'branch', { 'filename', path = 1 }, 'diagnostics' },
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
            clients_lsp,
            'filetype',
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
}
