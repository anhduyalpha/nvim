# ⚡ Neovim Cross-Platform IDE (VS Code Edition)

Bộ cấu hình **Neovim** chuẩn IDE đa nền tảng tối ưu hoá cho **Windows PC** và **Máy tính bảng Android (Xiaomi Tablet qua Termux)**.

Giao diện **Obsidian Dark**, tích hợp đầy đủ Auto-completion (LSP), Treesitter, phím tắt quen thuộc của VS Code và **Smart Multi-File OOP Runner** (tự gom và biên dịch tất cả class `.cpp`, `.java`, `.csproj`, `Cargo.toml` chỉ với **1 phím `F5`**).

---

## 🌟 Điểm Nổi Bật

- 🖥️ **Đa nền tảng thông minh**: Tự nhận diện hệ điều hành. Trên PC kích hoạt toàn bộ công cụ Windows + PowerShell; trên Tablet Xiaomi tự chuyển sang Native ARM64 Linux, tối ưu RAM, pin và thanh phím ảo cảm ứng.
- 🎨 **Giao diện Obsidian Dark**: Màu nền đen sâu (`#0a0c10`), làm nổi bật cấu trúc Hướng đối tượng (Class, Interface, Constructor, Method, Member Properties).
- ⚡ **Smart Multi-File OOP Runner (`F5`)**:
  - **C++**: Tự quét thư mục, gom tất cả file `.cpp` cài đặt Class liên kết với file chứa hàm `main()`, biên dịch chuẩn `-std=c++20`. Đứng ở file `.h` hay file class `Student.cpp` nhấn `F5` vẫn chạy đúng!
  - **Java**: Tự động `javac -encoding UTF-8 *.java`, tự nhận diện Class có `main()` để chạy `java MainClass`.
  - **C# / Rust / Python / JS / TS**: Tự nhận diện `.csproj` (`dotnet run`), `Cargo.toml` (`cargo run`), `main.py` hoặc chạy script trực tiếp.
  - Hỗ trợ nhập liệu bàn phím tương tác trực tiếp (`cin`, `Scanner`, `input()`).
- ⌨️ **Phím tắt lai VS Code**: `Ctrl+S` lưu file, `Ctrl+B` đóng mở cây thư mục, `Ctrl+P` tìm file siêu tốc, `Ctrl+/` comment, `Ctrl+\` mở Terminal, `Tab`/`Shift+Tab` chuyển tab.
- 📱 **Hỗ trợ cảm ứng toàn diện trên Tablet**: Chạm mở file trên Neo-tree, chạm đổi Tab, cuộn trang mượt mà, tích hợp thanh phím cứng cảm ứng (`F5`, `ESC`, `CTRL`, `ALT`, `TAB`) ngay mép trên bàn phím ảo.

---

## 🚀 Hướng Dẫn Cài Đặt

### 1. Trên Máy Tính Bảng Android (Xiaomi Tablet qua Termux)

> [!IMPORTANT]
> **Không tải Termux từ CH Play** (bản trên CH Play đã lỗi thời). Hãy tải bản mới nhất từ [F-Droid hoặc GitHub Releases](https://github.com/termux/termux-app/releases) (`termux-app_..._arm64-v8a.apk`).

Mở Termux trên máy tính bảng và dán **1 dòng lệnh duy nhất**:

```bash
pkg update -y && pkg install -y git curl && curl -fsSL https://raw.githubusercontent.com/anhduyalpha/nvim/main/setup-android.sh | bash
```

*(Hoặc cài đặt thủ công bằng 2 lệnh)*:
```bash
git clone https://github.com/anhduyalpha/nvim.git ~/.config/nvim
bash ~/.config/nvim/setup-android.sh
```

Script sẽ tự động:
1. Cài Neovim, clang (C++), Java 17, Python, Node.js native ARM64.
2. Tải font **JetBrainsMono Nerd Font** để hiển thị icon IDE sắc nét.
3. Thiết lập thanh phím ảo cảm ứng (`F5 Run`, `ESC`, `TAB`, `CTRL`...) trên màn hình.
4. Đồng bộ toàn bộ plugin.

---

### 2. Trên Windows PC

Mở **PowerShell** và chạy lệnh:

```powershell
git clone https://github.com/anhduyalpha/nvim.git $env:LOCALAPPDATA\nvim
nvim --headless "+Lazy! sync" +qa
```

*(Tùy chọn: Chạy file `setup-windows.ps1` để tự động cài đặt thêm các công cụ tìm kiếm siêu tốc `fd`, `ripgrep`, `lazygit` qua WinGet).*

---

## ⌨️ Bảng Phím Tắt Tiện Dụng

| Chức năng | Phím tắt | Thao tác trên Android Tablet |
| :--- | :--- | :--- |
| **Run Project Đa File OOP** | **`F5`** hoặc `<Space> r` | Chạm vào nút **`[F5]`** trên thanh phím cảm ứng |
| **Run Độc Lập 1 File** | **`F6`** hoặc `<Space> R` | Chạm vào nút **`[F6]`** trên thanh phím cảm ứng |
| **Lưu File** | **`Ctrl + S`** | Hoạt động cả ở chế độ gõ lẫn Normal |
| **Bật/Tắt Cây Thư Mục** | **`Ctrl + B`** hoặc `<Space> e` | Chạm ngón tay trực tiếp vào cây thư mục để mở file |
| **Tìm Nhanh File** | **`Ctrl + P`** hoặc `<Space> <Space>` | Giống hệt Quick Open của VS Code |
| **Tìm Chữ Trong Project** | **`<Space> s g>`** | Live Grep nội dung toàn bộ file code |
| **Bật/Tắt Comment** | **`Ctrl + /`** | Hỗ trợ 1 dòng hoặc khối code đang chọn |
| **Bật/Tắt Terminal** | **`Ctrl + \`** | Cửa sổ dòng lệnh bên dưới (nhấn `Esc Esc` để thoát) |
| **Chuyển Tab File** | **`Tab`** / **`Shift + Tab`** | Chạm ngón tay trực tiếp vào Tab phía trên |
| **Đóng Tab Hiện Tại** | **`Ctrl + W`** hoặc `<Space> b d` | Đóng buffer mà không mất layout cửa sổ |
| **Kéo Dòng Lên/Xuống** | **`Alt + Up`** / **`Alt + Down`** | Kéo dòng hoặc vùng bôi đen như VS Code |
| **Nhảy Tới Định Nghĩa** | **`g d`** | Go to Definition |
| **Xem Tài Liệu Hàm/Biến** | **`K`** (`Shift + k`) | Hiện popup thông tin kiểu dữ liệu và mô tả |
| **Sửa Lỗi Nhanh** | **`<Space> c a`** | Code Action (tương đương `Ctrl + .`) |
| **Đổi Tên Toàn Project** | **`<Space> c r`** | Rename Symbol (tương đương `F2`) |
| **Format Code** | **`<Space> c f`** | Tự căn chỉnh code theo chuẩn ngôn ngữ |

---

## 🛠️ Ngôn Ngữ Hỗ Trợ Sẵn

- **C / C++**: `clangd`, `g++ -std=c++20`, `gcc -std=c17`, `clang-format`.
- **Java**: `jdtls`, `openjdk-17`, tự động biên dịch và chạy class OOP có hàm `main()`.
- **Python**: `pyright`, chạy tương tác unbuffered UTF-8.
- **C# / .NET**: `omnisharp-extended-lsp`, `csharpier`, `netcoredbg`, `dotnet run`.
- **TypeScript / JavaScript**: `vtsls`, `prettier`, `node`, `tsx`.
- **Rust**: `rustaceanvim`, `cargo run`.
- **Lua**: `lua-language-server`, `stylua`.

---

## 📂 Cấu Trúc Thư Mục

```text
nvim/
├── init.lua                  # Điểm khởi động Neovim
├── lazyvim.json              # Danh sách các gói mở rộng ngôn ngữ
├── setup-android.sh          # Script cài đặt tự động 1-chạm cho Android Termux
├── setup-windows.ps1         # Script cài đặt tự động cho Windows PC
├── lua/
│   ├── config/
│   │   ├── options.lua       # Cấu hình hệ thống (nhận diện Windows vs Android)
│   │   ├── keymaps.lua       # Smart OOP Code Runner & Phím tắt VS Code
│   │   ├── lazy.lua          # Khởi tạo LazyVim package manager
│   │   └── autocmds.lua      # Tự động hóa sự kiện
│   └── plugins/
│       ├── colorscheme.lua   # Giao diện Obsidian Dark & OOP Highlight
│       └── vscode-ide.lua    # Cấu hình ToggleTerm, Neo-tree, Bufferline, Mason
```
