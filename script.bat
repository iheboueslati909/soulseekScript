@if (@CodeSection == @Batch) @then
@echo off
:: PowerShell script to focus the Soulseek window by process name
powershell -Command "Add-Type -AssemblyName PresentationFramework; $soulseek = Get-Process -Name 'SoulseekQt'; if ($soulseek) { (New-Object -ComObject WScript.Shell).AppActivate($soulseek.Id) }"
:: Wait briefly to ensure the window is active
timeout /t 1
:: Send Tab key 9 times, Ctrl+V, and Enter keystrokes using JScript
CScript //nologo //E:JScript "%~f0" "{TAB 9}^v{ENTER}"
Goto:eof

@end
// JScript section
var WshShell = WScript.CreateObject("WScript.Shell");
WshShell.SendKeys(WScript.Arguments(0));
