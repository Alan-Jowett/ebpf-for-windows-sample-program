@echo off
REM Copyright (c) eBPF for Windows contributors
REM SPDX-License-Identifier: MIT

REM Script to check license headers in source files

setlocal enabledelayedexpansion

set SCRIPT_DIR=%~dp0
set REPO_ROOT=%SCRIPT_DIR%..
set ERROR_COUNT=0

echo Checking license headers...

REM Define the expected license header patterns
set C_LICENSE=// Copyright (c) eBPF for Windows contributors
set C_SPDX=// SPDX-License-Identifier: MIT

REM Check for .check-license.ignore file
set IGNORE_FILE=%SCRIPT_DIR%.check-license.ignore

echo.
echo Checking C/C++ files for license headers...

REM Check all C/C++ source files
for /r "%REPO_ROOT%" %%f in (*.c *.cpp *.h *.hpp) do (
    REM Skip files in .git directory
    echo %%f | findstr "\.git\" >nul
    if errorlevel 1 (
        REM Check if file is in ignore list
        set SKIP_FILE=0
        if exist "%IGNORE_FILE%" (
            for /f "usebackq delims=" %%i in ("%IGNORE_FILE%") do (
                echo %%f | findstr "%%i" >nul
                if not errorlevel 1 set SKIP_FILE=1
            )
        )
        
        if !SKIP_FILE! == 0 (
            REM Check for license header in first few lines
            set HAS_COPYRIGHT=0
            set HAS_SPDX=0
            set LINE_COUNT=0
            
            for /f "usebackq delims=" %%l in ("%%f") do (
                set /a LINE_COUNT+=1
                if !LINE_COUNT! LEQ 10 (
                    echo %%l | findstr /C:"Copyright (c) eBPF for Windows contributors" >nul
                    if not errorlevel 1 set HAS_COPYRIGHT=1
                    
                    echo %%l | findstr /C:"SPDX-License-Identifier: MIT" >nul
                    if not errorlevel 1 set HAS_SPDX=1
                )
            )
            
            if !HAS_COPYRIGHT! == 0 (
                echo Missing copyright header: %%f
                set /a ERROR_COUNT+=1
            )
            if !HAS_SPDX! == 0 (
                echo Missing SPDX license identifier: %%f
                set /a ERROR_COUNT+=1
            )
        )
    )
)

echo.
if %ERROR_COUNT% == 0 (
    echo All files have proper license headers.
    exit /b 0
) else (
    echo Found %ERROR_COUNT% files with missing or incorrect license headers.
    echo.
    echo Please add the following header to the top of each file:
    echo.
    echo For C/C++ files:
    echo %C_LICENSE%
    echo %C_SPDX%
    echo.
    echo You can add files to scripts\.check-license.ignore to skip license checking.
    exit /b 1
)