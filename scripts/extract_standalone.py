#!/usr/bin/env python3
"""
FreeCAD Extraction Script - Standalone
Run directly with FreeCAD: FreeCAD --console this_script.py /path/to/file.fcstd /path/to/output.json
"""
import sys
import os

# Get paths from command line
if len(sys.argv) < 3:
    print("Usage: FreeCAD --console extract_standalone.py <input.fcstd> <output.json>")
    sys.exit(1)

input_file = sys.argv[1]
output_file = sys.argv[2]

print(f"Extracting: {input_file}")
print(f"Output: {output_file}")

try:
    import FreeCAD
    import json
    
    doc = FreeCAD.openDocument(input_file)
    
    data = {
        "filename": os.path.basename(input_file),
        "parts": []
    }
    
    for obj in doc.Objects:
        part = {
            "name": obj.Name,
            "label": obj.Label if hasattr(obj, "Label") else obj.Name,
            "type_id": obj.TypeId,
            "properties": {}
        }
        
        if hasattr(obj, "Label"):
            part["properties"]["Label"] = obj.Label
        if hasattr(obj, "Placement"):
            part["properties"]["Placement"] = str(obj.Placement)
        
        data["parts"].append(part)
    
    with open(output_file, "w") as f:
        json.dump(data, f, indent=2)
    
    print(f"SUCCESS: Extracted {len(data['parts'])} parts")
    FreeCAD.closeDocument(doc.Name)
    
except Exception as e:
    print(f"ERROR: {e}")
    sys.exit(1)
