vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 8
vim.opt.number = true
vim.opt.relativenumber = true

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", ":Vex<CR>", { noremap = true, silent = true, desc = "Create project view window"}) 
vim.keymap.set("n", "<leader><CR>", ":so ~/.config/nvim/init.lua", { noremap = true, silent = true, desc = "Reload configuration"})
