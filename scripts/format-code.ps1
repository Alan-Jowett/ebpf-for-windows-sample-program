# PowerShell version of format-code script
# Copyright (c) eBPF for Windows contributors
# SPDX-License-Identifier: MIT

param(
    [switch]$Check,
    [string]$Path = $null
)

$ErrorActionPreference = "Stop"

# Get repository root
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir

if ($Path) {
    $TargetPath = $Path
} else {
    $TargetPath = $RepoRoot
}

Write-Host "Checking code formatting..." -ForegroundColor Green

# Check if clang-format is available
try {
    $clangFormatVersion = & clang-format --version 2>$null
    Write-Host "Using: $clangFormatVersion"
} catch {
    Write-Error "clang-format not found in PATH. Please install LLVM tools or Visual Studio with C++ tools."
    exit 1
}

# Find all C/C++ files
$files = Get-ChildItem -Path $TargetPath -Recurse -Include "*.c", "*.cpp", "*.h", "*.hpp" | 
    Where-Object { $_.FullName -notmatch "\.git" }

$formattingIssues = 0

foreach ($file in $files) {
    Write-Host "Checking: $($file.FullName)" -ForegroundColor Cyan
    
    if ($Check) {
        # Check if file needs formatting
        $originalContent = Get-Content -Path $file.FullName -Raw
        $formattedContent = & clang-format $file.FullName
        
        if ($originalContent -ne $formattedContent) {
            Write-Warning "File needs formatting: $($file.FullName)"
            $formattingIssues++
        }
    } else {
        # Format the file
        & clang-format -i $file.FullName
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Error formatting: $($file.FullName)"
            exit 1
        }
    }
}

if ($Check) {
    if ($formattingIssues -eq 0) {
        Write-Host "All files are properly formatted." -ForegroundColor Green
        exit 0
    } else {
        Write-Error "$formattingIssues files need formatting. Run without -Check to fix."
        exit 1
    }
} else {
    Write-Host "Code formatting completed successfully." -ForegroundColor Green
    Write-Host "Please stage the formatting changes with your commit." -ForegroundColor Yellow
}