@echo off
setlocal enabledelayedexpansion

set "RELEASE_DIR=.\release"

cls
echo Flutter Multi-Platform Build Script
echo.

where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo Flutter SDK not found in your PATH.
    echo Please install Flutter and add it to your system's environment variables.
    pause
    goto :eof
)

if not exist "%RELEASE_DIR%" (
    mkdir "%RELEASE_DIR%"
)

set "build_android="
set "build_ios="
set "build_windows="
set "build_linux="
set "build_macos="
set "build_web="

:menu
cls
echo Target Platforms:
echo.
echo   1) All Supported Platforms
echo   2) Android (APK per ABI + AppBundle)
echo   3) Windows (x64)
echo   4) Web
echo   5) Linux (x64) - Requires Linux Host
echo   6) macOS (x64 & arm64) - Requires macOS Host
echo   7) iOS - Requires macOS Host
echo.
set /p "choices=Enter numbers to build, separated by spaces (e.g., 2 3 4): "

if "%choices%"=="" goto menu

for %%c in (%choices%) do (
    if "%%c"=="1" (
        set build_android=1
        set build_windows=1
        set build_web=1
        set build_linux=1
        set build_macos=1
        set build_ios=1
    )
    if "%%c"=="2" set build_android=1
    if "%%c"=="3" set build_windows=1
    if "%%c"=="4" set build_web=1
    if "%%c"=="5" set build_linux=1
    if "%%c"=="6" set build_macos=1
    if "%%c"=="7" set build_ios=1
)

echo.
echo Starting build process...
call flutter clean
call flutter pub get

if defined build_android (
    echo.
    echo ========================================
    echo Building Android
    echo ========================================
    call flutter build apk --split-per-abi
    if !errorlevel! neq 0 (
        echo Android APK build failed.
        pause
        goto :eof
    )
    call flutter build appbundle
    if !errorlevel! neq 0 (
        echo Android AppBundle build failed.
        pause
        goto :eof
    )
    xcopy ".\build\app\outputs\flutter-apk" "%RELEASE_DIR%\android\apk\" /E /I /Y /Q
    xcopy ".\build\app\outputs\bundle\release" "%RELEASE_DIR%\android\appbundle\" /E /I /Y /Q
)

if defined build_windows (
    echo.
    echo ========================================
    echo Building Windows
    echo ========================================
    if "%OS%"=="Windows_NT" (
        call flutter build windows
        if !errorlevel! neq 0 (
            echo Windows build failed.
            pause
            goto :eof
        )
        if exist "%RELEASE_DIR%\windows_x64.zip" del "%RELEASE_DIR%\windows_x64.zip"
        tar -a -c -f "%RELEASE_DIR%\windows_x64.zip" -C ".\build\windows\runner\Release" .
    ) else (
        echo Windows build can only be performed on a Windows host. Skipping.
    )
)

if defined build_web (
    echo.
    echo ========================================
    echo Building Web
    echo ========================================
    call flutter build web
    if !errorlevel! neq 0 (
        echo Web build failed.
        pause
        goto :eof
    )
    if exist "%RELEASE_DIR%\web.zip" del "%RELEASE_DIR%\web.zip"
    tar -a -c -f "%RELEASE_DIR%\web.zip" -C ".\build\web" .
)

if defined build_linux (
    echo.
    echo ========================================
    echo Building Linux
    echo ========================================
    if not "%OS%"=="Windows_NT" (
        call flutter build linux
        if !errorlevel! neq 0 (
            echo Linux build failed.
            pause
            goto :eof
        )
        if exist "%RELEASE_DIR%\linux_x64.zip" del "%RELEASE_DIR%\linux_x64.zip"
        tar -a -c -f "%RELEASE_DIR%\linux_x64.zip" -C ".\build\linux\x64\release\bundle" .
    ) else (
        echo Linux build can only be performed on a Linux host. Skipping.
    )
)

if defined build_macos (
    echo.
    echo ========================================
    echo Building macOS
    echo ========================================
    if not "%OS%"=="Windows_NT" (
        call flutter build macos
        if !errorlevel! neq 0 (
            echo macOS build failed.
            pause
            goto :eof
        )
        if exist "%RELEASE_DIR%\macos.zip" del "%RELEASE_DIR%\macos.zip"
        tar -a -c -f "%RELEASE_DIR%\macos.zip" -C ".\build\macos\Build\Products\Release" .
    ) else (
        echo macOS build can only be performed on a macOS host. Skipping.
    )
)

if defined build_ios (
    echo.
    echo ========================================
    echo Building iOS
    echo ========================================
    if not "%OS%"=="Windows_NT" (
        call flutter build ipa
        if !errorlevel! neq 0 (
            echo iOS build failed.
            pause
            goto :eof
        )
        xcopy ".\build\ios\ipa" "%RELEASE_DIR%\ios\" /E /I /Y /Q
    ) else (
        echo iOS build can only be performed on a macOS host. Skipping.
    )
)

echo.
echo ========================================
echo All selected builds completed.
echo Output files are in the '%RELEASE_DIR%' directory.
echo ========================================
echo.
pause
endlocal
goto :eof
