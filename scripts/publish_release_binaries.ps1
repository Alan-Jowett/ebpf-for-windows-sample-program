Param(
    [string]$Workspace = $Env:GITHUB_WORKSPACE
)

# Exit on any error
$ErrorActionPreference = 'Stop'

Write-Host "Workspace: $Workspace"

# Determine branch that triggered the workflow
$ref = $Env:GITHUB_REF
if (-not $ref) {
    throw "GITHUB_REF is not set"
}

# GITHUB_REF for a branch looks like: refs/heads/release/1.2.3
if ($ref -notmatch 'refs/heads/(.+)') {
    throw "GITHUB_REF ($ref) does not look like a branch ref"
}

$branchName = $Matches[1]
Write-Host "Trigger branch: $branchName"

if ($branchName -notmatch '^release/') {
    Write-Host "Not a release branch; exiting"
    exit 0
}

# Extract last part after release/
$releaseSuffix = $branchName -replace '^release/', ''
Write-Host "Release suffix: $releaseSuffix"

# Local paths to artifacts (adjust if different)
$artifactFiles = @('sample_program\sample_program.o', 'sample_program\sample_program.json')
# Local paths to artifacts in x64\Release
# Adjust filenames or paths if your build outputs different names.
$artifactFiles = @('x64\Release\sample_program.o', 'x64\Release\sample_program.json')
foreach ($f in $artifactFiles) {
    $full = Join-Path $Workspace $f
    if (-not (Test-Path $full)) {
        throw "Required artifact not found: $full"
    }
}

# Prepare repo clone to work in a clean repo state
$tempDir = Join-Path $Env:TEMP ([System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $tempDir | Out-Null
Write-Host "Using temp dir: $tempDir"

# Configure git
git config --global user.email "github-actions[bot]@users.noreply.github.com"
git config --global user.name "github-actions[bot]"

# Clone the repo (shallow) and checkout empty_branch
$repo = $Env:GITHUB_REPOSITORY  # owner/repo
if (-not $repo) { throw "GITHUB_REPOSITORY not set" }

$repoUrl = "https://github.com/$repo.git"
Write-Host "Cloning $repoUrl (using http.extraheader for auth)"

# Use http.extraheader to pass the token without embedding it in the URL
git -c "http.extraheader=AUTHORIZATION: bearer $Env:GITHUB_TOKEN" clone --depth 1 $repoUrl $tempDir
Push-Location $tempDir

# Ensure empty_branch exists locally - fetch refs
try {
    git fetch origin empty_branch:empty_branch --depth=1
} catch {
    Write-Host "empty_branch not found on remote, creating an orphan empty branch"
    git checkout --orphan empty_branch
    git rm -rf . | Out-Null
    New-Item -ItemType File -Name README.md -Value "Empty branch for release binaries" | Out-Null
    git add README.md
    git commit -m "Create empty_branch"
    git -c "http.extraheader=AUTHORIZATION: bearer $Env:GITHUB_TOKEN" push origin empty_branch
    git checkout empty_branch
}

# Create release_binaries/<suffix> branch from empty_branch
$targetBranch = "release_binaries/$releaseSuffix"
Write-Host "Creating branch: $targetBranch"

git checkout empty_branch
git checkout -b $targetBranch

# Copy artifacts into repo root
foreach ($f in $artifactFiles) {
    $src = Join-Path $Workspace $f
    $dst = Join-Path $tempDir (Split-Path $f -Leaf)
    Copy-Item -Path $src -Destination $dst -Force
    Write-Host "Copied $src -> $dst"
}

# Commit and push
git add .
git commit -m "Add release binaries for $branchName"

git -c "http.extraheader=AUTHORIZATION: bearer $Env:GITHUB_TOKEN" push origin HEAD:refs/heads/$targetBranch --force

Pop-Location
Write-Host "Published release branch: $targetBranch"

# Cleanup
Remove-Item -Recurse -Force $tempDir
