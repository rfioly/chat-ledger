@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo.
echo   只做「推送已有提交」。前提：GitHub 网页上已建好 chat-ledger 仓库（Public）。
echo   网页打不开？先双击 proxy-on.cmd，或在 Clash 里开全局。
echo.
set /p TOKEN=粘贴 GitHub Personal Access Token: 
if "%TOKEN%"=="" goto :eof
git -c http.proxy=http://127.0.0.1:7890 push "https://rfioly:%TOKEN%@github.com/rfioly/chat-ledger.git" main:main
if errorlevel 1 (
  echo.
  echo   推送失败。检查：仓库建了没 / token 有没有 repo 权限 / 代理开没开。
) else (
  echo.
  echo   推送成功。去仓库 Settings -^> Pages -^> Source 选 GitHub Actions。
  echo   等 1-2 分钟：https://rfioly.github.io/chat-ledger/
)
set TOKEN=
pause
