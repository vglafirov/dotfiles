-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set("n", "<Leader>gi", "<cmd>Neogit kind=split<cr>", { desc = "Open Neogit", remap = true })
vim.keymap.set(
  "n",
  "<leader>cv",
  "<cmd>Telescope neoclip a extra=star,plus,b<cr>",
  { desc = "Open clip manager", remap = true }
)
vim.keymap.set("n", "<M-K>", ":resize +1<CR>", { desc = "Resize Up", remap = true })
vim.keymap.set("n", "<M-J>", ":resize -1<CR>", { desc = "Resize Down", remap = true })
vim.keymap.set("n", "<M-L>", ":vertical resize -1<CR>", { desc = "Resize Left", remap = true })
vim.keymap.set("n", "<M-H>", ":vertical resize +1<CR>", { desc = "Resize Right", remap = true })
vim.keymap.set("n", ",", ":", { desc = "Cmd", remap = true })
vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer", remap = true })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer", remap = true })
