return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function() vim.cmd.colorscheme("catppuccin") end,
  opts = {
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = { -- :h background
      light = "latte",
      dark = "mocha",
    },
    transparent_background = false,
    show_end_of_buffer = false, -- show the '~' characters after the end of buffers
    term_colors = false,
    dim_inactive = {
      enabled = false,
      shade = "dark",
      percentage = 0.15,
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    color_overrides = {},
    custom_highlights = function(colors)
      return {
        WhichKey = { bg = colors.mantle },
        WhichKeyFloat = { bg = colors.mantle },
        TreesitterContext = { bg = colors.mantle },
        TreesitterContextLineNumber = { bg = colors.mantle, fg = colors.red },
        TreesitterContextBottom = { style = {} },
        NormalFloat = { bg = colors.none },
        VertSplit = { fg = colors.mantle, bg = colors.mantle },
        MiniTrailspace = { bg = colors.red },

        FlashCurrent = { bg = colors.peach, fg = colors.base },
        FlashLabel = { bg = colors.red, bold = true, fg = colors.base },
        FlashMatch = { bg = colors.blue, fg = colors.base },
        FlashCursor = { reverse = true },
      }
    end,
    integrations = {
      aerial = true,
      alpha = true,
      cmp = true,
      dashboard = true,
      flash = true,
      gitsigns = true,
      harpoon = true,
      headlines = true,
      illuminate = true,
      indent_blankline = { enabled = true },
      leap = true,
      lsp_trouble = true,
      mason = true,
      markdown = true,
      mini = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      navic = { enabled = true, custom_bg = "lualine" },
      neotest = true,
      neotree = true,
      noice = true,
      notify = true,
      semantic_tokens = true,
      telescope = true,
      treesitter = true,
      treesitter_context = true,
      which_key = true,
    },
  },
}