-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Detect environment
local is_termux = vim.fn.isdirectory("/data/data/com.termux") == 1 or vim.env.TERMUX_VERSION ~= nil
_G.IS_TERMUX = is_termux

-- Ensure MSYS2 UCRT64 (gcc, g++, gdb) and WinGet links (fd, rg, lazygit) are always in PATH on Windows
if not is_termux and vim.fn.has("win32") == 1 then
  local extra_paths = {
    "C:\\msys64\\ucrt64\\bin",
    vim.fn.expand("$LOCALAPPDATA\\Microsoft\\WinGet\\Links"),
    vim.fn.expand("$USERPROFILE\\.cargo\\bin"),
  }
  for _, p in ipairs(extra_paths) do
    if vim.fn.isdirectory(p) == 1 and not string.find(vim.env.PATH or "", p, 1, true) then
      vim.env.PATH = p .. ";" .. (vim.env.PATH or "")
    end
  end
end

local opt = vim.opt

-- Sync with system clipboard (Windows unnamedplus, Android termux-clipboard-set/get)
opt.clipboard = "unnamedplus"
if is_termux and vim.fn.executable("termux-clipboard-set") == 1 then
  vim.g.clipboard = {
    name = "termux-clipboard",
    copy = {
      ["+"] = "termux-clipboard-set",
      ["*"] = "termux-clipboard-set",
    },
    paste = {
      ["+"] = "termux-clipboard-get",
      ["*"] = "termux-clipboard-get",
    },
    cache_enabled = 0,
  }
end

-- Encoding & UI
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false

-- Indentation defaults (4 spaces for OOP languages like C++, Java, C#, Python)
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- Fast update & no swapfile lag
opt.updatetime = 200
opt.timeoutlen = 300
opt.swapfile = false
opt.undofile = true

-- Use PowerShell as integrated terminal shell on Windows
if vim.fn.has("win32") == 1 then
  LazyVim.terminal.setup("pwsh")
  if vim.fn.executable("pwsh") == 0 then
    LazyVim.terminal.setup("powershell")
  end
end
