-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- ============================================================================
-- 1. SMART MULTI-FILE OOP & PROJECT CODE RUNNER (F5 / <Space>r)
-- ============================================================================
local function has_main_function(filepath, lang)
  local f = io.open(filepath, "r")
  if not f then
    return false
  end
  local content = f:read("*a")
  f:close()
  if lang == "cpp" or lang == "c" then
    return content:match("%f[%w_]main%s*%(") ~= nil
  elseif lang == "java" then
    return content:match("public%s+static%s+void%s+main%s*%(") ~= nil
  end
  return false
end

local function run_in_terminal(cmd, dir)
  local is_termux = vim.fn.isdirectory("/data/data/com.termux") == 1 or vim.env.TERMUX_VERSION ~= nil
  local term_height = is_termux and 10 or 15
  local ok, toggleterm = pcall(require, "toggleterm")
  if ok then
    toggleterm.exec(cmd, 1, term_height, dir, "horizontal", "CodeRunner", true, true)
  else
    vim.cmd("botright " .. term_height .. "split | lcd " .. vim.fn.fnameescape(dir) .. " | terminal " .. cmd)
    vim.cmd("startinsert")
  end
end

local function smart_run_code(force_single)
  vim.cmd("silent! wall") -- Auto-save all files before running

  local file = vim.fn.expand("%:p")
  local dir = vim.fn.expand("%:p:h")
  local filename = vim.fn.expand("%:t")
  local filestem = vim.fn.expand("%:t:r")
  local ext = vim.fn.expand("%:e"):lower()
  local ft = vim.bo.filetype
  local is_win = vim.fn.has("win32") == 1

  if file == "" then
    vim.notify("No file to run!", vim.log.levels.WARN)
    return
  end

  local cmd = ""

  -- C++ (Supports both single file and multi-file OOP .cpp + .h)
  if ft == "cpp" or ft == "c" or ext == "h" or ext == "hpp" then
    local is_c = (ft == "c" and ext == "c")
    local compiler
    if is_c then
      compiler = (vim.fn.executable("gcc") == 1) and "gcc -std=c17" or "clang -std=c17"
    else
      compiler = (vim.fn.executable("g++") == 1) and "g++ -std=c++20" or "clang++ -std=c++20"
    end
    local pattern = is_c and "*.c" or "*.cpp"

    if force_single and (ext == "cpp" or ext == "c") then
      if is_win then
        cmd = string.format('%s "%s" -o "%s.exe" ; if ($?) { .\\%s.exe }', compiler, filename, filestem, filestem)
      else
        cmd = string.format('%s "%s" -o "./%s" && "./%s"', compiler, filename, filestem, filestem)
      end
    else
      local all_files = vim.fn.globpath(dir, pattern, false, true)
      local class_files = {}
      local entry_files = {}

      for _, p in ipairs(all_files) do
        local name = vim.fn.fnamemodify(p, ":t")
        if has_main_function(p, is_c and "c" or "cpp") then
          table.insert(entry_files, name)
        else
          table.insert(class_files, name)
        end
      end

      local target_entry = filename
      if not has_main_function(file, is_c and "c" or "cpp") then
        target_entry = nil
        for _, e in ipairs(entry_files) do
          if e:lower() == "main.cpp" or e:lower() == "main.c" then
            target_entry = e
            break
          end
        end
        target_entry = target_entry or entry_files[1]
      end

      if not target_entry then
        vim.notify("Không tìm thấy hàm main() trong thư mục!", vim.log.levels.ERROR)
        return
      end

      local compile_list = { string.format('"%s"', target_entry) }
      for _, cf in ipairs(class_files) do
        if cf ~= target_entry then
          table.insert(compile_list, string.format('"%s"', cf))
        end
      end

      local out_name = vim.fn.fnamemodify(target_entry, ":r")
      local files_str = table.concat(compile_list, " ")

      if is_win then
        cmd = string.format(
          'Write-Host ">> Compiling OOP (%s)..." -ForegroundColor Cyan; %s %s -o "%s.exe" ; if ($?) { Write-Host ">> Running %s.exe`n" -ForegroundColor Green; .\\%s.exe }',
          files_str,
          compiler,
          files_str,
          out_name,
          out_name,
          out_name
        )
      else
        cmd = string.format(
          'echo -e "\\033[1;36m>> Compiling OOP (%s)...\\033[0m" && %s %s -o "./%s" && echo -e "\\033[1;32m>> Running ./%s\\n\\033[0m" && "./%s"',
          files_str,
          compiler,
          files_str,
          out_name,
          out_name,
          out_name
        )
      end
    end

  -- JAVA (Supports multi-class OOP in folder)
  elseif ft == "java" then
    local target_class = filestem
    if not has_main_function(file, "java") then
      local java_files = vim.fn.globpath(dir, "*.java", false, true)
      for _, jf in ipairs(java_files) do
        if has_main_function(jf, "java") then
          target_class = vim.fn.fnamemodify(jf, ":t:r")
          break
        end
      end
    end

    if is_win then
      cmd = string.format(
        'Write-Host ">> Compiling Java OOP (*.java)..." -ForegroundColor Cyan; javac -encoding UTF-8 *.java ; if ($?) { Write-Host ">> Running %s`n" -ForegroundColor Green; java -Dfile.encoding=UTF-8 %s }',
        target_class,
        target_class
      )
    else
      cmd = string.format(
        'echo -e "\\033[1;36m>> Compiling Java OOP (*.java)...\\033[0m" && javac -encoding UTF-8 *.java && echo -e "\\033[1;32m>> Running %s\\n\\033[0m" && java %s',
        target_class,
        target_class
      )
    end

  -- PYTHON (UTF-8 unbuffered)
  elseif ft == "python" then
    if is_win then
      cmd = string.format(
        '$env:PYTHONIOENCODING="utf-8"; Write-Host ">> Running %s`n" -ForegroundColor Green; python -u "%s"',
        filename,
        filename
      )
    else
      local py_cmd = (vim.fn.executable("python3") == 1) and "python3" or "python"
      cmd = string.format(
        'echo -e "\\033[1;32m>> Running %s\\n\\033[0m" && %s -u "%s"',
        filename,
        py_cmd,
        filename
      )
    end

  -- C# / .NET
  elseif ft == "cs" then
    local csproj = vim.fs.find(function(name)
      return name:match("%.csproj$") ~= nil
    end, { upward = true, path = dir })[1]
    if csproj then
      dir = vim.fn.fnamemodify(csproj, ":h")
      cmd = is_win and 'Write-Host ">> Running .NET Project..." -ForegroundColor Cyan; dotnet run'
        or 'echo ">> Running .NET Project..." && dotnet run'
    else
      cmd = is_win and 'Write-Host ">> Running dotnet..." -ForegroundColor Cyan; dotnet run'
        or 'dotnet run'
    end

  -- RUST (Cargo or single rustc)
  elseif ft == "rust" then
    local cargo = vim.fs.find("Cargo.toml", { upward = true, path = dir })[1]
    if cargo then
      dir = vim.fn.fnamemodify(cargo, ":h")
      cmd = is_win and 'Write-Host ">> Running Cargo Project..." -ForegroundColor Cyan; cargo run'
        or 'cargo run'
    else
      if is_win then
        cmd = string.format('rustc "%s" -o "%s.exe" ; if ($?) { .\\%s.exe }', filename, filestem, filestem)
      else
        cmd = string.format('rustc "%s" -o "./%s" && "./%s"', filename, filestem, filestem)
      end
    end

  -- JAVASCRIPT / TYPESCRIPT
  elseif ft == "javascript" then
    if is_win then
      cmd = string.format('Write-Host ">> Running Node.js (%s)`n" -ForegroundColor Green; node "%s"', filename, filename)
    else
      cmd = string.format('echo -e "\\033[1;32m>> Running Node.js (%s)\\n\\033[0m" && node "%s"', filename, filename)
    end
  elseif ft == "typescript" then
    if is_win then
      cmd = string.format('Write-Host ">> Running TypeScript (%s)`n" -ForegroundColor Green; npx --yes tsx "%s"', filename, filename)
    else
      cmd = string.format('echo -e "\\033[1;32m>> Running TypeScript (%s)\\n\\033[0m" && npx --yes tsx "%s"', filename, filename)
    end
  else
    vim.notify("Chưa hỗ trợ chạy trực tiếp filetype: " .. ft, vim.log.levels.WARN)
    return
  end

  run_in_terminal(cmd, dir)
end

-- Run Keybindings (F5, F6, <Space>r)
map({ "n", "i", "v" }, "<F5>", function()
  smart_run_code(false)
end, { desc = "Run Code (Smart Multi-file OOP)" })

map("n", "<leader>r", function()
  smart_run_code(false)
end, { desc = "Run Code (Smart Multi-file OOP)" })

map({ "n", "i", "v" }, "<F6>", function()
  smart_run_code(true)
end, { desc = "Run Current Single File Only" })

map("n", "<leader>R", function()
  smart_run_code(true)
end, { desc = "Run Current Single File Only" })

-- ============================================================================
-- 2. HYBRID VS CODE SHORTCUTS
-- ============================================================================

-- Ctrl+S: Save file
map({ "n", "i", "v", "x" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File (VS Code style)" })

-- Ctrl+B: Toggle File Explorer Sidebar (Neo-tree) like VS Code
map({ "n", "i", "v" }, "<C-b>", "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer Sidebar (Ctrl+B)" })

-- Ctrl+P: Quick Open Files like VS Code
map("n", "<C-p>", function()
  LazyVim.pick("files")()
end, { desc = "Quick Open File (Ctrl+P)" })

-- Ctrl+/ (and Ctrl+_ sent by Windows terminals): Toggle Comment
map("n", "<C-/>", "gcc", { remap = true, desc = "Toggle Comment Line" })
map("n", "<C-_>", "gcc", { remap = true, desc = "Toggle Comment Line" })
map("v", "<C-/>", "gc", { remap = true, desc = "Toggle Comment Block" })
map("v", "<C-_>", "gc", { remap = true, desc = "Toggle Comment Block" })

-- Alt+Up / Alt+Down: Move line/selection up and down like VS Code
map("n", "<A-Down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-Up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-Down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-Up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Tab / Shift+Tab in Normal mode to switch open file tabs quickly
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer Tab" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous Buffer Tab" })

-- Escape in Terminal mode exits terminal insert mode to allow scrolling/navigation
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit Terminal Mode" })
