# FloTotemBar - GitHub Copilot Instructions

> **Note for Workspace Users**: If you're working in the full "World of Warcraft" workspace, shared Copilot instructions are maintained at `../../.github/copilot-instructions.md`. The `chatmodes/` and `instructions/` folders in this directory are junctions to the workspace-level files.

> **Note for Standalone Users**: If you cloned this repository individually, the junctions won't work. This file contains the essential information you need for development.

## Quick Start

**FloTotemBar** is a comprehensive Hunter trap and Shaman totem bar addon for Project Ascension with timers and dynamic spell detection.

### Essential Information:

- **Language**: Lua 5.1 (WoW API)
- **Game Version**: WotLK 3.3.0 (Interface 30300)
- **Features**: Trap timers, totem management, keybindings, dynamic detection

### Core Philosophy:

1. **Simple & Lightweight** - Minimal overhead
2. **Dynamic Detection** - No hardcoded spell IDs
3. **User-Friendly** - Intuitive commands and keybindings

### Key Commands:

- `/ftb` or `/flototembar` - Show help
- `/ftb lock` / `/ftb unlock` - Lock/unlock bar positions
- `/ftb scale 1.2` - Set bar scale
- `/ftb reset` - Reset all settings
- `/reload` - Reload UI after changes

### Development Structure:

```
FloTotemBar/
├── README.md                    # Usage and features
├── INSTALLATION_GUIDE.md        # Installation instructions
├── docs/                        # Project documentation
└── FloTotemBar/                # Addon files
    ├── FloTotemBar.toc         # TOC file
    ├── FloTotemBar.lua         # Main logic
    ├── Bindings.xml            # Keybinding definitions
    ├── data.lua                # Spell data
    ├── diagnostic.lua          # Debug tools
    ├── FloLib.lua              # Shared library
    └── images/                 # Totem icons
```

### Key Files:

- **FloTotemBar.lua** - Main bar logic and detection
- **data.lua** - Spell filtering patterns
- **Bindings.xml** - Keybinding configuration
- **diagnostic.lua** - Run `/run FloBarDiagnostic()` for debugging

### Diagnostic:

Run `/run FloBarDiagnostic()` in-game to see detected traps/totems and troubleshoot issues.

### Keybindings:

Set up keybindings via ESC → Key Bindings → FloTotemBar section.

## Full Documentation

For complete documentation, see:
- **README.md** - Features, commands, troubleshooting
- **INSTALLATION_GUIDE.md** - Step-by-step installation
- **docs/PROJECT_SUMMARY.md** - Technical details

## Workspace Integration

This addon is part of a larger workspace with shared development standards. If you're contributing to multiple Project Ascension addons, consider cloning the full workspace at <https://github.com/CTOUT/> for shared tooling and instructions.
