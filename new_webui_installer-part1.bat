@echo off
setlocal enabledelayedexpansion

:: Step 1: Install Python
:: Set common variables
set PYTHON_INSTALLER_URL=https://www.python.org/ftp/python/3.10.6/python-3.10.6-amd64.exe
set INSTALLER_FILENAME=%TEMP%\python-installer.exe

:: Step 1: Install Python 3.10.6 if not already installed
echo === Step 1: Checking and Installing Python ===
for /f "tokens=* delims=" %%i in ('python -V 2^>^&1') do set PYTHON_VERSION=%%i

if not "%PYTHON_VERSION%"=="Python 3.10.6" (
    echo Downloading Python Installer...
    powershell.exe -Command "(New-Object System.Net.WebClient).DownloadFile('%PYTHON_INSTALLER_URL%', '%INSTALLER_FILENAME%')"

    if not exist "%INSTALLER_FILENAME%" (
        echo Failed to download Python Installer. Exiting...
        exit /b
    )

    echo Installing Python 3.10.6...
    start /wait %INSTALLER_FILENAME% /unattend InstallAllUsers=1 PrependPath=1

    echo Verifying Python Installation...
    python -V 2>&1 | find "Python 3.10.6" >nul && (
        echo Python 3.10.6 installed successfully.
    ) || (
        echo Python 3.10.6 installation failed. Exiting...
        exit /b
    )
) else (
    echo Python 3.10.6 is already installed.
)

:: Step 2: Install pip packages
echo === Step 2: Installing pip packages ===
python -m pip install --upgrade pip
pip install xformers torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118 opencv-python

:: Step 3: Check and Install FFmpeg
echo === Step 4: Checking and Installing FFmpeg ===
where ffmpeg >nul 2>&1 || (
    echo FFmpeg not installed. Installing FFmpeg...
    winget install ffmpeg
    echo FFmpeg installation %errorlevel:~-2%.
)


echo All tasks completed

:: Execute the next part of the script if it exists
set fullpath=%userprofile%\BrookAI\new_webui_installer-part2.bat
if exist "%fullpath%" (
    C:\Windows\System32\cmd.exe /c "%fullpath%"
) else (
    echo Error: "%fullpath%" not found.
)

echo Press Enter to close...
set /p userInput=
exit
