#!/bin/bash
# Stress test: extract + weave all FCStd files from SSD
# Output: /tmp/ose_stress_test/[module_name]_Instructions.md
# Skips macOS ._* metadata files

FREECAD_PYTHON="/Users/eternalflame/Desktop/FreeCAD.app/Contents/Resources/bin/python"
FREECAD_LIB="/Users/eternalflame/Desktop/FreeCAD.app/Contents/Resources/lib"
OSE_SSD="/Volumes/Extreme SSD/Nick/OSE/SH7CAD/Structural Assemblies"
EXTRACTOR="/Users/eternalflame/Eternal-Stack/projects/ose-cad-automator/scripts/extract_cad_data.py"
WEAVER="/Users/eternalflame/Eternal-Stack/projects/ose-cad-automator/scripts/weave_instructions.py"
OUT_DIR="/tmp/ose_stress_test"

mkdir -p "$OUT_DIR"

PASS=0
FAIL=0
SKIP=0

echo "======================================"
echo "OSE CAD Automator — Stress Test Batch"
echo "======================================"
echo ""

while IFS= read -r fcstd; do
    # Skip macOS metadata files
    basename=$(basename "$fcstd")
    if [[ "$basename" == ._* ]]; then
        ((SKIP++))
        continue
    fi

    stem="${basename%.fcstd}"
    stem="${stem%.FCStd}"
    json_out="$OUT_DIR/${stem}.json"
    md_out="$OUT_DIR/${stem}_Instructions.md"

    echo "▶ $stem"

    # Step 1: Extract
    extract_out=$(PYTHONPATH="$FREECAD_LIB" DYLD_LIBRARY_PATH="$FREECAD_LIB" \
        "$FREECAD_PYTHON" "$EXTRACTOR" "$fcstd" 2>&1)
    extract_json=$(echo "$extract_out" | grep "SUCCESS:" | sed 's/SUCCESS: Compiled CAD data to //')

    if [[ -z "$extract_json" ]]; then
        echo "  ✗ EXTRACT FAILED"
        echo "    $extract_out" | tail -3
        ((FAIL++))
        continue
    fi

    # Copy JSON to OUT_DIR for weave step
    cp "$extract_json" "$json_out" 2>/dev/null || json_out="$extract_json"

    # Step 2: Weave
    weave_out=$(python3 "$WEAVER" "$json_out" "$md_out" 2>&1)
    if [[ $? -eq 0 ]]; then
        parts=$(echo "$weave_out" | grep "Parts analyzed" | grep -o '[0-9]* parts' | head -1)
        echo "  ✓ OK — $parts"
        ((PASS++))
    else
        echo "  ✗ WEAVE FAILED: $weave_out"
        ((FAIL++))
    fi

done < <(find "$OSE_SSD" -name "*.fcstd" -o -name "*.FCStd" 2>/dev/null | grep -v "/\._")

echo ""
echo "======================================"
echo "RESULTS"
echo "======================================"
echo "  PASS:  $PASS"
echo "  FAIL:  $FAIL"
echo "  SKIP:  $SKIP (metadata)"
echo "  TOTAL: $((PASS + FAIL))"
echo ""
echo "Output: $OUT_DIR"
