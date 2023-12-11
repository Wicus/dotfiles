local is_windows = string.lower(vim.loop.os_uname().sysname) == "windows_nt"

require("packer").startup(function(use)
  -- Github Copilot
  use("github/copilot.vim")

  use("nvim-treesitter/nvim-treesitter-context")
  use("stevearc/dressing.nvim") -- Extend core UI hooks (vim.ui.select and vim.ui.input) with floating windows
  use("mbbill/undotree") -- Undo tree
  use("nvim-lualine/lualine.nvim") -- Fancier statusline
  use("lukas-reineke/indent-blankline.nvim") -- Add indentation guides even on blank lines
  use("numToStr/Comment.nvim") -- "gc" to comment visual regions/lines
  use("tpope/vim-sleuth") -- Detect tabstop and shiftwidth automatically
  use("mhartington/formatter.nvim") -- Formatting
  use("tpope/vim-surround") -- Surround text objects with quotes, brackets, etc
  use("ThePrimeagen/harpoon") -- Manage multiple buffers and jump between them easily
  use("shortcuts/no-neck-pain.nvim") -- Dead simple plugin to center the currently focused buffer to the middle of the screen.
  use("Vonr/align.nvim") -- A minimal plugin for aligning lines
  use("norcalli/nvim-colorizer.lua") -- Highlight color codes in files
  use("nvim-pack/nvim-spectre") -- A code search and replace tool
  use("echasnovski/mini.trailspace") -- Work with trailing whitespaces
  use("echasnovski/mini.bufremove") -- Remove buffers
  use({
    "folke/which-key.nvim",
    config = function()
      vim.opt.timeout = true
      vim.opt.timeoutlen = 300
      require("which-key").setup({
        plugins = {
          registers = false,
        },
      })
    end,
  })
  use("stevearc/oil.nvim")
  use("folke/flash.nvim") -- flash.nvim lets you navigate your code with search labels, enhanced character motions, and Treesitter integration.

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, "custom.plugins")
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require("packer").sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn"t
-- make sense to execute the rest of the init.lua.
--
-- You"ll need to restart nvim, and then it will work.
if is_bootstrap then
  print("==================================")
  print("    Plugins are being installed")
  print("    Wait until Packer completes,")
  print("       then restart nvim")
  print("==================================")
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  command = "source <afile> | PackerCompile",
  group = packer_group,
  pattern = vim.fn.expand("$MYVIMRC"),
})

-- [[ Setting globals ]]
-- See `:help vim.g`
vim.g.copilot_filetypes = { TelescopePrompt = false, text = false }
vim.g.undotree_SplitWidth = 42
vim.g.undotree_SetFocusWhenToggle = 1

-- [[ Setting options ]]
-- See `:help vim.opt`
vim.opt.laststatus = 3 -- Always show statusline

-- Sane defaults for tabs and spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Set highlight on search to false
vim.opt.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.opt.relativenumber = true

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

-- [[ Setting wsl clipboard ]]
-- Set clipboard in wsl to be able to copy to windows and wsl clipboard
-- See `:help clipboard`
if vim.fn.has("wsl") then
  -- Command to fix interpreter not found (https://github.com/microsoft/WSL/issues/5466):
  -- `sudo update-binfmts --disable cli`
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

-- Set border for floating windows
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers["textDocument/hover"], { border = "single" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers["textDocument/signatureHelp"], { border = "single" })
vim.diagnostic.config({ float = { border = "single" } })

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local function get_visual_selected()
  vim.cmd('normal "vy')
  return vim.fn.getreg("v") or ""
end
local function get_work_under_cursor()
  vim.cmd('normal viw"vy')
  return vim.fn.getreg("v") or ""
end

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
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

-- Keep centered while scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "*", "*zzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- File tree navigation
vim.keymap.set("n", "-", require("oil").open, { desc = "[-] Open parent directory" })

-- Buffer commands
vim.keymap.set("n", "<leader>bd", function()
  local bd = require("mini.bufremove").delete
  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 1 then -- Yes
      vim.cmd.write()
      bd(0)
    elseif choice == 2 then -- No
      bd(0, true)
    end
  else
    bd(0)
  end
end, { desc = "[B]uffer [D]elete" })

-- Harpoon keymaps
vim.keymap.set("n", "<leader>fa", require("harpoon.mark").add_file, { desc = "[F]ile [A]dd: Harpoon add file" })
vim.keymap.set("n", "<leader>0", require("harpoon.ui").toggle_quick_menu, { desc = "[0] Harpoon quick menu" })
vim.keymap.set("n", "<leader>1", function() require("harpoon.ui").nav_file(1) end, { desc = "[1] Harpoon file 1" })
vim.keymap.set("n", "<leader>2", function() require("harpoon.ui").nav_file(2) end, { desc = "[2] Harpoon file 2" })
vim.keymap.set("n", "<leader>3", function() require("harpoon.ui").nav_file(3) end, { desc = "[3] Harpoon file 3" })
vim.keymap.set("n", "<leader>4", function() require("harpoon.ui").nav_file(4) end, { desc = "[4] Harpoon file 4" })
vim.keymap.set("n", "<leader>5", function() require("harpoon.ui").nav_file(5) end, { desc = "[5] Harpoon file 5" })

-- Toggle commands
vim.keymap.set("n", "<leader>ts", "<cmd>set invspell<cr>", { desc = "[T]oggle [S]pell" })

-- Search and replace commands
vim.keymap.set({ "n", "x" }, "<leader>cgn", function() vim.fn.feedkeys("*Ncgn") end, { desc = "Search current word / selection and change it (cgn)" })
vim.keymap.set("n", "<leader>sr", require("spectre").open, { desc = "[S]earch and [R]eplace" })

-- Stay in visual mode after indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Resize window
vim.keymap.set("n", "<C-Up>", "<cmd>resize -2<cr>")
vim.keymap.set("n", "<C-Down>", "<cmd>resize +2<cr>")
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize -2<cr>")
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize +2<cr>")

local function is_quickfix_open()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      return true
    end
  end

  return false
end

-- Quickfix
vim.keymap.set("n", "<localleader>q", function()
  if is_quickfix_open() then
    vim.cmd("cclose")
  else
    vim.cmd("botright copen")
  end
end, { desc = "[Q]uickfix toggle" })
vim.keymap.set("n", "<C-p>", function()
  if is_quickfix_open() then
    vim.cmd("cprevious")
  else
    require("telescope.builtin").find_files()
  end
end, { desc = "<C-p> Find Files" })
vim.keymap.set("n", "<C-n>", function()
  if is_quickfix_open() then
    vim.cmd("cnext")
  end
end)

vim.keymap.set("n", "<leader>zf", function()
  vim.cmd.normal("va}")
  vim.cmd.normal("zf")
end, { desc = "Create bracket {} fold [Z] [F]old" })

vim.keymap.set("n", "<leader>u", function()
  vim.cmd("NoNeckPain")
  vim.cmd("UndotreeToggle")
  vim.cmd("NoNeckPain")
end, { desc = "[U]ndo tree toggle" })

-- [[ Autocommands ]]
-- Highlight on yank
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      timeout = 40,
    })
  end,
  group = highlight_group,
  pattern = "*",
})

-- Format on save autocommand
local formatting_group = vim.api.nvim_create_augroup("FormattingGroup", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  command = "FormatWriteLock",
  group = formatting_group,
  pattern = {
    "*.tsx",
    "*.ts",
    "*.jsx",
    "*.js",
    "*.lua",
    "*.cs",
    "*.cpp",
    "*.hpp",
    "*.json",
  },
})

-- [[ User Commands ]]
-- see `:help vim.api.nvim_create_user_command()`
-- TODO
-- Align commands
-- Just create a user command for this
-- vim.api.nvim_create_user_command("Align", function() require("align").align_to_char({) end, { desc = "[W]rite [A]ll" })
-- require("align").align_to_char(1, true)
vim.api.nvim_create_user_command("Wa", "wa", { desc = "[W]rite [A]ll" })

local catppuccin_colors = require("catppuccin.palettes").get_palette("mocha")
local getCustomCatppuccinTheme = function()
  local catppuccin_theme = require("lualine.themes.catppuccin")
  catppuccin_theme.normal.b.bg = catppuccin_colors.mantle
  catppuccin_theme.insert.b.bg = catppuccin_colors.mantle
  catppuccin_theme.visual.b.bg = catppuccin_colors.mantle
  catppuccin_theme.command.b.bg = catppuccin_colors.mantle
  catppuccin_theme.replace.b.bg = catppuccin_colors.mantle

  return catppuccin_theme
end

-- [[ Plugins setup ]]
-- Set lualine as statusline
-- See `:help lualine.txt`
require("lualine").setup({
  options = {
    icons_enabled = false,
    theme = getCustomCatppuccinTheme(),
    component_separators = "|",
    section_separators = "",
    disabled_filetypes = {},
  },
  sections = {
    lualine_c = {},
  },
  winbar = {
    lualine_b = { { "filename", path = 1, color = { fg = catppuccin_colors.lavender } } },
  },
  inactive_winbar = {
    lualine_b = { { "filename", path = 1 } },
  },
})

-- Enable Comment.nvim
require("Comment").setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help ibl.txt`
require("ibl").setup({
  indent = { char = "│" },
  scope = { enabled = false },
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<Up>"] = require("telescope.actions").cycle_history_prev,
        ["<Down>"] = require("telescope.actions").cycle_history_next,
      },
    },
    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    path_display = function(opts, path)
      local tail = require("telescope.utils").path_tail(path)
      local relative_path = vim.fn.fnamemodify(path, ":.:h")
      return string.format("%s (%s)", tail, relative_path)
    end,
  },
  pickers = {
    live_grep = {
      mappings = {
        i = { ["<c-f>"] = require("telescope.actions").to_fuzzy_refine },
      },
    },
  },
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set(
  "n",
  "<leader>fr",
  function() require("telescope.builtin").oldfiles({ cwd_only = true }) end,
  { desc = "[F]ile [R]ecent: Find recently opened files" }
)

vim.keymap.set("n", "<leader>bb", require("telescope.builtin").buffers, { desc = "[B]uffers [B]uffers: Find existing buffers" })

local glob_pattern = {
  "!src/shared/dygraphs/**",
  "!src/shared/canvas-gauges/**",
}

vim.keymap.set(
  "n",
  "<leader>/",
  function()
    require("telescope.builtin").live_grep({
      glob_pattern = glob_pattern,
      additional_args = { "--fixed-strings" },
    })
  end,
  { desc = "[/]: Search in project" }
)

vim.keymap.set(
  "n",
  "<leader>*",
  function()
    require("telescope.builtin").live_grep({
      default_text = get_work_under_cursor(),
      glob_pattern = glob_pattern,
      additional_args = { "--case-sensitive", "--fixed-strings", "--word-regexp" },
    })
  end,
  { desc = "[*]: Search current word in project (Case Sensitive)" }
)

vim.keymap.set(
  "v",
  "<leader>*",
  function()
    require("telescope.builtin").live_grep({
      default_text = get_visual_selected(),
      glob_pattern = glob_pattern,
      additional_args = { "--case-sensitive", "--fixed-strings", "--word-regexp" },
    })
  end,
  { desc = "[*]: Search current word in project (Case Sensitive) (Word Boundary)" }
)

vim.keymap.set("n", "<leader>gg", require("telescope.builtin").git_status, { desc = "[G][G]it files" })
vim.keymap.set("n", "<leader>sl", require("telescope.builtin").resume, { desc = "[S]ession [L]ast (resume telescope)" })
vim.keymap.set("n", "<leader>ff", "<cmd>FormatWriteLock<cr>", { desc = "[F]ormat [F]ile" })

-- Diagnostic keymaps
vim.keymap.set("n", "gh", vim.diagnostic.open_float, { desc = "[G]oto diagnostic [H]elp: List diagnostic under cursor" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous [D]iagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next [D]iagnostic" })
vim.keymap.set("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity["ERROR"] }) end, { desc = "Previous [E]rror" })
vim.keymap.set("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity["ERROR"] }) end, { desc = "Next [E]rror" })
vim.keymap.set("n", "[w", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity["WARN"] }) end, { desc = "Previous [W]arning" })
vim.keymap.set("n", "]w", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity["WARN"] }) end, { desc = "Next [W]arning" })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  local imap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("i", keys, func, { buffer = bufnr, desc = desc })
  end

  -- Has a AutoHotKey script to change this to <C-.> for windows
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ctions")
  nmap("cn", vim.lsp.buf.rename, "[C]hange [N]ame (Rename)")
  nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
  nmap("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype definition")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  imap("<C-k>", vim.lsp.buf.signature_help, "Signature Help")

  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_) vim.lsp.buf.format() end, { desc = "Format current buffer with LSP" })

  -- Omnisharp specific settings
  if client.name == "omnisharp" then
    nmap("gd", require("omnisharp_extended").telescope_lsp_definitions, "[G]oto [D]efinition")

    -- Omnisharp Semantic tokens do not conform to the LSP specification
    -- For more details: https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1546721190
    local function toSnakeCase(str) return string.gsub(str, "%s*[- ]%s*", "_") end
    local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
    for i, v in ipairs(tokenModifiers) do
      tokenModifiers[i] = toSnakeCase(v)
    end
    local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
    for i, v in ipairs(tokenTypes) do
      tokenTypes[i] = toSnakeCase(v)
    end
  end
end

local get_omnisharp_settings = function()
  -- enable_roslyn_analyzers = true,
  local settings = {
    handlers = { ["textDocument/definition"] = require("omnisharp_extended").handler },
  }
  if is_windows then
    settings = vim.tbl_deep_extend("force", settings, {
      cmd = { "cmd", "/c", "omnisharp" },
    })
  end
  return settings
end

local servers = {
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
  tsserver = {},
  eslint = {},
  clangd = {
    capabilities = {
      offsetEncoding = { "utf-16" },
    },
  },
  pyright = {},
  omnisharp = get_omnisharp_settings(),
  jsonls = {},
  intelephense = {},
  html = {},
  cssls = {},
  tailwindcss = {},
  lemminx = {},
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    local setup = {
      capabilities = capabilities,
      on_attach = on_attach,
    }
    local server_settings = servers[server_name]

    setup = vim.tbl_deep_extend("force", setup, server_settings)

    require("lspconfig")[server_name].setup(setup)
  end,
})

-- Turn on lsp status information
require("fidget").setup()

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_kinds = {
  Text = "  ",
  Method = "  ",
  Function = "  ",
  Constructor = "  ",
  Field = "  ",
  Variable = "  ",
  Class = "  ",
  Interface = "  ",
  Module = "  ",
  Property = "  ",
  Unit = "  ",
  Value = "  ",
  Enum = "  ",
  Keyword = "  ",
  Snippet = "  ",
  Color = "  ",
  File = "  ",
  Reference = "  ",
  Folder = "  ",
  EnumMember = "  ",
  Constant = "  ",
  Struct = "  ",
  Event = "  ",
  Operator = "  ",
  TypeParameter = "  ",
}

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  window = {
    completion = cmp.config.window.bordered({
      border = "single",
    }),
    documentation = cmp.config.window.bordered({
      border = "single",
    }),
  },
  formatting = {
    format = function(_, vim_item)
      vim_item.kind = (cmp_kinds[vim_item.kind] or "") .. vim_item.kind
      local label = vim_item.abbr
      local truncated_label = vim.fn.strcharpart(label, 0, 50)
      if truncated_label ~= vim_item.abbr then
        vim_item.abbr = truncated_label .. "..."
      end
      return vim_item
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-u>"] = cmp.mapping.scroll_docs(4),
    -- Has a AutoHotKey script to change this to <C-Space>
    ["<C-l>"] = cmp.mapping.complete({}),
    ["<C-y>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "spell" },
    { name = "nvim_lua" },
  },
})

-- Snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- TODO: Make this auto install with mason
local formatters = {
  "stylua",
  "prettierd",
  "clang-format",
}

-- Formatter setup
require("formatter").setup({
  filetype = {
    lua = { require("formatter.filetypes.lua").stylua },
    javascript = { require("formatter.filetypes.javascript").prettierd },
    javascriptreact = { require("formatter.filetypes.javascriptreact").prettierd },
    typescript = { require("formatter.filetypes.typescript").prettierd },
    typescriptreact = { require("formatter.filetypes.typescriptreact").prettierd },
    h = { require("formatter.defaults").clangformat },
    c = { require("formatter.defaults").clangformat },
    cpp = { require("formatter.defaults").clangformat },
    hpp = { require("formatter.defaults").clangformat },
    cs = vim.lsp.buf.format,
    python = vim.lsp.buf.format,
    json = { require("formatter.filetypes.json").prettierd },
    xml = vim.lsp.buf.format,
  },
})

-- Colorizer setup
require("colorizer").setup()

-- Oil setup
require("oil").setup({
  keymaps = {
    ["q"] = "actions.close",
    ["g-"] = function()
      if is_windows then
        require("oil.actions").tcd.callback()
        vim.cmd("silent !explorer .")
      end
    end,
    ["<C-p>"] = false,
  },
  columns = {},
})

-- No neck pain setup
require("no-neck-pain").setup({
  width = 180,
  autocmds = {
    enableOnVimEnter = true,
  },
  buffers = {
    right = {
      enabled = false,
    },
    colors = {
      blend = -0.2,
    },
    scratchPad = {
      enabled = false,
    },
  },
  mappings = {
    enabled = true,
    toggle = "<leader>zm",
  },
})

-- Dressing setup
require("dressing").setup({
  input = {
    insert_only = true, -- Closes the window when leaving insert mode
    start_in_insert = false,
    title_pos = "center",
    win_options = {
      winblend = 0,
    },
    border = "single",
  },
  select = {
    telescope = require("telescope.themes").get_dropdown({
      borderchars = {
        prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
        results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
        preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      },
    }),
  },
})

-- Harpoon setup
require("harpoon").setup({
  menu = {
    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    -- width = vim.api.nvim_win_get_width(0) - 140,
  },
})

-- Mini TrailSpace setup
require("mini.trailspace").setup()

-- Treesitter Context setup
require("treesitter-context").setup({
  enable = true,
  max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
})

-- Spectre config
local spectre_sed_args = require("spectre.config").replace_engine.sed.args
spectre_sed_args[#spectre_sed_args + 1] = "-b"

-- Flash config
require("flash").setup()

vim.keymap.set({ "n", "x", "o" }, "r", function() require("flash").jump() end)
vim.keymap.set({ "c" }, "<c-s>", function() require("flash").toggle() end)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
