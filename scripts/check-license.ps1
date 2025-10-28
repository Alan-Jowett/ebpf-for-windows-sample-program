# PowerShell version of license checking script
# Copyright (c) eBPF for Windows contributors
# SPDX-License-Identifier: MIT

param(
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

Write-Host "Checking license headers..." -ForegroundColor Green

# Expected license headers
$CopyrightPattern = "Copyright \(c\) eBPF for Windows contributors"
$SpdxPattern = "SPDX-License-Identifier: MIT"

# Check for ignore file
$IgnoreFile = Join-Path $ScriptDir ".check-license.ignore"
$IgnorePatterns = @()
if (Test-Path $IgnoreFile) {
    $IgnorePatterns = Get-Content $IgnoreFile | Where-Object { $_ -and !$_.StartsWith("#") }
}

# Find all C/C++ files
$files = Get-ChildItem -Path $TargetPath -Recurse -Include "*.c", "*.cpp", "*.h", "*.hpp" | 
    Where-Object { $_.FullName -notmatch "\.git" }

$errorCount = 0

foreach ($file in $files) {
    # Check if file should be ignored
    $shouldIgnore = $false
    foreach ($pattern in $IgnorePatterns) {
        if ($file.FullName -match $pattern) {
            $shouldIgnore = $true
            break
        }
    }
    
    if ($shouldIgnore) {
        continue
    }
    
    # Read first 10 lines to check for license header
    $firstLines = Get-Content -Path $file.FullName -TotalCount 10 -ErrorAction SilentlyContinue
    if (-not $firstLines) {
        Write-Warning "Could not read file: $($file.FullName)"
        continue
    }
    
    $content = $firstLines -join "`n"
    
    $hasCopyright = $content -match $CopyrightPattern
    $hasSpdx = $content -match $SpdxPattern
    
    if (-not $hasCopyright) {
        Write-Warning "Missing copyright header: $($file.FullName)"
        $errorCount++
    }
    
    if (-not $hasSpdx) {
        Write-Warning "Missing SPDX license identifier: $($file.FullName)"
        $errorCount++
    }
}

Write-Host ""
if ($errorCount -eq 0) {
    Write-Host "All files have proper license headers." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Found $errorCount files with missing or incorrect license headers." -ForegroundColor Red
    Write-Host ""
    Write-Host "Please add the following header to the top of each file:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "For C/C++ files:" -ForegroundColor Cyan
    Write-Host "// Copyright (c) eBPF for Windows contributors"
    Write-Host "// SPDX-License-Identifier: MIT"
    Write-Host ""
    Write-Host "You can add files to scripts\.check-license.ignore to skip license checking." -ForegroundColor Yellow
    exit 1
}