return {
  -- 1. Integrated Terminal like VS Code (Ctrl + \ or F5 runner)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = function(term)
        local is_termux = vim.fn.isdirectory("/data/data/com.termux") == 1 or vim.env.TERMUX_VERSION ~= nil
        if term.direction == "horizontal" then
          return is_termux and 10 or 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = false,
      shell = vim.fn.has("win32") == 1
          and (vim.fn.executable("pwsh") == 1 and "pwsh -NoLogo" or "powershell -NoLogo")
        or (vim.env.SHELL or "bash"),
      float_opts = {
        border = "curved",
        winblend = 0,
      },
    },
  },

  -- 2. File Explorer (Neo-tree) tuned like VS Code Sidebar
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = (vim.fn.isdirectory("/data/data/com.termux") ~= 1),
      },
      window = {
        width = 32,
        mappings = {
          ["<space>"] = "none",
          ["t"] = "close_window",
          ["<cr>"] = "open",
        },
      },
    },
  },

  -- 3. Always visible top Tab Bar like VS Code
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        diagnostics = "nvim_lsp",
        separator_style = "thin",
        offsets = {
          {
            filetype = "neo-tree",
            text = "EXPLORER",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  -- 4. Treesitter syntax highlighting for all OOP & web languages
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      local ok, ts_install = pcall(require, "nvim-treesitter.install")
      if ok and ts_install then
        ts_install.prefer_git = false
        ts_install.compilers = { "gcc", "clang", "cl" }
      end
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "c",
        "cpp",
        "java",
        "c_sharp",
        "python",
        "rust",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "json",
        "lua",
      })
    end,
  },

  -- 5. Mason auto-install LSP & Formatters (PC Windows only; Termux uses pkg install)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local is_termux = vim.fn.isdirectory("/data/data/com.termux") == 1 or vim.env.TERMUX_VERSION ~= nil
      if is_termux then
        opts.ensure_installed = {}
        return
      end
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "clangd",
        "pyright",
        "jdtls",
        "vtsls",
        "omnisharp",
        "lua-language-server",
        "stylua",
        "prettier",
      })
    end,
  },
}
