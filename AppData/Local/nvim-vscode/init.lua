local vscode = require("vscode-neovim")

-- [[ Setting options ]]
-- See `:help vim.opt`
vim.opt.laststatus = 3 -- Always show statusline

-- Sane defaults for tabs and spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Set highlight on search
vim.opt.hlsearch = true

-- Make line numbers default
vim.wo.number = true
-- vim.opt.relativenumber = true

-- Enable break indent
vim.opt.breakindent = true

-- Enable / Disable backup files
vim.opt.swapfile = false
vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand("~/nvim-backup-folder")

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 50

-- Set colorscheme
vim.opt.background = "dark"
vim.opt.termguicolors = true

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noselect"

-- Highlight current linenumber
vim.opt.cursorline = true

-- Color column
vim.opt.colorcolumn = "120"

-- Spelling
vim.opt.spell = false
vim.opt.spelllang = "en_us"

-- Clipboard
-- vim.opt.clipboard = "unnamedplus"

-- Always show the signcolumn, otherwise it would shift the text each time
vim.wo.signcolumn = "yes"

-- We don't need to see things like -- INSERT -- anymore
vim.opt.showmode = false

-- Better splits when opening buffers
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Set guifont
vim.opt.guifont = "Consolas:h9"

-- Line wrap
vim.opt.wrap = false

-- File Format
vim.opt.fileformat = "unix"

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })
vim.keymap.set("n", "j", 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })

-- Pasting will not replace the current register with what is selected
vim.keymap.set("x", "p", '"_dP')

-- Copy to system clipboard
vim.keymap.set("x", "<C-c>", '"+y')

-- Move lines up and down with J and K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keeps cursor on the same spot on K
vim.keymap.set("n", "J", "mzJ`z")

-- [[ VSCode Keymaps ]]
-- Global
vim.keymap.set("n", "-", function() vscode.action("workbench.files.action.focusFilesExplorer") end)

vim.keymap.set("n", "<localleader>q", function() vscode.action("workbench.action.togglePanel") end)
vim.keymap.set({ "x", "n" }, "<C-v>", function() vscode.action("editor.action.clipboardPasteAction") end)

-- Diagnostics
vim.keymap.set("n", "[d", function() vscode.action("editor.action.marker.next") end)
vim.keymap.set("n", "]d", function() vscode.action("editor.action.marker.prev") end)
vim.keymap.set("n", "[e", function() vscode.action("editor.action.marker.next") end)
vim.keymap.set("n", "]e", function() vscode.action("editor.action.marker.prev") end)

-- Formatting
vim.keymap.set("x", "=", function() vscode.action("editor.action.formatSelection") end)
vim.keymap.set("n", "==", function() vscode.action("editor.action.formatSelection") end)

-- Find in files
vim.keymap.set("n", "<leader>/", function() vscode.action("workbench.action.findInFiles") end)
vim.keymap.set({ "x", "n" }, "<leader>*", function() vscode.action("workbench.action.findInFiles") end)

-- Copilot keymaps
-- vim.keymap.set("n", "<leader>cc", function() vscode.action("workbench.action.toggleAuxiliaryBar") end)
vim.keymap.set({ "n", "x" }, "<leader>cc", function() vscode.action("workbench.action.chat.openInEditor") end)
vim.keymap.set({ "n", "x" }, "<leader>ch", function() vscode.action("workbench.panel.chat.view.copilot.focus") end)
vim.keymap.set({ "n", "x" }, "<leader>ci", function() vscode.action("workbench.action.quickchat.toggle") end)
vim.keymap.set({ "n", "x" }, "<leader>cl", function() vscode.action("inlineChat.start") end)

-- Buffers
vim.keymap.set("n", "<leader>bb", function() vscode.action("workbench.action.showAllEditors") end)

-- LSP keymaps
vim.keymap.set("n", "cn", function() vscode.action("editor.action.rename") end)
vim.keymap.set("n", "gd", function() vscode.action("editor.action.referenceSearch.trigger") end)
vim.keymap.set("n", "gr", function() vscode.action("editor.action.revealDefinition") end)
vim.keymap.set("n", "gi", function() vscode.action("editor.action.goToImplementation") end)
vim.keymap.set("n", "gt", function() vscode.action("editor.action.goToTypeDefinition") end)

vim.keymap.set("n", "K", function() vscode.action("editor.action.showHover") end)
vim.keymap.set("n", "gh", function() vscode.action("editor.action.showHover") end)

-- Git keymaps
vim.keymap.set("n", "<leader>gg", function() vscode.action("workbench.view.scm") end)
vim.keymap.set("n", "]g", function() vscode.action("workbench.action.editor.nextChange") end)
vim.keymap.set("n", "[g", function() vscode.action("workbench.action.editor.previousChange") end)
vim.keymap.set("n", "<leader>gr", function() vscode.action("git.revertSelectedRanges") end)
vim.keymap.set("n", "<leader>gR", function() vscode.action("git.clean") end)
vim.keymap.set("n", "<leader>gs", function() vscode.action("git.openChange") end)
vim.keymap.set("n", "<leader>gp", function() vscode.action("git.openChange") end)

-- Commenting
vim.keymap.set("n", "gcc", function() vscode.action("editor.action.commentLine") end)
vim.keymap.set("v", "gc", function() vscode.action("editor.action.commentLine") end)

-- Source this file
vim.keymap.set("n", "<leader>so", "<cmd>source ~/AppData/Local/nvim/lua/vscode/init.lua<cr>")

print("nvim-vscode successfully loaded")
