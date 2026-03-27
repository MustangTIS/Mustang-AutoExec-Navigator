@echo off
setlocal
pushd "%~dp0"

echo ==========================================
echo  Mustang AutoExec Navigator Launcher
echo ==========================================

:: 管理者権限チェック (Admin Check)
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo [ERROR] This tool REQUIRES Administrator privileges.
    echo [ERROR] Please right-click "AutoRun.bat" and select "Run as Administrator".
    echo.
    echo [エラー] このツールの実行には管理者権限が必要です。
    echo [エラー] "AutoRun.bat" を右クリックして「管理者として実行」してください。
    echo.
    pause
    exit /b
)

echo  1. 日本語版 (Japanese)
echo  2. English Edition
echo ==========================================
set /p lang="Choose Language (1 or 2): "

if "%lang%"=="2" (
    echo [System] Launching English Edition...
    powershell -NoProfile -ExecutionPolicy RemoteSigned -File "%~dp0StartAppNavigator_EN.ps1"
) else (
    echo [System] 日本語版を起動しています...
    powershell -NoProfile -ExecutionPolicy RemoteSigned -File "%~dp0StartAppNavigator_JP.ps1"
)

echo [System] Process Finished.
popd
pause