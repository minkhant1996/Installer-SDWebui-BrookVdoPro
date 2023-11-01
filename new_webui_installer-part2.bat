@echo off
setlocal enabledelayedexpansion

echo step 1
:: 1. Navigate to user's home folder and clone the repository
cd %userprofile%\BrookAI
if not exist "sd-web" (
    echo "sd-web does not exist. Git Clonning."
    git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git sd-web
    git config --global --add safe.directory %userprofile%/BrookAI/sd-web
) else (
    echo "sd-web exists. Doing nothing."
)

echo step 2
:: 2. Modify the file "webui-user.bat" in sd-web
set FILE_PATH=%userprofile%\BrookAI\sd-web\webui-user.bat

:: Check if the string exists in the file
powershell -Command "if (-not (Select-String -Path '%FILE_PATH%' -Pattern 'COMMANDLINE_ARGS=--xformers --medvram' -Quiet)) { (Get-Content '%FILE_PATH%') -replace 'set COMMANDLINE_ARGS=', 'set COMMANDLINE_ARGS=--xformers --medvram' | Set-Content '%FILE_PATH%'; Write-Output 'Modified the file'; } else { Write-Output 'No modifications made.'; }"


echo step 3
cd %userprofile%\BrookAI
:: 3. Download python script if doesn't exists
if not exist "BrookVdoPro" (
    git clone https://github.com/minkhant1996/BrookAI_ImageProcessor.git BrookVdoPro
    git config --global --add safe.directory %userprofile%/BrookAI/BrookVdoPro
    echo Python file downloaded at: BrookVdoPro
    cd %userprofile%\BrookAI\BrookVdoPro
    pip install -r requirements.txt
    pyinstaller --windowed --onefile .\extract_combine_frame_UI.py --name BrookVdoPro --icon brookerPCL-logo.ico
)


if exist "%userprofile%\BrookAI\BrookVdoPro\dist\BrookVdoPro.exe" (
   echo The file "%userprofile%\BrookAI\BrookVdoPro\dist\BrookVdoPro.exe" exists.
) else (
   echo The file "%userprofile%\BrookAI\BrookVdoPro\dist\BrookVdoPro.exe" does not exist.
)

if exist "%userprofile%\BrookAI\BrookVdoPro\brookerPCL-logo.ico" (
   echo The file "%userprofile%\BrookAI\BrookVdoPro\brookerPCL-logo.ico" exists.
) else (
   echo The file "%userprofile%\BrookAI\BrookVdoPro\brookerPCL-logo.ico" does not exist.
)


echo step 4
:: 4. Create shortcut
echo Creating shortcut on desktop...

if exist "C:\Users\Public\Desktop\BrookVdoPro.lnk" (
   echo The file "C:\Users\Public\Desktop\BrookVdoPro.lnk" exists. 
   echo Python App shortcut already exists.
) else (
   echo The file "C:\Users\Public\Desktop\BrookVdoPro.lnk" does not exist.
   echo Python App shortcut is creating ...
   powershell -ExecutionPolicy Bypass -File %userprofile%\BrookAI\vdo_py_shortcut.ps1
   echo Python App Shortcut created on desktop.
)


if exist "C:\Users\Public\Desktop\SD_WebUI.lnk" (
   echo The file "C:\Users\Public\Desktop\SD_WebUI.lnk" exists. 
   echo WebUi shortcut already exists.
) else (
   echo The file "C:\Users\Public\Desktop\SD_WebUI.lnk" does not exist.
   echo WebUi shortcut is creating ...
   powershell -ExecutionPolicy Bypass -File %userprofile%\BrookAI\webui_shortcut.ps1
   echo WebUi Shortcut created on desktop.
)



echo step 5
cd %userprofile%\BrookAI\sd-web
:: 5. check sd-ui installation
if not exist "venv" (
    echo "venv does not exist. Creating venv .."
    python -m venv  %userprofile%\BrookAI\sd-web\venv --without-pip
    %userprofile%\BrookAI\sd-web\venv\Scripts\activate
    python -m pip --version >nul 2>&1
    if %errorlevel% neq 0 (
       echo pip not found. Installing pip...
       curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
       python get-pip.py
       if %errorlevel% neq 0 (
          echo Failed to install pip.
          exit /b 1
       ) else (
          echo pip installed successfully.
       )
    ) else (
       echo pip is already installed.
    )
) else (
    echo "venv exists. Doing nothing."
)

echo All tasks completed!



endlocal

echo.
echo Press Enter to close...
set /p userInput=
exit
