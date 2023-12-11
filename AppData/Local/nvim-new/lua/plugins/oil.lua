-- A vim-vinegar like file explorer that lets you edit your filesystem like a normal Neovim buffer.
return {
  "stevearc/oil.nvim",
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  opts = {
    keymaps = {
      ["q"] = "actions.close",
      ["g-"] = function() end,
      ["<C-p>"] = false,
    },
    columns = {},
  },
}
