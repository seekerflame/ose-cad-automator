# OSE CAD Automator - Windows Installer (PowerShell)
# Run as: powershell -ExecutionPolicy Bypass -File install-windows.ps1
#
# Or in PowerShell:
#   Set-ExecutionPolicy Bypass -Scope Process -Force
#   .\install-windows.ps1

Write-Host @"
╔═══════════════════════════════════════════════════════════════╗
║      OSE CAD Automator - Windows Installer                    ║
║   Transform FreeCAD files → Build Instructions automatically  ║
╚═══════════════════════════════════════════════════════════════╝
"@

$InstallDir = "$env:USERPROFILE\ose-cad-automator"

# Check for FreeCAD
Write-Host "`n🔍 Checking for FreeCAD..."
$FreeCADPath = ""

$PossiblePaths = @(
    "C:\Program Files\FreeCAD 0.21\bin\FreeCAD.exe",
    "C:\Program Files\FreeCAD 1.0\bin\FreeCAD.exe",
    "C:\Program Files\FreeCAD\bin\FreeCAD.exe",
    "C:\Program Files (x86)\FreeCAD\bin\FreeCAD.exe"
)

foreach ($path in $PossiblePaths) {
    if (Test-Path $path) {
        $FreeCADPath = $path
        Write-Host "✅ FreeCAD found: $path"
        break
    }
}

if (-not $FreeCADPath) {
    Write-Host "⚠️  FreeCAD not found in standard locations"
    Write-Host "   Download from: https://www.freecad.org/downloads.php"
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne "y") { exit 1 }
}

# Check for Python
Write-Host "`n🔍 Checking for Python..."
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ $pythonVersion"
} catch {
    Write-Host "❌ Python not found. Install from: https://www.python.org/downloads/"
    exit 1
}

# Create install directory
Write-Host "`n📁 Installing to: $InstallDir"
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Set-Location $InstallDir

# Download scripts
Write-Host "📥 Downloading scripts..."

$scripts = @{
    "extract_cad_data.py" = "https://raw.githubusercontent.com/ose/cad-automator/main/scripts/extract_cad_data.py"
    "weave_instructions.py" = "https://raw.githubusercontent.com/ose/cad-automator/main/scripts/weave_instructions.py"
}

foreach ($script in $scripts.GetEnumerator()) {
    try {
        Invoke-WebRequest -Uri $script.Value -OutFile $script.Key -UseBasicParsing
        Write-Host "  ✅ $($script.Key)"
    } catch {
        Write-Host "  ❌ Failed to download $($script.Key)"
    }
}

# Create batch file wrapper
$batchContent = @"
@echo off
setlocal

set SCRIPT_DIR=%~dp0
set FREECAD_PATH=$FreeCADPath

if "%1"=="process" goto process
if "%1"=="extract" goto extract  
if "%1"=="weave" goto weave
if "%1"=="batch" goto batch
goto help

:process
echo Processing: %2
set CAD_FILE=%2
"%FREECAD_PATH%" --console "%SCRIPT_DIR%extract_cad_data.py"
set JSON_FILE=%~dpn2.json
if exist "%JSON_FILE%" python "%SCRIPT_DIR%weave_instructions.py" "%JSON_FILE%"
goto end

:extract
set CAD_FILE=%2
"%FREECAD_PATH%" --console "%SCRIPT_DIR%extract_cad_data.py"
goto end

:weave
python "%SCRIPT_DIR%weave_instructions.py" %2
goto end

:batch
for /r %2 %%f in (*.fcstd *.FCStd) do call "%~f0" process "%%f"
goto end

:help
echo OSE CAD Automator
echo Usage: ose-cad ^<command^> ^<file^>
echo   process ^<file.fcstd^>  - Extract + generate instructions
echo   extract ^<file.fcstd^>  - Extract JSON only
echo   weave ^<file.json^>     - Generate instructions
echo   batch ^<directory^>     - Process all .fcstd files

:end
"@

$batchContent | Out-File -FilePath "ose-cad.bat" -Encoding ASCII

# Add to PATH
Write-Host "`n📍 Adding to PATH..."
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*ose-cad-automator*") {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$InstallDir", "User")
    Write-Host "✅ Added to user PATH"
}

# Create Start Menu shortcut
$WshShell = New-Object -ComObject WScript.Shell
$ShortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\OSE CAD Automator.lnk"
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "$InstallDir\ose-cad.bat"
$Shortcut.WorkingDirectory = $InstallDir
$Shortcut.Save()

Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║                  Installation Complete! 🎉                     ║
╚═══════════════════════════════════════════════════════════════╝

📂 Installed to: $InstallDir

🚀 Usage (open new Command Prompt):
   ose-cad process C:\path\to\model.fcstd

📚 Documentation: https://github.com/ose/cad-automator
"@
