@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo.
echo   局域网点开这个 App（不需要 GitHub、不需要外网）:
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do (
  for /f "tokens=* delims= " %%b in ("%%a") do echo        http://%%b:8080
)
echo.
echo   iPhone 用 Safari 打开上面任一地址即可试玩。
echo   注意：http 不是 https，iOS 不会给"添加到主屏幕"的完整体验，离线缓存也不启用。
echo   关掉这个黑窗口 = 停止服务。
echo.
python -m http.server 8080
pause
