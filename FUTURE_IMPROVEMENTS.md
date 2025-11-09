# Future Improvements & Roadmap

## Short Term (High Priority)

### 1. FloFlyout Integration
**Goal**: Combine multiple spell ranks/variations into single flyout buttons

**Use Cases**:
- Combine trap ranks into one button with flyout menu
- Group similar aspects (movement: Cheetah + Pack)
- Custom spell combinations for Project Ascension builds

**Implementation**:
- [ ] Research FloFlyout API
- [ ] Check if Ascension's native spell combination can be hooked
- [ ] If not, implement custom flyout system
- [ ] Add configuration UI for creating custom flyouts
- [ ] Test with trap ranks (Freezing Trap Rank 1/2)

**Priority**: HIGH - Reduces button clutter significantly

---

### 2. Shaman Dynamic Discovery
**Goal**: Apply same dynamic spell detection to Shaman totems

**Current State**: Shamans still use hardcoded spell IDs  
**Target**: Scan spellbook for totem spells dynamically

**Implementation**:
- [ ] Test current totem detection on Project Ascension Shaman
- [ ] Implement search patterns for each element:
  - `"earth.*totem"` for Earth totems
  - `"fire.*totem"` for Fire totems
  - `"water.*totem"` for Water totems
  - `"air.*totem"` for Air totems
- [ ] Add element detection logic
- [ ] Test with Ascension's custom totem spells
- [ ] Verify totem timers still work correctly

**Priority**: MEDIUM - Shamans less common on Ascension

---

### 3. Performance Optimization
**Goal**: Reduce addon overhead and improve responsiveness

**Areas**:
- [ ] Cache spell scan results (only rescan on LEARNED_SPELL_IN_TAB)
- [ ] Throttle UpdateState calls (currently every frame)
- [ ] Optimize string matching in spell scanner
- [ ] Profile with /framestack to identify bottlenecks

**Priority**: MEDIUM - Current performance is acceptable

---

## Medium Term (Nice to Have)

### 4. Multi-Class Support
**Goal**: Extend dynamic discovery to other classes

**Classes to Support**:
- [ ] **Death Knight** - Presences (Blood, Frost, Unholy)
- [ ] **Paladin** - Auras/Seals (might need FloAspectBar fork)
- [ ] **Warrior** - Stances (actually has stance bar, may not need)
- [ ] **Rogue** - Stealth/detection abilities
- [ ] **Druid** - Forms (already has stance bar)

**Implementation**:
- [ ] Create class detection logic
- [ ] Define search patterns per class
- [ ] Test on each class in Ascension
- [ ] Update documentation

**Priority**: LOW - Hunters are primary use case

---

### 5. Enhanced Configuration UI
**Goal**: In-game configuration panel instead of slash commands

**Features**:
- [ ] Drag-and-drop spell reordering
- [ ] Color picker for bar backgrounds
- [ ] Size/scale sliders
- [ ] Position presets (top-center, bottom-right, etc.)
- [ ] Profile system (save/load configurations)
- [ ] Import/export settings

**Implementation**:
- [ ] Use Ace3 GUI library or custom frames
- [ ] Create tabbed interface
- [ ] Add real-time preview
- [ ] Save per-character or account-wide

**Priority**: LOW - Slash commands work fine

---

## Long Term (Major Features)

### 6. Spell Combination System
**Goal**: Built-in spell macro/combination creator

**Vision**: 
- Create custom spell sequences
- Conditional casting (if this, then that)
- Integration with Ascension's ability combos
- Visual scripting interface

**Complexity**: HIGH - Essentially a mini-addon framework

**Priority**: LOW - FloFlyout may cover this

---

### 7. Weakauras Integration
**Goal**: Export bars as Weakauras for advanced users

**Features**:
- [ ] Generate WA string from current bar config
- [ ] Import WA tracking triggers
- [ ] Sync with WA cooldown groups
- [ ] Share bar configurations as WA exports

**Priority**: LOW - Different use case than Flo addons

---

### 8. Mobile Companion App
**Goal**: Configure bars outside of game

**Features**:
- Web-based configuration tool
- Save configurations to cloud
- Share builds with community
- Import from Armory/Ascension API

**Priority**: VERY LOW - Fun project but not essential

---

## Bug Fixes & Maintenance

### Known Issues
- [ ] Bar sometimes doesn't update immediately on learning new spell (requires /reload)
- [ ] Rare LUA error when casting aspect while bar is hidden
- [ ] Tooltip positioning wrong when bar is at screen edge
- [ ] Keybindings don't save on first attempt sometimes

### Code Quality
- [ ] Add comprehensive LUA documentation
- [ ] Create unit tests for spell scanning
- [ ] Refactor FloLib.lua (currently 700+ lines)
- [ ] Standardize naming conventions
- [ ] Remove duplicate code between addons

### Compatibility Testing
- [ ] Test on fresh Ascension account
- [ ] Test with other popular addons (Bartender, Dominos, etc.)
- [ ] Test on different screen resolutions
- [ ] Test with UI scaling enabled
- [ ] Multi-language client testing

---

## Community Requests

### Feature Requests (GitHub Issues)
Track community suggestions here as they come in.

**Format**:
- Issue #XX: Feature name
  - Description
  - Votes/Priority
  - Implementation notes

---

## FloFlyout Specific Improvements

### Research Phase
- [ ] Analyze FloFlyout source code
- [ ] Document API endpoints
- [ ] Identify integration points with FloAspectBar/FloTotemBar
- [ ] Test current FloFlyout on Project Ascension

### Integration Goals
1. **Automatic Flyout Creation**
   - Detect spell ranks automatically
   - Create flyout for any spell with 2+ ranks
   - Allow manual grouping of unrelated spells

2. **Custom Flyout Menus**
   - User-defined spell groups
   - Icon selection
   - Hotkey assignment
   - Conditional visibility

3. **Ascension-Specific Features**
   - Hook into Ascension's ability combination system
   - Detect and suggest compatible spell combos
   - Auto-create flyouts for talent trees

### Technical Considerations
- **Secure Actions**: Flyouts need to work in combat
- **Frame Management**: Prevent taint issues
- **Memory Usage**: Don't create excessive frames
- **Performance**: Flyout should open instantly

---

## Documentation Improvements

### User Documentation
- [ ] Video tutorial for installation
- [ ] GIF demos of key features
- [ ] FAQ section with common issues
- [ ] Keybinding guide with pictures
- [ ] Best practices for bar positioning

### Developer Documentation
- [ ] API reference for FloLib functions
- [ ] Architecture overview diagram
- [ ] Contributing guidelines
- [ ] Code style guide
- [ ] How to add new spell patterns

---

## Testing & QA

### Test Matrix
Create comprehensive test suite covering:

**Environments**:
- [ ] Project Ascension - Wildcard
- [ ] Project Ascension - Classless
- [ ] Project Ascension - Classic+
- [ ] Retail WoW 3.3.5 (if accessible)

**Classes**:
- [ ] Hunter (primary)
- [ ] Shaman (secondary)
- [ ] Other classes (if expanded)

**Scenarios**:
- [ ] Fresh character (no spells)
- [ ] Learning new spell
- [ ] Leveling up (spell rank increase)
- [ ] Talent reset
- [ ] Dual spec switching
- [ ] Combat casting
- [ ] Mounted
- [ ] In dungeon/raid
- [ ] PvP arena/BG

### Automated Testing
- [ ] Set up LUA unit testing framework
- [ ] Create test spellbook data
- [ ] Mock WoW API calls
- [ ] CI/CD pipeline for releases

---

## Release Management

### Versioning Strategy
Use Semantic Versioning: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes (e.g., complete rewrite)
- **MINOR**: New features (e.g., FloFlyout integration)
- **PATCH**: Bug fixes (e.g., spell detection fix)

### Release Checklist
- [ ] Update version in .toc files
- [ ] Update CHANGELOG.md
- [ ] Test on clean install
- [ ] Create GitHub release
- [ ] Tag with version number
- [ ] Update README with new features
- [ ] Post announcement on Discord/Forums

---

## Community & Promotion

### Content Creation
- [ ] Create YouTube tutorial
- [ ] Stream configuration session
- [ ] Write guide on Ascension forums
- [ ] Reddit post on /r/projectascension

### Collaboration
- [ ] Reach out to other addon developers
- [ ] Coordinate with Ascension mod team
- [ ] Contribute fixes back to original Floraline addons
- [ ] Join Ascension addon developer Discord

---

## Notes

**Priority Levels**:
- **HIGH**: Should be done soon (1-2 weeks)
- **MEDIUM**: Nice to have (1-2 months)
- **LOW**: Future consideration (3+ months)
- **VERY LOW**: Dream features

**Effort Estimates**:
- **Small**: 1-4 hours
- **Medium**: 1-2 days
- **Large**: 1-2 weeks
- **X-Large**: Multiple weeks/months

---

*Last Updated: 2025-11-09*  
*Maintainer: CTOUT*  
*Repository: https://github.com/CTOUT/FloAspectBar & https://github.com/CTOUT/FloTotemBar*
