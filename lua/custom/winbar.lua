local M = {}

local devicons = require 'nvim-web-devicons'

local function should_show_winbar()
  local excluded_filetypes = {
    'NvimTree',
    'neo-tree',
    'help',
    'dashboard',
    'alpha',
    'toggleterm',
    'TelescopePrompt',
    'lazy',
    'packer',
    '',
  }

  local ft = vim.bo.filetype

  for _, ft_skip in ipairs(excluded_filetypes) do
    if ft == ft_skip then
      return false
    end
  end

  -- Optional: skip floating windows
  local cfg = vim.api.nvim_win_get_config(0)
  if cfg.relative ~= '' then
    return false
  end

  return true
end

vim.api.nvim_set_hl(0, 'WinbarBlock', { fg = '#82aaff', bg = 'none' })
vim.api.nvim_set_hl(0, 'WinbarLSP', { fg = '#1e2030', bg = '#82aaff' }) -- blue text
vim.api.nvim_set_hl(0, 'WinbarFiletype', { fg = '#1e2030', bg = '#82aaff' }) -- green text

M.clients_lsp = function()
  local bufnr = vim.api.nvim_get_current_buf()

  -- local clients = vim.lsp.buf_get_clients(bufnr)
  local clients = vim.lsp.get_clients { bufnr = bufnr }
  if next(clients) == nil then
    return ''
  end

  local c = {}
  for _, client in pairs(clients) do
    table.insert(c, client.name)
  end
  return '\u{f085} ' .. table.concat(c, '|')
end

M.get_lsp_names = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { bufnr = bufnr }
  if not clients or vim.tbl_isempty(clients) then
    return ''
  end

  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  return ' ' .. table.concat(names, ' | ')
end

M.get_filetype = function()
  local ft = vim.bo.filetype
  local fname = vim.api.nvim_buf_get_name(0)
  local icon, icon_color = devicons.get_icon_color(fname, nil, { default = true })

  if ft and ft ~= '' then
    return '%#WinbarFiletype#' .. icon .. ' ' .. ft
  end
  return ''
end

M.update_winbar = function()
  if not should_show_winbar() then
    vim.wo.winbar = ''
    return
  end

  local lsp = M.get_lsp_names()
  local ft = M.get_filetype()

  -- There is no lsp active but there if a filetype.
  -- In many cases this means that its a plugin window
  if lsp == '' then
    vim.wo.winbar = '%=%#WinbarBlock#' .. ft .. ' ' .. '%#WinbarBlock#'
    return
  end

  vim.wo.winbar = '%=%#WinbarBlock#' .. '%#WinbarLSP# ' .. lsp .. ' | ' .. ft .. ' ' .. '%#WinbarBlock#'
end

M.setup = function()
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'BufWritePost', 'LspAttach' }, {
    callback = function()
      pcall(M.update_winbar)
    end,
  })
end

return M
