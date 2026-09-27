@echo off
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0edge-cdp-remote-debugging-setup-zh-CN.ps1"
pause
