#!/usr/bin/env bash
# ==============================================================================
#  Neovim IDE Automated Setup for Android (Termux / Xiaomi Tablet Edition)
#  Repository: https://github.com/anhduyalpha/nvim
# ==============================================================================

set -e

# Colors
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}================================================================${NC}"
echo -e "${CYAN}   🚀 NEOVIM IDE - SETUP TỰ ĐỘNG CHO ANDROID (TERMUX / TABLET)   ${NC}"
echo -e "${CYAN}================================================================${NC}"

# 1. Kiểm tra môi trường Termux
if [ ! -d "/data/data/com.termux" ]; then
    echo -e "${RED}[LỖI] Script này được thiết kế để chạy bên trong Termux trên Android!${NC}"
    exit 1
fi

echo -e "\n${YELLOW}[1/6] Đang cập nhật gói Termux và tải các công cụ biên dịch...${NC}"
pkg update -y || true

echo -e "\n${CYAN}>> Cài đặt các công cụ phát triển cốt lõi (Neovim, Git, Clang/C++, Python, Ripgrep, Fd)...${NC}"
pkg install -y \
    neovim \
    git \
    clang \
    python \
    ripgrep \
    fd \
    curl \
    termux-tools \
    xz-utils \
    unzip

echo -e "\n${CYAN}>> Cài đặt Node.js...${NC}"
pkg install -y nodejs-lts || pkg install -y nodejs || true

echo -e "\n${CYAN}>> Cài đặt Java OpenJDK (tự động thử openjdk-21 / openjdk-17 / openjdk-25)...${NC}"
if pkg install -y openjdk-21; then
    echo -e "${GREEN}✓ Đã cài đặt Java OpenJDK 21 thành công!${NC}"
elif pkg install -y openjdk-17; then
    echo -e "${GREEN}✓ Đã cài đặt Java OpenJDK 17 thành công!${NC}"
elif pkg install -y openjdk-25; then
    echo -e "${GREEN}✓ Đã cài đặt Java OpenJDK 25 thành công!${NC}"
else
    echo -e "${YELLOW}! Không tìm thấy gói OpenJDK trên mirror hiện tại. Bỏ qua Java.${NC}"
fi

echo -e "\n${CYAN}>> Cài đặt Termux API (tùy chọn)...${NC}"
pkg install -y termux-api || true

echo -e "\n${YELLOW}[2/6] Đang cài đặt Language Server (Python, TypeScript, Prettier)...${NC}"
npm install -g pyright typescript-language-server prettier || true

echo -e "\n${YELLOW}[3/6] Đang cấu hình phím cảm ứng chuyên dụng trên màn hình Tablet...${NC}"
mkdir -p ~/.termux
cat << 'EOF' > ~/.termux/termux.properties
back-key = escape
extra-keys = [ \
  ['ESC', 'CTRL', 'ALT', 'TAB', 'BACKSLASH', 'UP', 'DOWN'], \
  ['F5', 'F6', 'HOME', 'END', 'PGUP', 'PGDN', 'QUOTE'] \
]
EOF

echo -e "\n${YELLOW}[4/6] Đang tải JetBrainsMono Nerd Font (hiển thị icon IDE đẹp)...${NC}"
FONT_ARCHIVE_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
TMP_FONT_ARCHIVE="$HOME/.termux/JetBrainsMono.tar.xz"

if curl -fL -o "$TMP_FONT_ARCHIVE" "$FONT_ARCHIVE_URL"; then
    tar -xf "$TMP_FONT_ARCHIVE" -C ~/.termux/ JetBrainsMonoNerdFont-Regular.ttf
    mv ~/.termux/JetBrainsMonoNerdFont-Regular.ttf ~/.termux/font.ttf
    rm -f "$TMP_FONT_ARCHIVE"
    echo -e "${GREEN}✓ Đã cài đặt JetBrainsMono Nerd Font thành công!${NC}"
else
    echo -e "${YELLOW}! Không thể tải font qua mạng, Termux sẽ dùng font mặc định.${NC}"
fi

# Áp dụng giao diện phím và font cho Termux
termux-reload-settings || true

echo -e "\n${YELLOW}[5/6] Đang đồng bộ bộ cấu hình Neovim...${NC}"
mkdir -p ~/.config
REPO_DIR="$HOME/.config/nvim"

if [ -d "$REPO_DIR/.git" ]; then
    echo -e "${CYAN}Thư mục cấu hình đã tồn tại, đang kéo cập nhật mới nhất...${NC}"
    cd "$REPO_DIR" && git pull || true
else
    if [ -d "$REPO_DIR" ]; then
        echo -e "${YELLOW}Sao lưu cấu hình nvim cũ sang ~/.config/nvim.backup...${NC}"
        mv "$REPO_DIR" "$HOME/.config/nvim.backup.$(date +%s)"
    fi
    echo -e "${CYAN}Đang clone cấu hình từ GitHub...${NC}"
    git clone https://github.com/anhduyalpha/nvim.git "$REPO_DIR"
fi

echo -e "\n${YELLOW}[6/6] Đang nạp và đồng bộ plugin Neovim (Headless Sync)...${NC}"
# Xóa thư mục Mason cũ nếu có để tránh xung đột binary glibc trên Termux
rm -rf ~/.local/share/nvim/mason ~/.local/share/nvim/mason-lspconfig || true
nvim --headless "+Lazy! sync" +qa || true

echo -e "\n${GREEN}================================================================${NC}"
echo -e "${GREEN}   🎉 CÀI ĐẶT HOÀN TẤT! NEOVIM ĐÃ SẴN SÀNG TRÊN TABLET CỦA BẠN  ${NC}"
echo -e "${GREEN}================================================================${NC}"
echo -e "👉 Gõ lệnh: ${CYAN}nvim${NC} để mở IDE."
echo -e "👉 Chạm cảm ứng vào các tab trên cùng hoặc cây thư mục Neo-tree bên trái để duyệt file."
echo -e "👉 Bấm phím cảm ứng ${CYAN}[F5]${NC} trên màn hình để biên dịch và chạy code OOP đa file C++/Java/Python!"
echo -e "👉 Bấm ${CYAN}[CTRL]+[B]${NC} để ẩn/hiện cây thư mục."
echo -e "👉 Bấm ${CYAN}[CTRL]+[S]${NC} để lưu file.\n"
