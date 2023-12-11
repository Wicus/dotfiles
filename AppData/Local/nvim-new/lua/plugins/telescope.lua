return {
  -- Fuzzy Finder (files, lsp, etc)
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
  opts = function()
    return {
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
    }
  end,
}
