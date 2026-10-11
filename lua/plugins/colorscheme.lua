return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true, bold = true },
        functions = { bold = true },
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      on_colors = function(colors)
        -- Deep Obsidian Dark palette
        colors.bg = "#0a0c10"
        colors.bg_dark = "#06080b"
        colors.bg_float = "#0d1017"
        colors.bg_popup = "#0d1017"
        colors.bg_sidebar = "#080a0e"
        colors.bg_statusline = "#080a0e"
        colors.bg_highlight = "#161b26"
        colors.border = "#1f2937"
      end,
      on_highlights = function(hl, c)
        -- High-clarity OOP syntax highlighting (Classes, Interfaces, Methods, Properties)
        hl["@type"] = { fg = "#2ac3de", bold = true }
        hl["@type.builtin"] = { fg = "#2ac3de", italic = true }
        hl["@constructor"] = { fg = "#ff9e64", bold = true }
        hl["@function.method"] = { fg = "#7aa2f7", bold = true }
        hl["@function.method.call"] = { fg = "#7aa2f7" }
        hl["@variable.member"] = { fg = "#73daca" }
        hl["@property"] = { fg = "#73daca" }
        hl["@keyword.type"] = { fg = "#bb9af7", bold = true }
        hl["@keyword.modifier"] = { fg = "#bb9af7", italic = true }
        hl.WinSeparator = { fg = "#1f2937", bold = true }
        hl.CursorLine = { bg = "#131722" }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
