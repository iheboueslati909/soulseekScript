@if (@CodeSection == @Batch) @then
@echo off
:: Call the PowerShell script to activate the Soulseek window
powershell -Command "& { . '%~dp0\ActivateSoulseek.ps1'; Activate-SoulseekWindow }"

:: Wait briefly to ensure the window is active
timeout /t 1
pause
:: Send Ctrl+V keystroke using JScript
CScript //nologo //E:JScript "%~f0" "^v"
Goto:eof
@end
 