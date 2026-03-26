@echo off
setlocal
pushd "%~dp0"

echo ==========================================
echo  Mustang AutoExec Navigator Launcher
echo ==========================================
echo  1. “ú–{Œê”Å (Japanese)
echo  2. English Edition
echo ==========================================
set /p lang="Choose Language (1 or 2): "

if "%lang%"=="2" (
    echo [System] Launching English Edition...
    powershell -NoProfile -ExecutionPolicy RemoteSigned -File "%~dp0StartAppNavigator_EN.ps1"
) else (
    echo [System] “ú–{Œê”Å‚ð‹N“®‚µ‚Ä‚¢‚Ü‚·...
    powershell -NoProfile -ExecutionPolicy RemoteSigned -File "%~dp0StartAppNavigator_JP.ps1"
)

echo [System] Process Finished.
popd
pause