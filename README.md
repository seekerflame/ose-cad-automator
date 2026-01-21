# OSE CAD Automator 🏗️

> **Transform FreeCAD CAD files into build instructions automatically**  
> Part of the [Open Source Ecology](https://opensourceecology.org) ecosystem

![License: CERN-OHL-S-2.0](https://img.shields.io/badge/License-CERN--OHL--S--2.0-blue.svg)
![Python 3.8+](https://img.shields.io/badge/python-3.8+-green.svg)
![FreeCAD 0.21+](https://img.shields.io/badge/FreeCAD-0.21+-orange.svg)
[![Platform: Cross](https://img.shields.io/badge/platform-macOS%20|%20Linux%20|%20Windows-lightgrey.svg)](https://github.com/seekerflame/ose-cad-automator)

---

## 🎯 What is this?

OSE CAD Automator transforms FreeCAD CAD files into **platinum-quality build instructions** that anyone can follow to construct real-world projects.

**Problem Solved**: Thousands of hours of CAD documentation → Automated in minutes.

**Features:**

- 📋 Auto-generated Bill of Materials (BOM)
- 🔧 Tools list with purposes
- 🪵 Lumber cut lists with quantities
- 🔩 Hardware estimates (screws, nails)
- 🏗️ Step-by-step assembly phases
- 📐 ASCII reference diagrams
- ⏱️ Time and cost estimates

---

## 🚀 Quick Start

### One-Click Install

**macOS:**

```bash
curl -fsSL https://raw.githubusercontent.com/seekerflame/ose-cad-automator/main/install.sh | bash
```

**Linux:**

```bash
curl -fsSL https://raw.githubusercontent.com/seekerflame/ose-cad-automator/main/install-linux.sh | bash
```

**Windows (PowerShell as Admin):**

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
iwr -useb https://raw.githubusercontent.com/seekerflame/ose-cad-automator/main/install-windows.ps1 | iex
```

### Manual Install

```bash
git clone https://github.com/seekerflame/ose-cad-automator.git
cd ose-cad-automator
# Ready to use!
```

### Usage

```bash
# Process a single file
ose-cad process /path/to/model.fcstd

# Batch process a directory
ose-cad batch /path/to/cad/folder/

# Output: model_Instructions.md (Platinum format)
```

---

## 📖 OSE Wiki Integration

This tool is designed for the [OSE Wiki](https://wiki.opensourceecology.org) with a dedicated namespace:

### Wiki Structure: `OSE:CAD/*`

```
OSE:CAD/                          # Main namespace (protected)
├── OSE:CAD/Automator             # Tool documentation
├── OSE:CAD/Schema                # LOD 1000 specification
├── OSE:CAD/SH7/                  # Seed Home 7 modules
│   ├── Floor_Module_1
│   ├── Floor_Module_5
│   ├── Wall_Modules
│   └── Roof_Modules
├── OSE:CAD/GVCS/                 # Global Village Construction Set
│   ├── CEB_Press
│   ├── LifeTrac
│   └── Power_Cube
└── OSE:CAD/Community/            # User-submitted designs
    └── [Pending review]
```

### Live Update Flow

```
                    ┌─────────────────┐
    Builder edits   │   FreeCAD       │
    CAD file        │   (Local)       │
                    └────────┬────────┘
                             │ Save
                             ▼
                    ┌─────────────────┐
                    │  ose-cad        │
                    │  process        │
                    └────────┬────────┘
                             │ Auto-generate
                             ▼
                    ┌─────────────────┐
                    │  Instructions   │
                    │  (.md file)     │
                    └────────┬────────┘
                             │ Push/Sync
                             ▼
                    ┌─────────────────┐
                    │  OSE Wiki       │───► Live update
                    │  (Protected)    │     for everyone
                    └─────────────────┘
```

### Contribution Workflow

1. **Fork** the CAD file from protected page
2. **Edit** in FreeCAD
3. **Process** with `ose-cad`
4. **Submit** Pull Request / Wiki edit
5. **Review** by maintainer (Marcin or designated)
6. **Merge** to protected main page

---

## 🗂️ Repository Structure

```
ose-cad-automator/
├── scripts/
│   ├── extract_cad_data.py   # FreeCAD → JSON extraction
│   ├── weave_instructions.py # JSON → Markdown (Platinum format)
│   └── batch_process.py      # Mass file processor
├── schemas/                  # JSON validation schemas
├── templates/                # Instruction templates
├── training_data/            # Sample processed models
├── docs/                     # Extended documentation
│   └── BUILDBOT_VOICE_AI.md  # Future: Voice-controlled CAD
└── tests/                    # Test suite
```

---

## 🔐 Privacy & Security

This tool is designed with privacy as a core principle:

- ✅ **100% Local Processing** - No cloud required
- ✅ **No Telemetry** - Zero data collection
- ✅ **No API Keys** - Works offline
- ✅ **Open Source** - Fully auditable code
- ✅ **No Personal Data** - Scripts use relative paths only

---

## 🛣️ Roadmap

### Phase 1: Core Functionality ✅

- [x] FreeCAD → JSON extraction
- [x] Platinum instruction generation
- [x] Cross-platform installers
- [x] GitHub release

### Phase 2: GVCS Processing (Current)

- [ ] Process all 47 SH7 modules
- [ ] CEB Press instructions
- [ ] LifeTrac instructions
- [ ] Power Cube instructions

### Phase 3: Wiki Integration

- [ ] OSE:CAD namespace setup
- [ ] Automated wiki sync
- [ ] Community contribution workflow

### Phase 4: Voice AI (Future)

- [ ] BuildBot voice interface
- [ ] Kid-friendly mode
- [ ] Senior accessibility
- [ ] Ollama + Claude integration

---

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines.

**Priority Areas:**

1. Process more GVCS machines
2. Improve instruction quality
3. Add STL/STEP import support
4. Build validation/error diagnosis
5. Internationalization

---

## 📜 License

**CERN Open Hardware License Version 2 - Strongly Reciprocal (CERN-OHL-S-2.0)**

This is the standard license for all OSE projects, ensuring:

- Freedom to use, study, modify, and share
- Improvements must be shared back
- No vendor lock-in

---

## 🙏 Acknowledgments

- [Open Source Ecology](https://opensourceecology.org) - The movement
- [FreeCAD](https://freecad.org) - The CAD platform
- OSE Wiki contributors

---

> *"We're developing the Global Village Construction Set – an open source, low-cost, high performance platform for civilization."*  
> — Marcin Jakubowski, OSE Founder
