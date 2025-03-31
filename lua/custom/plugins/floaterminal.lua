-- This saves our state
local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

-- Function that creates the floating window terminal and all the configurations
local function create_floating_window(opts)
  local width = opts and opts.width or math.floor(vim.o.columns * 0.85)
  local height = opts and opts.height or math.floor(vim.o.lines * 0.75)

  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create the buffer and check to see if one exists already
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- Create a scratch buffer
  end

  -- Create the window config
  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

-- Create the function to determine what to do with the buffer
local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
  -- This command avoids pressing 'i' every time the floating terminal popups
  vim.cmd 'normal i'
end

-- Setup keymaps
vim.keymap.set({ 'n', 't' }, '<leader>tt', toggle_terminal, { desc = 'Toggle floating terminal' })
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')

-- Setup the command to call the floating window
vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {})
-- return {
--   dir = vim.fn.stdpath 'config' .. '/lua/custom/plugins/floaterminal.lua',
--   lazy = true,
--   config = function()
--   end,
-- }
