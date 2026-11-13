@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo   给「本仓库」挂代理（Clash 默认 127.0.0.1:7890）。只改这个仓库，不动全局。
git config http.proxy http://127.0.0.1:7890
echo.
echo   当前值：
git config --get http.proxy
echo.
echo   撤销： git config --unset http.proxy
pause
