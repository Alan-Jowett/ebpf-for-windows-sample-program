@echo off
REM Copyright (c) eBPF for Windows contributors
REM SPDX-License-Identifier: MIT

REM Script to format C/C++ code using clang-format

setlocal

set SCRIPT_DIR=%~dp0
set REPO_ROOT=%SCRIPT_DIR%..

echo Formatting C/C++ files...

REM Check if clang-format is available
where clang-format >nul 2>&1
if errorlevel 1 (
    echo Error: clang-format not found in PATH
    echo Please install LLVM tools or Visual Studio with C++ tools
    exit /b 1
)

REM Get clang-format version
for /f "tokens=3" %%i in ('clang-format --version') do set CF_VERSION=%%i
echo Using clang-format version: %CF_VERSION%

REM Format all C/C++ files in the repository
for /r "%REPO_ROOT%" %%f in (*.c *.cpp *.h *.hpp) do (
    REM Skip files in .git directory
    echo %%f | findstr "\.git\" >nul
    if errorlevel 1 (
        echo Formatting: %%f
        clang-format -i "%%f"
        if errorlevel 1 (
            echo Error formatting: %%f
            exit /b 1
        )
    )
)

echo Code formatting completed successfully.
echo Please stage the formatting changes with your commit.