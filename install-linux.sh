#!/bin/bash
#
# OSE CAD Automator - Linux Installer
# Works with FreeCAD from AppImage or package manager
#
# Usage: 
#   curl -fsSL https://raw.githubusercontent.com/ose/cad-automator/main/install-linux.sh | bash
#

set -e

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║      OSE CAD Automator - Linux Installer                      ║"
echo "║   Transform FreeCAD files → Build Instructions automatically  ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

INSTALL_DIR="$HOME/ose-cad-automator"

# Check for FreeCAD
echo "🔍 Checking for FreeCAD..."
FREECAD_PATH=""

if command -v freecad &> /dev/null; then
    FREECAD_PATH="freecad"
    echo "✅ FreeCAD found in PATH"
elif [ -f "$HOME/FreeCAD.AppImage" ]; then
    FREECAD_PATH="$HOME/FreeCAD.AppImage"
    echo "✅ FreeCAD AppImage found"
elif [ -f "/usr/bin/freecad" ]; then
    FREECAD_PATH="/usr/bin/freecad"
    echo "✅ FreeCAD found at /usr/bin/freecad"
else
    echo "⚠️  FreeCAD not found"
    echo "   Install with: sudo apt install freecad"
    echo "   Or download AppImage from: https://www.freecad.org/downloads.php"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check for Python 3
echo "🔍 Checking for Python 3..."
if command -v python3 &> /dev/null; then
    echo "✅ Python 3 found"
else
    echo "❌ Python 3 not found. Install with: sudo apt install python3"
    exit 1
fi

# Create installation directory
echo ""
echo "📁 Installing to: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Clone or download
if command -v git &> /dev/null; then
    echo "📥 Cloning repository..."
    git clone --depth 1 https://github.com/ose/cad-automator.git . 2>/dev/null || {
        echo "📥 Downloading scripts directly..."
        # Fallback to curl
        curl -sL https://raw.githubusercontent.com/ose/cad-automator/main/scripts/extract_cad_data.py -o extract_cad_data.py
        curl -sL https://raw.githubusercontent.com/ose/cad-automator/main/scripts/weave_instructions.py -o weave_instructions.py
    }
else
    echo "📥 Downloading scripts..."
    curl -sL https://raw.githubusercontent.com/ose/cad-automator/main/scripts/extract_cad_data.py -o extract_cad_data.py
    curl -sL https://raw.githubusercontent.com/ose/cad-automator/main/scripts/weave_instructions.py -o weave_instructions.py
fi

# Create Linux CLI wrapper
cat > ose-cad << 'LINUXCLI'
#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Find FreeCAD
FREECAD=""
if command -v freecad &> /dev/null; then
    FREECAD="freecad"
elif [ -f "$HOME/FreeCAD.AppImage" ]; then
    FREECAD="$HOME/FreeCAD.AppImage"
elif [ -f "/usr/bin/freecad" ]; then
    FREECAD="/usr/bin/freecad"
fi

case "$1" in
    process)
        echo "🔧 Processing: $2"
        export CAD_FILE="$2"
        $FREECAD --console "$SCRIPT_DIR/extract_cad_data.py" 2>/dev/null
        JSON_FILE="${2%.fcstd}.json"
        JSON_FILE="${JSON_FILE%.FCStd}.json"
        [ -f "$JSON_FILE" ] && python3 "$SCRIPT_DIR/weave_instructions.py" "$JSON_FILE"
        ;;
    extract)
        export CAD_FILE="$2"
        $FREECAD --console "$SCRIPT_DIR/extract_cad_data.py" 2>/dev/null
        ;;
    weave)
        python3 "$SCRIPT_DIR/weave_instructions.py" "$2"
        ;;
    batch)
        find "$2" \( -name "*.fcstd" -o -name "*.FCStd" \) -exec "$0" process {} \;
        ;;
    *)
        echo "OSE CAD Automator"
        echo "Usage: ose-cad <command> <file>"
        echo "  process <file.fcstd>  - Extract + generate instructions"
        echo "  extract <file.fcstd>  - Extract JSON only"
        echo "  weave <file.json>     - Generate instructions"
        echo "  batch <directory>     - Process all .fcstd files"
        ;;
esac
LINUXCLI

chmod +x ose-cad
chmod +x *.py 2>/dev/null

# Add to PATH
SHELL_RC="$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.zshrc"

if ! grep -q "ose-cad-automator" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# OSE CAD Automator" >> "$SHELL_RC"
    echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_RC"
    echo "✅ Added to PATH"
fi

# Create desktop entry
mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/ose-cad-automator.desktop" << DESKTOP
[Desktop Entry]
Name=OSE CAD Automator
Comment=Transform FreeCAD files to build instructions
Exec=$INSTALL_DIR/ose-cad process %f
Icon=freecad
Terminal=true
Type=Application
Categories=Engineering;Graphics;
MimeType=application/x-freecad;
DESKTOP

echo ""
echo "✅ Installation complete!"
echo ""
echo "Usage: ose-cad process /path/to/model.fcstd"
echo ""
echo "Restart terminal or run: source $SHELL_RC"
