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
pkg update -y
pkg install -y \
    neovim \
    git \
    clang \
    openjdk-17 \
    python \
    nodejs-lts \
    ripgrep \
    fd \
    curl \
    termux-api \
    termux-tools

echo -e "\n${YELLOW}[2/6] Đang cài đặt Language Server (Python, TypeScript, Prettier)...${NC}"
npm install -g pyright typescript-language-server prettier || true

echo -e "\n${YELLOW}[3/6] Đang cấu hình phím cảm ứng chuyên dụng trên màn hình Tablet...${NC}"
mkdir -p ~/.termux
cat << 'EOF' > ~/.termux/termux.properties
extra-keys = [ \
  ['ESC', 'CTRL', 'ALT', 'TAB', 'BACKSLASH', 'UP', 'DOWN'], \
  ['F5', 'F6', 'HOME', 'END', 'PGUP', 'PGDN', 'QUOTE'] \
]
EOF

echo -e "\n${YELLOW}[4/6] Đang tải JetBrainsMono Nerd Font (hiển thị icon IDE đẹp)...${NC}"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"
if curl -fsSL -o ~/.termux/font.ttf "$FONT_URL"; then
    echo -e "${GREEN}✓ Đã tải font JetBrainsMono Nerd Font thành công!${NC}"
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
nvim --headless "+Lazy! sync" +qa || true

echo -e "\n${GREEN}================================================================${NC}"
echo -e "${GREEN}   🎉 CÀI ĐẶT HOÀN TẤT! NEOVIM ĐÃ SẴN SÀNG TRÊN TABLET CỦA BẠN  ${NC}"
echo -e "${GREEN}================================================================${NC}"
echo -e "👉 Gõ lệnh: ${CYAN}nvim${NC} để mở IDE."
echo -e "👉 Chạm cảm ứng vào các tab trên cùng hoặc cây thư mục Neo-tree bên trái để duyệt file."
echo -e "👉 Bấm phím cảm ứng ${CYAN}[F5]${NC} trên màn hình để biên dịch và chạy code OOP đa file C++/Java/Python!"
echo -e "👉 Bấm ${CYAN}[CTRL]+[B]${NC} để ẩn/hiện cây thư mục."
echo -e "👉 Bấm ${CYAN}[CTRL]+[S]${NC} để lưu file.\n"
