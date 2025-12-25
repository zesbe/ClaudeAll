# Claude-All-New Uninstaller for Windows PowerShell

$GREEN = "Green"
$BLUE = "Cyan"
$RED = "Red"
$YELLOW = "Yellow"
$WHITE = "White"

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor $RED
Write-Host "║   Claude-All-New Uninstaller           ║" -ForegroundColor $RED
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor $RED
Write-Host ""

$installDir = "$env:USERPROFILE\.local\bin"

Write-Host "Platform: Windows" -ForegroundColor $YELLOW
Write-Host "Install Dir: $installDir" -ForegroundColor $YELLOW
Write-Host ""

# Check if installed
if (-not (Test-Path "$installDir\claude-all")) {
    Write-Host "Claude-All-New is not installed in $installDir" -ForegroundColor $YELLOW
    $checkOther = Read-Host "Check another location? (y/N)"
    if ($checkOther -eq "y" -or $checkOther -eq "Y") {
        $installDir = Read-Host "Enter install directory"
        if (-not (Test-Path "$installDir\claude-all")) {
            Write-Host "Not found in $installDir" -ForegroundColor $RED
            exit 1
        }
    } else {
        exit 0
    }
}

Write-Host "Found Claude-All-New installation:" -ForegroundColor $BLUE
Write-Host ""

# Files to remove
$filesToRemove = @(
    "$installDir\claude-all",
    "$installDir\api-manager"
)

if (Test-Path "$installDir\model") {
    $filesToRemove += "$installDir\model"
}

Write-Host "Files to remove:"
foreach ($file in $filesToRemove) {
    if (Test-Path $file) {
        Write-Host "  X $file" -ForegroundColor $RED
    }
}
Write-Host ""

# API Keys
$apiKeyFiles = @(
    "$env:USERPROFILE\.glm_api_key",
    "$env:USERPROFILE\.minimax_api_key",
    "$env:USERPROFILE\.openai_api_key",
    "$env:USERPROFILE\.gemini_api_key",
    "$env:USERPROFILE\.xai_api_key",
    "$env:USERPROFILE\.groq_api_key"
)

$foundKeys = @()
foreach ($keyfile in $apiKeyFiles) {
    if (Test-Path $keyfile) {
        $foundKeys += $keyfile
    }
}

if ($foundKeys.Count -gt 0) {
    Write-Host "Found API key files:" -ForegroundColor $YELLOW
    foreach ($keyfile in $foundKeys) {
        Write-Host "  🔑 $keyfile" -ForegroundColor $YELLOW
    }
    Write-Host ""
}

# Confirmation
Write-Host "⚠️  This action cannot be undone!" -ForegroundColor $RED
Write-Host ""
$confirm = Read-Host "Remove Claude-All-New? (y/N)"

if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Cancelled."
    exit 0
}

Write-Host ""

# Remove program files
Write-Host "Removing program files..." -ForegroundColor $BLUE
foreach ($file in $filesToRemove) {
    if (Test-Path $file) {
        try {
            Remove-Item -Path $file -Recurse -Force
            Write-Host "  ✓ Removed: $file" -ForegroundColor $GREEN
        } catch {
            Write-Host "  ✗ Failed: $file" -ForegroundColor $RED
        }
    }
}

# Ask about API keys
if ($foundKeys.Count -gt 0) {
    Write-Host ""
    $removeKeys = Read-Host "Also remove API key files? (y/N)"

    if ($removeKeys -eq "y" -or $removeKeys -eq "Y") {
        Write-Host "Removing API key files..." -ForegroundColor $BLUE
        foreach ($keyfile in $foundKeys) {
            try {
                Remove-Item -Path $keyfile -Force
                Write-Host "  ✓ Removed: $keyfile" -ForegroundColor $GREEN
            } catch {
                Write-Host "  ✗ Failed: $keyfile" -ForegroundColor $RED
            }
        }
    } else {
        Write-Host "✓ API keys preserved" -ForegroundColor $GREEN
    }
}

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor $GREEN
Write-Host "║   Uninstall Complete!                  ║" -ForegroundColor $GREEN
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor $GREEN
Write-Host ""
Write-Host "Claude-All-New has been removed from your system."
Write-Host ""
Write-Host "To reinstall:" -ForegroundColor $BLUE
Write-Host "  iwr -useb https://raw.githubusercontent.com/zesbe/Claude-All-New/main/install-curl.ps1 | iex"
Write-Host ""
