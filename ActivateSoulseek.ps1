function Activate-SoulseekWindow {
    # Define P/Invoke functions for user32.dll
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    using System.Text;
    public class Win32 {
        public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

        [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

        [DllImport("user32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool IsWindowVisible(IntPtr hWnd);

        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

        [DllImport("user32.dll")]
        public static extern bool SetForegroundWindow(IntPtr hWnd);

        public const int SW_RESTORE = 9;
    }
"@

    $global:soulseekHWnd = [IntPtr]::Zero

    # Define the window title search criteria
    $searchTitle = "SoulSeekQt"

    # EnumWindows callback function
    $callback = [Win32+EnumWindowsProc]{
        param([IntPtr]$hWnd, [IntPtr]$lParam)

        $sb = New-Object Text.StringBuilder 256
        [Win32]::GetWindowText($hWnd, $sb, $sb.Capacity) | Out-Null
        $windowTitle = $sb.ToString()

        Write-Host "Window Handle: $hWnd"
        Write-Host "Window Title: $windowTitle"

        if ($windowTitle -like "*$searchTitle*") {
            Write-Host "Match found: $windowTitle"
            $global:soulseekHWnd = $hWnd
            return $false  # Stop enumeration
        }

        Write-Host "No match found."
        return $true  # Continue enumeration
    }

    # Enumerate all windows and find the target window
    [Win32]::EnumWindows($callback, [IntPtr]::Zero)

    if ($global:soulseekHWnd -ne [IntPtr]::Zero) {
        Write-Host "Activating Soulseek window..."
        # Restore the window if minimized
        [Win32]::ShowWindow($global:soulseekHWnd, [Win32]::SW_RESTORE)
        # Bring the window to the foreground
        [Win32]::SetForegroundWindow($global:soulseekHWnd)
    } else {
        Write-Host "Soulseek window not found."
    }
}

Activate-SoulseekWindow
