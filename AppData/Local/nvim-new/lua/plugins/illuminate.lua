-- Automatically highlights other instances of the word under your cursor.
-- This works with LSP, Treesitter, and regexp matching to find the other
-- instances.
return {
  "RRethy/vim-illuminate",
  opts = {
    delay = 200,
    large_file_cutoff = 2000,
    large_file_overrides = {
      providers = { "lsp" },
    },
    providers = {
      "regex",
      "treesitter",
      "lsp",
    },
    filetypes_denylist = {
      "dirvish",
      "fugitive",
      "neo-tree",
    },
  },
  config = function(_, opts) require("illuminate").configure(opts) end,
}
