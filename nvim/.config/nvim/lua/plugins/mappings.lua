local function open_terminal(direction)
  if direction == "horizontal" then
    vim.cmd "split" -- Open a horizontal split
  elseif direction == "vertical" then
    vim.cmd "vsplit" -- Open a vertical split
  elseif direction == "full_screen" then
    vim.cmd "enew | terminal" -- Open a new full-screen terminal
    vim.cmd "resize | vertical resize" -- Maximize the terminal
    vim.cmd "normal i"
    return -- Exit as the terminal is already opened
  else
    print "Invalid direction! Use 'horizontal', 'vertical', or 'full_screen'."
    return
  end

  -- Open the terminal in the created split
  vim.cmd "terminal"
end

local terminal_buffers = {} -- Store terminal buffers by buffer ID

local function toggle_current_terminal()
  local buf_id = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(buf_id)

  -- Check if the current buffer is a terminal
  if buf_name:match "term://" then
    -- If the buffer is already hidden, re-open it
    if terminal_buffers[buf_id] then
      vim.cmd("buffer " .. buf_id) -- Switch back to the terminal buffer
      terminal_buffers[buf_id] = nil -- Remove from the hidden list
    else
      -- Hide the terminal buffer
      vim.cmd "hide"
      terminal_buffers[buf_id] = true -- Mark this buffer as hidden
    end
  else
    print "Not a terminal buffer!"
  end
end

local function close_current_terminal()
  local buf_id = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(buf_id)

  -- Check if the current buffer is a terminal
  if buf_name:match "term://" then
    vim.cmd "bdelete!" -- Force close the terminal buffer
  else
    print "Not a terminal buffer!"
  end
end

return {
  { "echasnovski/mini.icons", version = "*" },
  { "echasnovski/mini.nvim", version = "*" },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- first key is the mode
        n = {
          -- second key is the lefthand side of the map
          -- mappings seen under group name "Buffer"
          [","] = { ":", desc = "enter command mode" },
          ["<Leader>gi"] = { "<cmd>Neogit kind=split<cr>", desc = "Open Neogit" },
          -- ["<leader>fp"] = { "<cmd>Telescope neovim-project discover<cr>", desc = "Open projects" },
          ["<leader>fu"] = { "<cmd>Telescope undo<cr>", desc = "Open undo history" },
          ["<leader>fd"] = { "<cmd>Telescope dir live_grep<cr>", desc = "Grep in current directory" },
          ["<leader>cc"] = { "<cmd>Telescope neoclip a extra=star,plus,b<cr>", desc = "Open clip manager" },
          ["<leader>ld"] = {
            function() require("telescope.builtin").lsp_definitions() end,
            desc = "Jump to definition",
          },
          ["<leader>fp"] = {
            function()
              require("telescope").extensions.project.project {
                display_type = "full",
                hide_workspace = true,
              }
            end,
            desc = "Open project",
          },

          ["<leader>lr"] = {
            function() require("telescope.builtin").lsp_references() end,
            desc = "Find references",
          },
          ["<Tab>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
          ["<S-Tab>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
          ["<Leader>T"] = { ":tabnew<CR>", desc = "Open new tab" },
          ["<Leader>D"] = { ":tabclose<CR>", desc = "Close current tab" },
          ["<C-N>"] = { ":tabnext<CR>", desc = "Next tab" },
          ["<C-P>"] = { ":tabprevious<CR>", desc = "Previous tab" },
          ["<M-K>"] = { ":resize +1<CR>", desc = "Resize Up" },
          ["<M-J>"] = { ":resize -1<CR>", desc = "Resize Down" },
          ["<M-L>"] = { ":vertical resize -1<CR>", desc = "Resize Left" },
          ["<M-H>"] = { ":vertical resize +1<CR>", desc = "Resize Right" },
          ["<Leader>tf"] = {
            function() open_terminal "full_screen" end,
            desc = "Open terminal in full screen",
          },
          ["<Leader>th"] = {
            function() open_terminal "horizontal" end,
            desc = "Open new horizontal terminal",
          },
          ["<Leader>tv"] = {
            function() open_terminal "vertical" end,
            desc = "Open new vertical terminal",
          },

          ["<Leader>lg"] = { "<Plug>(GitLabToggleCodeSuggestions)", desc = "Toggle GitLabToggleCodeSuggestions" },
          ["<leader>cb"] = { ":Telescope keymaps<CR>", desc = "Search keybindings" },
          ["<leader>no"] = { function() require("notion").openMenu() end, desc = "Notion menu" },
          ["<Leader>bD"] = {
            function()
              require("astroui.status").heirline.buffer_picker(
                function(bufnr) require("astrocore.buffer").close(bufnr) end
              )
            end,
            desc = "Pick to close",
          },
          -- tables with just a `desc` key will be registered with which-key if it's installed
          -- this is useful for naming menus
          ["<Leader>b"] = { desc = "Buffers" },
          ["<Leader>a"] = { desc = "AI" },
        },
        t = {
          ["<Esc>"] = { "<C-\\><C-n>", desc = "Exit terminal mode" },
          -- ["<C-l>"] = { "<C-\\><C-n>iclear<CR>", noremap = true, silent = true, desc = "Clear terminal screen" },
          -- ["<C-l>"] = { "<C-\\><C-n>:call feedkeys('<C-l>')<CR>a", desc = "Clear terminal screen" },
          ["<C-l>"] = { "<C-\\><C-n>i<C-l>", desc = "Clean terminal window" },
          -- Toggle the current terminal using the custom function
          ["<Esc><Esc>"] = {
            function() toggle_current_terminal() end,
            desc = "Toggle current terminal",
          },
          ["<Esc>q"] = {
            function() close_current_terminal() end,
            desc = "Toggle current terminal",
          },

          -- setting a mapping to false will disable it
          -- ["<esc>"] = false,
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      mappings = {
        n = {
          -- this mapping will only be set in buffers with an LSP attached
          K = {
            function() vim.lsp.buf.hover() end,
            desc = "Hover symbol details",
          },
          -- condition for only server with declaration capabilities
          gD = {
            function() vim.lsp.buf.declaration() end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
          },
        },
      },
    },
  },
}
