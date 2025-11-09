# Installation Guide for Project Ascension Players

## Quick Start

### Step 1: Download the Addons

**Option A: From GitHub Releases**
1. Go to [FloAspectBar Releases](https://github.com/CTOUT/FloAspectBar/releases)
2. Download the latest `.zip` file
3. Go to [FloTotemBar Releases](https://github.com/CTOUT/FloTotemBar/releases)
4. Download the latest `.zip` file

**Option B: Clone with Git**
```bash
cd "C:\Program Files (x86)\World of Warcraft\Interface\AddOns"
git clone https://github.com/CTOUT/FloAspectBar.git
git clone https://github.com/CTOUT/FloTotemBar.git
```

### Step 2: Install

1. Locate your World of Warcraft folder (usually `C:\Program Files (x86)\World of Warcraft\`)
2. Navigate to `Interface\AddOns\`
3. Extract both addon folders here
4. You should have:
   - `Interface\AddOns\FloAspectBar\`
   - `Interface\AddOns\FloTotemBar\`

### Step 3: Enable in Game

1. Launch World of Warcraft
2. At the character selection screen, click **AddOns** (bottom-left)
3. Make sure both addons are checked:
   - ☑ FloAspectBar
   - ☑ FloTotemBar
4. Click **Okay** and log in

### Step 4: Configure

**FloAspectBar (Hunters)**
1. The aspect bar will appear automatically
2. Type `/fab unlock` to move it
3. Drag to desired position
4. Type `/fab lock` to lock it
5. Right-click for more options

**FloTotemBar (Hunters - Traps)**
1. The trap bar will appear automatically
2. Type `/ftb unlock` to move it
3. Drag to desired position
4. Type `/ftb lock` to lock it
5. Right-click for more options

## What You'll See

### Hunters
- **FloAspectBar**: Shows all your aspects (Hawk, Cheetah, Pack, etc.)
- **FloBarTRAP**: Shows all your traps (Freezing, Explosive, Frost, Immolation)

### Shamans
- **FloBarEARTH**: Earth totems
- **FloBarFIRE**: Fire totems
- **FloBarWATER**: Water totems
- **FloBarAIR**: Air totems
- **FloBarCALL**: Call of elements

## Troubleshooting

### Addons Not Showing in List
- Make sure the folder names are exactly `FloAspectBar` and `FloTotemBar`
- Check that each folder contains a `.toc` file
- Try restarting WoW completely

### Bars Not Appearing
1. Make sure you're the right class (Hunter for aspects/traps, Shaman for totems)
2. Make sure you have at least one spell learned
3. Type `/reload` to reload UI
4. Type `/fab unlock` or `/ftb unlock` - bars might be off-screen

### Spells Not Detected
1. Make sure spells are in your spellbook (open with "P")
2. Try `/reload`
3. Run diagnostic: `/run FloBarDiagnostic()` to see what's detected

### Error Messages on Login
- Make sure you downloaded the **Project Ascension compatible version**
- The original versions won't work with Ascension's custom spell IDs
- Get the latest from GitHub: https://github.com/CTOUT/

## Commands Reference

### FloAspectBar (`/fab`)
| Command | Description |
|---------|-------------|
| `/fab` | Show help |
| `/fab lock` | Lock bar position |
| `/fab unlock` | Unlock to move |
| `/fab auto` | Auto position |
| `/fab scale 1.5` | Set scale (0.5-2.0) |
| `/fab borders` | Show borders |
| `/fab noborders` | Hide borders |
| `/fab reset` | Reset settings |

### FloTotemBar (`/ftb`)
| Command | Description |
|---------|-------------|
| `/ftb` | Show help |
| `/ftb lock` | Lock bar positions |
| `/ftb unlock` | Unlock to move |
| `/ftb auto` | Auto position |
| `/ftb scale 1.2` | Set scale (0.5-2.0) |
| `/ftb borders` | Show borders |
| `/ftb noborders` | Hide borders |
| `/ftb reset` | Reset settings |

## Advanced Configuration

### Hiding Specific Spells
1. Right-click the bar
2. Hover over "Spells"
3. Uncheck spells you want to hide

### Reordering Spells
1. Right-click the bar
2. Click "Unlock"
3. Drag spells to reorder
4. Click "Lock" when done

### Keybindings
1. Press `ESC` > Key Bindings
2. Scroll to "FloAspectBar" or "FloTotemBar"
3. Assign keys to each button

### Custom Positioning
- `/fab unlock` or `/ftb unlock` to enable dragging
- Hold and drag the bar
- `/fab lock` or `/ftb lock` to save position
- `/fab auto` for automatic anchoring to action bars

## Server-Specific Notes

### Project Ascension - Wildcard
- ✅ Fully supported
- All custom aspects and traps detected automatically

### Project Ascension - Classless
- ✅ Fully supported  
- Works even with mixed class abilities

### Project Ascension - Classic+
- ✅ Fully supported
- Compatible with Classic+ spell system

## Getting Help

### Community Support
- **Discord**: Join Project Ascension Discord
- **Forums**: Post in UI & Addons section
- **GitHub**: Open issue at https://github.com/CTOUT/

### Debug Mode
If you're having issues, run this command in-game:
```
/run FloBarDiagnostic()
```

This will show:
- What spells are detected
- Which bars are active
- Configuration status
- Any errors or warnings

Share this output when asking for help!

## Updating

### Manual Update
1. Download latest version from GitHub
2. Delete old addon folders
3. Extract new versions
4. Type `/reload` in game

### Git Update
```bash
cd "C:\Program Files (x86)\World of Warcraft\Interface\AddOns\FloAspectBar"
git pull

cd "C:\Program Files (x86)\World of Warcraft\Interface\AddOns\FloTotemBar"
git pull
```

## Uninstalling

1. Close World of Warcraft
2. Navigate to `Interface\AddOns\`
3. Delete `FloAspectBar` folder
4. Delete `FloTotemBar` folder
5. Restart WoW

Your settings will be removed automatically.

## Related Addons

Consider also installing:
- **FloFlyout** - Combine spells into flyout buttons (planned support)

## Credits

These addons are modified versions of the original FloAspectBar and FloTotemBar by Floraline, updated for Project Ascension compatibility by CTOUT.
