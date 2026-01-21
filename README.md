# OSE CAD Automator 🏗️

> **Automatically generate build instructions from FreeCAD CAD files**  
> Part of the [Open Source Ecology](https://opensourceecology.org) ecosystem

![License: CERN-OHL-S-2.0](https://img.shields.io/badge/License-CERN--OHL--S--2.0-blue.svg)
![Python 3.8+](https://img.shields.io/badge/python-3.8+-green.svg)
![FreeCAD 0.21+](https://img.shields.io/badge/FreeCAD-0.21+-orange.svg)

---

## 🎯 What is this?

OSE CAD Automator transforms FreeCAD CAD files into **platinum-quality build instructions** that anyone can follow to construct real-world projects.

**Features:**

- 📋 Auto-generated Bill of Materials (BOM)
- 🔧 Tools list with purposes
- 🪵 Lumber cut lists with quantities
- 🔩 Hardware estimates (screws, nails)
- 🏗️ Step-by-step assembly phases
- 📐 ASCII reference diagrams
- ⏱️ Time estimates
- 💰 Cost breakdowns

---

## 🚀 Quick Start

### Prerequisites

- Python 3.8+
- FreeCAD 1.0+ (for extraction)

### Installation

```bash
git clone https://github.com/YOUR_ORG/ose-cad-automator.git
cd ose-cad-automator
pip install -r requirements.txt
```

### Basic Usage

```bash
# Step 1: Extract CAD data to JSON
python scripts/extract_cad_data.py path/to/model.fcstd

# Step 2: Generate Platinum instructions
python scripts/weave_instructions.py path/to/model.json

# Output: path/to/model_Instructions.md
```

### Batch Processing

```bash
# Process all .fcstd files in a directory tree
python scripts/batch_process.py /path/to/cad/directory
```

---

## 📁 Repository Structure

```
ose-cad-automator/
├── scripts/
│   ├── extract_cad_data.py   # FreeCAD → JSON extraction
│   ├── weave_instructions.py # JSON → Markdown (Platinum format)
│   └── batch_process.py      # Mass file processor
│
├── schemas/                  # JSON schemas for validation
├── templates/                # Instruction templates
├── training_data/            # Sample processed models
├── docs/                     # Documentation
└── tests/                    # Test suite
```

---

## 📖 Documentation

- [Architecture Overview](docs/ARCHITECTURE.md)
- [Contributing Guide](docs/CONTRIBUTING.md)
- [Wiki Integration](docs/WIKI_INTEGRATION.md)
- [Building Code Reference](docs/BUILDING_CODE.md)

---

## 🔧 Supported Formats

### Input

- `.fcstd` - FreeCAD files (primary)
- `.json` - Pre-extracted LOD 1000 data
- `.stl` - STL mesh files (planned)
- `.step` - STEP CAD files (planned)

### Output

- `_Instructions.md` - Platinum-quality Markdown build guide
- `.json` - LOD 1000 metadata for further processing

---

## 🌍 OSE Wiki Integration

This tool is designed to work with the [OSE Wiki](https://wiki.opensourceecology.org). Processed instructions can be directly published to:

- `OSE:SH7/*` - Seed Home 7 modules
- `OSE:GVCS/*` - Global Village Construction Set machines
- `OSE:Hangar/*` - Workshop structures

---

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines.

### Priority Areas

1. Additional GVCS machine processing
2. STL/STEP import support
3. Bidirectional editing (instructions → CAD)
4. Build validation/error diagnosis
5. Internationalization

---

## 📜 License

This project is licensed under the **CERN Open Hardware License Version 2 - Strongly Reciprocal (CERN-OHL-S-2.0)** - the standard license for OSE projects.

See [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

- [Open Source Ecology](https://opensourceecology.org) - The movement
- [FreeCAD](https://freecad.org) - The CAD platform
- All OSE contributors and wiki editors

---

> *"We're developing the Global Village Construction Set – an open source, low-cost, high performance platform for civilization."*  
> — Marcin Jakubowski, OSE Founder
