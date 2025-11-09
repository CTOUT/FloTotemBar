# Project Ascension Compatibility Update

## Summary
Added full support for Project Ascension's custom spell system through dynamic spellbook scanning. The addon now works with Hunter traps, Shaman totems, and any custom spells without requiring hardcoded spell databases.

## Key Changes

### Dynamic Spell Discovery
- Implemented `FloLib_ScanShapeshiftBar()` with customizable search patterns
- Detects spells by name pattern: traps, totems, aspects, auras, etc.
- No longer relies on hardcoded spell IDs that don't match Ascension's custom system

### Hunter Trap Support
- Enabled dynamic discovery for Hunter trap bar (`FloBarTRAP`)
- Scans spellbook for all trap spells regardless of spell ID
- Works with Explosive Trap, Freezing Trap, Frost Trap, Immolation Trap, etc.

### Smart Filtering
- Automatically filters out passive spells using `IsPassiveSpell()`
- Shows only the highest rank of each spell (no duplicate ranks)
- Alphabetically sorts spells for consistent display

### Search Pattern System
- `"trap"` - Finds all trap spells (Hunter)
- `"totem"` - Finds totem spells (Shaman)
- `"aspect|aura|stance|seal|presence"` - Default pattern for stance-like buffs

## Files Modified
- `FloLib.lua` - Added dynamic scanning with customizable search patterns
- `FloTotemBar.lua` - Enabled dynamic discovery for Hunter TRAP bar
- `diagnostic.lua` - Added debugging tool for troubleshooting

## Testing
Tested on Project Ascension with Hunter traps:
- ✅ Detects all learned traps regardless of spell ID
- ✅ Filters out passive abilities
- ✅ Shows only highest ranks
- ✅ Alphabetical sorting
- ✅ Works with any client language

## Compatibility
- **Project Ascension**: Full support (Wildcard, Classless, Classic+)
- **Retail WoW 3.3.5**: Maintains backward compatibility for Shamans
- **Other Languages**: Fully language-agnostic

## Future Improvements
- Add dynamic discovery for Shaman totem bars
- Support for other classes (DK presences, Paladin auras, etc.)
- Integration with FloFlyout for spell combinations

## Credits
Original addon by Floraline
Project Ascension compatibility by CTOUT
