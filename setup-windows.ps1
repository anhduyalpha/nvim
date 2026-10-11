# ==============================================================================
#  Neovim IDE Automated Setup for Windows (PC Edition)
#  Repository: https://github.com/anhduyalpha/nvim
# ==============================================================================

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "   🚀 NEOVIM IDE - SETUP TỰ ĐỘNG CHO WINDOWS (PC EDITION)        " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# 1. Cài đặt các công cụ CLI cần thiết nếu chưa có
Write-Host "`n[1/4] Kiểm tra các công cụ CLI bổ trợ (fd, ripgrep, lazygit)..." -ForegroundColor Yellow
$packages = @("sharkdp.fd", "BurntSushi.ripgrep.MSVC", "JesseDuffield.lazygit")
foreach ($pkg in $packages) {
    winget install --id $pkg -e --accept-package-agreements --accept-source-agreements --silent 2>$null
}

# 2. Đảm bảo thư mục nvim
$nvimDir = "$env:LOCALAPPDATA\nvim"
Write-Host "`n[2/4] Kiểm tra thư mục cấu hình: $nvimDir..." -ForegroundColor Yellow
if (-not (Test-Path "$nvimDir\.git")) {
    if (Test-Path $nvimDir) {
        $backupDir = "$nvimDir.backup." + (Get-Date -Format "yyyyMMddHHmmss")
        Write-Host "Sao lưu cấu hình cũ sang $backupDir..." -ForegroundColor Cyan
        Move-Item -Path $nvimDir -Destination $backupDir -Force
    }
    Write-Host "Đang clone cấu hình từ GitHub..." -ForegroundColor Cyan
    git clone https://github.com/anhduyalpha/nvim.git $nvimDir
} else {
    Write-Host "Đang kéo bản cập nhật mới nhất từ GitHub..." -ForegroundColor Cyan
    git -C $nvimDir pull
}

# 3. Đồng bộ plugin qua Neovim Headless
Write-Host "`n[3/4] Đang đồng bộ plugin Neovim..." -ForegroundColor Yellow
& "nvim" --headless "+Lazy! sync" +qa

Write-Host "`n================================================================" -ForegroundColor Green
Write-Host "   🎉 CÀI ĐẶT HOÀN TẤT TRÊN WINDOWS!                           " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
Write-Host "👉 Mở Windows Terminal và gõ: nvim ." -ForegroundColor Cyan
Write-Host "👉 Nhấn F5 để chạy code OOP đa file (C++, Java, C#, Python, Rust)!" -ForegroundColor Cyan
Write-Host "👉 Nhấn Ctrl+B để ẩn/hiện cây thư mục Neo-tree, Ctrl+P tìm file, Ctrl+S lưu file.`n" -ForegroundColor Cyan
