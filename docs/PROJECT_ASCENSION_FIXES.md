# Project Ascension Compatibility Fixes

## Changes Made

### Problem
FloAspectBar and FloTotemBar were loading without errors but not displaying because:
- Project Ascension uses different spell IDs than retail WotLK
- The hardcoded spell IDs in `data.lua` didn't match Ascension's custom spell system
- `IsSpellKnown(spellID)` was always returning false

### Solution
Implemented **dynamic spell discovery** that:
1. Scans the player's **Stance/Shapeshift bar** to find actual aspects/forms
2. Works with ANY spell IDs (no hardcoding)
3. Works with ANY client language (English, German, French, etc.)
4. Adapts to Project Ascension's custom spell system

### Files Modified

#### FloAspectBar/FloLib.lua
- Added `FloLib_ScanShapeshiftBar()` function
  - Scans `GetNumShapeshiftForms()` and `GetShapeshiftFormInfo()`
  - Dynamically builds spell list from what player actually has
  
- Modified `FloLib_Setup()` function
  - Checks for `useDynamicDiscovery` flag
  - Uses scanned spells instead of hardcoded spell IDs
  - Skips `IsSpellKnown()` check for dynamically discovered spells

#### FloAspectBar/FloAspectBar.lua
- Modified `FloAspectBar_OnLoad()` function
  - Sets `useDynamicDiscovery = true` flag
  - Allows Hunter class even if hardcoded spells are missing
  - Falls back to empty table for `availableSpells`

#### FloTotemBar/FloLib.lua
- Copied updated FloLib.lua (same dynamic discovery logic)

### Testing Steps

1. **Reload UI** after updating files
2. **Run diagnostic**: `/run FloBarDiagnostic()`
3. Check the output for:
   - "Number of Forms/Aspects" should show > 0
   - Each aspect should be listed with its name
4. Check if FloAspectBar is now visible
5. Try casting different aspects

### Expected Results

✅ FloAspectBar should now **automatically appear** if you have aspects in your stance bar

✅ Should work with:
- Any aspect spell IDs (Ascension custom or retail)
- Any language client
- Any custom class builds with hunter aspects

### Troubleshooting

If still not visible:
1. Check diagnostic output - are forms being detected?
2. Try `/fab unlock` to unlock the bar position
3. Try `/fab scale 1.5` to make it bigger
4. Check if you have any aspects learned
5. Look for the stance/shapeshift bar buttons on your UI

### For TotemBar

Similar changes needed for FloTotemBar - the totem system is more complex as it needs to:
- Detect trap spells (for hunters)
- Detect totem spells by element (earth/fire/water/air for shamans)
- This may require additional work to categorize spells properly

### Future Improvements

- Add manual spell configuration UI for users to add custom spells
- Improve totem/trap detection for Project Ascension's custom abilities
- Add support for other classes with stance bars (warriors, druids, rogues)
