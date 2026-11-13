@echo off
chcp 936 >nul
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0push.ps1"
pause
