# PowerShell installer for Claude-All-New
# Run this in PowerShell or Command Prompt

param(
    [switch]$System
)

# Colors for PowerShell
$GREEN = "Green"
$BLUE = "Cyan"
$YELLOW = "Yellow"
$RED = "Red"
$WHITE = "White"

Write-Host "🚀 Claude-All-New - One Command Installer" -ForegroundColor $GREEN
Write-Host "===========================================" -ForegroundColor $GREEN
Write-Host ""

# Check if curl is available
$curlAvailable = Get-Command curl -ErrorAction SilentlyContinue

if (-not $curlAvailable) {
    Write-Host "Error: curl is not installed or not in PATH" -ForegroundColor $RED
    Write-Host ""
    Write-Host "Please install Git for Windows (includes curl):" -ForegroundColor $YELLOW
    Write-Host "  https://git-scm.com/download/win" -ForegroundColor $BLUE
    Write-Host ""
    Write-Host "Or install via Chocolatey:" -ForegroundColor $YELLOW
    Write-Host "  choco install curl" -ForegroundColor $BLUE
    Write-Host ""
    exit 1
}

# Create temp directory
$tempDir = Join-Path $env:TEMP "claude-all-new-$(Get-Random)"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

Set-Location $tempDir

Write-Host "Downloading Claude-All-New..." -ForegroundColor $BLUE
Invoke-WebRequest -Uri "https://github.com/zesbe/Claude-All-New/archive/main.zip" -OutFile "claude-all-new.zip"

Write-Host "Extracting files..." -ForegroundColor $BLUE
Expand-Archive -Path "claude-all-new.zip" -DestinationPath "." -Force

Set-Location "Claude-All-New-main"

# Choose installation directory
$installDir = if ($System) {
    if ($IsLinux -or $IsMacOS) {
        "/usr/local/bin"
    } else {
        "$env:USERPROFILE\.local\bin"
    }
} else {
    "$env:USERPROFILE\.local\bin"
}

if ($System -and $PSVersionTable.OS -notmatch "Linux|MacOS") {
    Write-Host "System-wide installation not supported on Windows" -ForegroundColor $YELLOW
    Write-Host "Using user directory instead: $installDir" -ForegroundColor $BLUE
}

Write-Host "Installing to $installDir" -ForegroundColor $BLUE
New-Item -ItemType Directory -Path $installDir -Force | Out-Null

# Copy files
Copy-Item -Path "bin\*" -Destination $installDir -Force

# Copy model config
if (Test-Path "model") {
    $modelDir = Join-Path $installDir "model"
    New-Item -ItemType Directory -Path $modelDir -Force | Out-Null
    Copy-Item -Path "model\*" -Destination $modelDir -Force
}

# Cleanup
Set-Location $env:TEMP
Remove-Item -Path $tempDir -Recurse -Force

# Check if PATH needs updating
$pathUpdated = $false
if ($env:PATH -notlike "*$installDir*") {
    Write-Host ""
    Write-Host "⚠️  Important: Add installation directory to PATH" -ForegroundColor $YELLOW
    Write-Host ""
    Write-Host "PowerShell (permanent):" -ForegroundColor $BLUE
    Write-Host "  [Environment]::SetEnvironmentVariable('PATH', `"$env:PATH;$installDir`", 'User')" -ForegroundColor $WHITE
    Write-Host ""
    Write-Host "Command Prompt:" -ForegroundColor $BLUE
    Write-Host "  setx PATH `"%PATH%;$installDir`"" -ForegroundColor $WHITE
    Write-Host ""
    Write-Host "Git Bash:" -ForegroundColor $BLUE
    Write-Host "  echo 'export PATH=`"$installDir:`$PATH`"' >> ~/.bashrc" -ForegroundColor $WHITE
    Write-Host ""
    $pathUpdated = $true
}

Write-Host ""
Write-Host "✅ Installation complete!" -ForegroundColor $GREEN
Write-Host ""
Write-Host "🎉 Claude-All-New is now installed!" -ForegroundColor $GREEN
Write-Host ""
Write-Host "Platform: Windows" -ForegroundColor $BLUE
Write-Host "Install Dir: $installDir" -ForegroundColor $BLUE
Write-Host ""

if ($pathUpdated) {
    Write-Host "⚠️  IMPORTANT: You need to update your PATH first!" -ForegroundColor $YELLOW
    Write-Host ""
}

Write-Host "Next steps:" -ForegroundColor $BLUE
Write-Host "1. Get your API keys:" -ForegroundColor $WHITE
Write-Host "   • GLM: https://open.bigmodel.cn/usercenter/apikeys" -ForegroundColor $BLUE
Write-Host "   • MiniMax: https://platform.minimax.io/" -ForegroundColor $BLUE
Write-Host "   • OpenAI: https://platform.openai.com/api-keys" -ForegroundColor $BLUE
Write-Host "   • Gemini: https://aistudio.google.com/app/apikey" -ForegroundColor $BLUE
Write-Host ""
Write-Host "2. Save API keys:" -ForegroundColor $WHITE
Write-Host "   claude-all" -ForegroundColor $BLUE
Write-Host "   # Choose: 10) 🔑 API Key Manager" -ForegroundColor $WHITE
Write-Host ""
Write-Host "   Or directly:" -ForegroundColor $WHITE
Write-Host "   glm-key update" -ForegroundColor $BLUE
Write-Host "   minimax-key update" -ForegroundColor $BLUE
Write-Host ""
Write-Host "3. Start chatting:" -ForegroundColor $WHITE
Write-Host "   claude-all 7    # For GLM" -ForegroundColor $BLUE
Write-Host "   claude-all 1    # For MiniMax" -ForegroundColor $BLUE
Write-Host ""
Write-Host "📚 Documentation:" -ForegroundColor $BLUE
Write-Host "   https://github.com/zesbe/Claude-All-New" -ForegroundColor $WHITE
Write-Host ""
Write-Host "Happy Chatting! 🚀" -ForegroundColor $GREEN
