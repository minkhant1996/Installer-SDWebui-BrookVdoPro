@echo off
setlocal enabledelayedexpansion

:: Execute the next part of the script if it exists
cd %userprofile%\BrookAI\sd-web
set fullpath=webui-user.bat
echo Attempting to run: "%fullpath%"
if exist "%fullpath%" (
    "./%fullpath%"
) else (
    echo Error: "%fullpath%" not found.
)

pause
