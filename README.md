# FloTotemBar - Project Ascension Edition

A comprehensive addon that provides convenient bars for Hunter traps and Shaman totems with timers. **Now fully compatible with Project Ascension's custom spell system!**

## Features

✅ **Dynamic Spell Detection** - Automatically finds all your traps/totems, regardless of spell ID  
✅ **Language Agnostic** - Works with any WoW client language  
✅ **Smart Filtering** - Hides passive spells and duplicate ranks  
✅ **Alphabetical Sorting** - Spells displayed in consistent order  
✅ **Trap Timers** - Shows remaining duration for active traps (Hunter)  
✅ **Totem Management** - Full totem bar support for Shamans  
✅ **Project Ascension Compatible** - Works with Wildcard, Classless, and Classic+ servers  

## Installation

> **Note:** The repository contains the addon files in a `FloTotemBar` subfolder. Copy the **inner** folder to your AddOns directory.

1. Download the addon
2. Extract the **inner** `FloTotemBar` folder to your `World of Warcraft/Interface/AddOns/` folder
3. You should have: `Interface/AddOns/FloTotemBar/FloTotemBar.toc`
4. Restart WoW or reload UI (`/reload`)
5. The trap/totem bars will appear automatically based on your class

For detailed installation instructions, see [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md)

## Usage

The addon will automatically detect:
- **Hunters**: All trap spells (Explosive, Freezing, Frost, Immolation, etc.)
- **Shamans**: All totems organized by element (Earth, Fire, Water, Air)

### Commands

- `/ftb` or `/flototembar` - Show help
- `/ftb lock` - Lock bar positions
- `/ftb unlock` - Unlock to move bars
- `/ftb auto` - Automatic positioning
- `/ftb scale <number>` - Set bar scale (e.g., `/ftb scale 1.2`)
- `/ftb borders` - Show borders
- `/ftb noborders` - Hide borders
- `/ftb reset` - Reset all settings

### Moving Bars

1. Type `/ftb unlock`
2. Drag each bar to your desired position
3. Type `/ftb lock` to lock them in place

### Hunter Trap Features

- **Quick Cast**: Click trap icon to place it
- **Trap Timer**: Shows time remaining on placed trap
- **Cooldown Display**: Visual cooldown indicators
- **Keybindings**: Assign hotkeys via Keybindings menu

### Shaman Totem Features

- **Multi-Cast Support**: Quick totem switching
- **Element Bars**: Separate bars for each element
- **Totem Timers**: Track active totem duration
- **Call of Elements**: Quick recall functionality
- **Layout Options**: 1-row, 2-rows, 4-rows layouts

### Right-Click Menu

Right-click any bar to access options:
- Position settings
- Border toggle
- Hide specific spells
- Reorder spells (drag & drop)
- Layout options (Shamans)

## How It Works

Unlike the original addon which used hardcoded spell IDs, this version:

1. **Scans your spellbook** for trap/totem spells by name pattern
2. **Filters out passive spells** automatically
3. **Shows only the highest rank** of each spell
4. **Sorts alphabetically** for consistent display

This means it works with:
- Project Ascension's custom spell IDs
- Any modifications or custom spells
- All languages and locales
- Future spell additions

## Project Ascension Compatibility

This version has been specifically updated for Project Ascension:

### Supported Classes
- ✅ **Hunter** - Full trap bar support with dynamic discovery
- ✅ **Shaman** - Full totem support (uses traditional spell detection)

### Supported Server Types
- ✅ Wildcard
- ✅ Classless  
- ✅ Classic+

### Tested Hunter Traps
- Explosive Trap (all ranks)
- Freezing Trap (all ranks)
- Frost Trap
- Immolation Trap (all ranks)
- Snake Trap (if available)

## Troubleshooting

### Trap bar not showing?
1. Make sure you're playing a Hunter
2. Make sure you have at least one trap spell learned
3. Try `/reload` to reload the UI
4. Try `/ftb unlock` - the bar might be hidden off-screen

### Multiple ranks showing?
This shouldn't happen with the new version. If you see duplicate ranks:
1. Try `/reload`
2. Try `/ftb reset` to reset settings

### Need to debug?
Create a file `diagnostic.lua` in the addon folder and run `/run FloBarDiagnostic()` to see detailed information about detected spells.

## Keybindings

You can assign hotkeys to trap/totem buttons:
1. Press `ESC` > Key Bindings
2. Scroll to "FloTotemBar" section
3. Assign keys to "FloTotem Button 1", "FloTotem Button 2", etc.

## Shaman Layout Options

Type `/ftb` and right-click the Earth totem bar to choose:
- **1 Row** - All bars in one horizontal row
- **2 Rows** - Split into two rows
- **4 Rows** - Each element on separate row
- **2 Rows Reverse** - Reverse vertical order
- **4 Rows Reverse** - Reverse vertical order

## Future Improvements

Planned enhancements:
- Dynamic discovery for Shaman totems (currently uses hardcoded IDs)
- Support for Death Knight presences
- Support for Paladin auras
- Integration with FloFlyout for spell combinations

## Compatibility

- **Project Ascension**: Full support for Hunters, partial for Shamans
- **WoW 3.3.5 (WotLK)**: Full support
- **Other Private Servers**: Should work if using WotLK client

## Related Addons

- **FloAspectBar** - Aspect bar for Hunters
- **FloFlyout** - Combine multiple spells into flyout buttons

## Credits

- **Original Author**: Floraline
- **Project Ascension Update**: CTOUT
- **Fork**: https://github.com/CTOUT/FloTotemBar

## License

This is a modified version of the original FloTotemBar addon. All credit to the original author Floraline.

## Support

For issues specific to Project Ascension compatibility, please open an issue on the GitHub repository:
https://github.com/CTOUT/FloTotemBar/issues
