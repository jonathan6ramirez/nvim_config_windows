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
        base03 = '#002b36',
        base02 = '#073642',
        base01 = '#586e75',
        base00 = '#657b83',
        base0 = '#839496',
        base1 = '#93a1a1',
        base2 = '#eee8d5',
        base3 = '#fdf6e3',
        yellow = '#b58900',
        orange = '#cb4b16',
        red = '#dc322f',
        magenta = '#d33682',
        violet = '#6c71c4',
        blue = '#268bd2',
        cyan = '#2aa198',
        green = '#859900',
      }

      local bubbles_theme = {
        normal = {
          a = { fg = colors.base03, bg = colors.blue, gui = 'bold' },
          b = { fg = colors.base03, bg = colors.base1 },
          c = { fg = colors.base1, bg = colors.base02 },
        },

        insert = { a = { fg = colors.base03, bg = colors.green, gui = 'bold' } },
        visual = { a = { fg = colors.base03, bg = colors.orange, gui = 'bold' } },
        replace = { a = { fg = colors.base03, bg = colors.red, gui = 'bold' } },

        command = {
          a = { bg = colors.magenta, fg = colors.black, gui = 'bold' },
          b = { fg = colors.base03, bg = colors.base1 },
          c = { fg = colors.base1, bg = colors.base02 },
        },

        inactive = {
          a = { fg = colors.base0, bg = colors.base02, gui = 'bold' },
          b = { fg = colors.base03, bg = colors.base00 },
          c = { fg = colors.base01, bg = colors.base02 },
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
          lualine_z = { { 'datetime', style = '%a, %b %d %I:%M%p' }, { 'location', separator = { right = '' }, left_padding = 2 } },
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
}
