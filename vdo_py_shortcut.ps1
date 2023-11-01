$Shell = New-Object -ComObject WScript.Shell
$Shortcut = $Shell.CreateShortcut("$env:C:\Users\Public\Desktop\BrookVdoPro.lnk")
$Shortcut.TargetPath = "$env:USERPROFILE\BrookAI\BrookVdoPro\dist\BrookVdoPro.exe"
$Shortcut.IconLocation = "$env:USERPROFILE\BrookAI\BrookVdoPro\brookerPCL-logo.ico, 0"
$Shortcut.Save()