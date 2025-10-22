-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Direct terminal mode mapping for Ctrl-l to clear terminal
local function clear_terminal()
  local buf_id = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(buf_id)

  if buf_name:match "term://" then
    local job_id = vim.b.terminal_job_id
    if job_id then
      -- Send the 'clear' command followed by Enter instead of Ctrl-l
      -- This is more reliable as it works with any shell
      vim.fn.chansend(job_id, "clear\r")
    else
      vim.notify("No terminal job found!", vim.log.levels.WARN)
    end
  else
    vim.notify("Not a terminal buffer!", vim.log.levels.WARN)
  end
end

-- Set the mapping directly in terminal mode
vim.keymap.set("t", "<C-l>", clear_terminal, { noremap = true, silent = true, desc = "Clear terminal" })
