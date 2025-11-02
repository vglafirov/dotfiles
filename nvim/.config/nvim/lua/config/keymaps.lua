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

vim.keymap.set("n", "<leader>o", "", { desc = "OpenCode" })

vim.keymap.set({ "n", "x" }, "<leader>ot", function()
  require("opencode").ask("@this: ", { submit = true })
end, { desc = "Ask opencode" })
vim.keymap.set({ "n", "x" }, "<leader>ox", function()
  require("opencode").select()
end, { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "x" }, "<leader>oa", function()
  require("opencode").prompt("@this")
end, { desc = "Add to opencode" })
vim.keymap.set({ "n", "x" }, "<leader>o.", function()
  require("opencode").toggle()
end, { desc = "Toggle opencode" })
vim.keymap.set({ "n", "x" }, "<leader>ou", function()
  require("opencode").command("session.half.page.up")
end, { desc = "opencode half page up" })
vim.keymap.set({ "n", "x" }, "<leader>od", function()
  require("opencode").command("session.half.page.down")
end, { desc = "opencode half page down" })
