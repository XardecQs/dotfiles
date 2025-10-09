require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>lc", "<cmd>VimtexCompile<CR>", { desc = "Compilar LaTeX" })
map("n", "<leader>lv", "<cmd>VimtexView<CR>", { desc = "Ver PDF" })
map("n", "<leader>lq", "<cmd>VimtexStop<CR>", { desc = "Detener compilación" })
map("n", "<leader>le", "<cmd>VimtexErrors<CR>", { desc = "Ver errores" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
