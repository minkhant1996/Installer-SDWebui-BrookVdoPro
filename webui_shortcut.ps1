$Shell = New-Object -ComObject WScript.Shell
$Shortcut = $Shell.CreateShortcut("$env:C:\Users\Public\Desktop\SD_WebUI.lnk")
$Shortcut.TargetPath = "$env:USERPROFILE\BrookAI\run_webui.bat"
$Shortcut.Save()