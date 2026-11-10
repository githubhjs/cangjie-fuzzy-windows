@echo off
rem Runs install.ps1 with the execution policy bypassed for this one run. Options pass through, e.g. install.bat -Cangjie5 -FuzzyRange wide
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
pause
