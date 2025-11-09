-- FloAspectBar/FloTotemBar Diagnostic Script
-- Type /run FloBarDiagnostic() in-game to run this

function FloBarDiagnostic()
    DEFAULT_CHAT_FRAME:AddMessage("=== FloBar Diagnostic ===", 1, 1, 0)
    
    -- Check class
    local className, classFileName = UnitClass("player")
    DEFAULT_CHAT_FRAME:AddMessage("Class: " .. className .. " (" .. classFileName .. ")", 0, 1, 1)
    
    -- Check stance/shapeshift bar (for aspects/forms)
    DEFAULT_CHAT_FRAME:AddMessage("--- Stance/Shapeshift Bar (Dynamic Discovery) ---", 1, 1, 0)
    local numForms = GetNumShapeshiftForms()
    DEFAULT_CHAT_FRAME:AddMessage("Number of Forms/Aspects: " .. numForms, 1, 1, 1)
    
    if numForms > 0 then
        for i = 1, numForms do
            local icon, name, isActive, isCastable = GetShapeshiftFormInfo(i)
            if name then
                local status = isActive and "[ACTIVE]" or "[INACTIVE]"
                local castable = isCastable and "Castable" or "Not Castable"
                DEFAULT_CHAT_FRAME:AddMessage("  Slot " .. i .. ": " .. name .. " " .. status .. " (" .. castable .. ")", 0, 1, 0)
            end
        end
    else
        DEFAULT_CHAT_FRAME:AddMessage("  No forms/aspects found in stance bar", 1, 0, 0)
    end
    
    -- Scan entire spellbook for "Aspect" spells
    DEFAULT_CHAT_FRAME:AddMessage("--- Spellbook Scan (Looking for Aspects/Auras) ---", 1, 1, 0)
    local foundAspects = {}
    local passiveCount = 0
    local i = 1
    local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)
    while spellName do
        -- Look for spells with "Aspect" or "Aura" in the name
        if string.find(string.lower(spellName), "aspect") or string.find(string.lower(spellName), "aura") then
            local isPassive = IsPassiveSpell(i, BOOKTYPE_SPELL)
            if isPassive then
                DEFAULT_CHAT_FRAME:AddMessage("  [PASSIVE - SKIPPED] [" .. i .. "] " .. spellName, 0.5, 0.5, 0.5)
                passiveCount = passiveCount + 1
            else
                table.insert(foundAspects, {index = i, name = spellName, rank = spellRank})
                DEFAULT_CHAT_FRAME:AddMessage("  Found: [" .. i .. "] " .. spellName .. " " .. (spellRank or ""), 0, 1, 0)
            end
        end
        i = i + 1
        spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)
    end
    if #foundAspects == 0 then
        DEFAULT_CHAT_FRAME:AddMessage("  No aspect/aura spells found in spellbook", 1, 0, 0)
    else
        DEFAULT_CHAT_FRAME:AddMessage("Total Aspects Found: " .. #foundAspects .. " (Filtered out " .. passiveCount .. " passive)", 0, 1, 0)
    end
    
    -- Scan for TRAP spells
    DEFAULT_CHAT_FRAME:AddMessage("--- Spellbook Scan (Looking for Traps) ---", 1, 1, 0)
    local foundTraps = {}
    i = 1
    spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)
    while spellName do
        if string.find(string.lower(spellName), "trap") then
            local isPassive = IsPassiveSpell(i, BOOKTYPE_SPELL)
            if not isPassive then
                table.insert(foundTraps, {index = i, name = spellName, rank = spellRank})
                DEFAULT_CHAT_FRAME:AddMessage("  Found: [" .. i .. "] " .. spellName .. " " .. (spellRank or ""), 0, 1, 0)
            end
        end
        i = i + 1
        spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)
    end
    DEFAULT_CHAT_FRAME:AddMessage("Total Traps Found: " .. #foundTraps, 0, 1, 0)
    
    -- Check if hardcoded Hunter aspects are known (old method)
    DEFAULT_CHAT_FRAME:AddMessage("--- Hardcoded Spell IDs (Old Method) ---", 1, 1, 0)
    local aspectSpells = {
        {id = 13163, name = "Aspect of the Monkey"},
        {id = 13165, name = "Aspect of the Hawk"},
        {id = 5118, name = "Aspect of the Cheetah"},
        {id = 13159, name = "Aspect of the Pack"},
        {id = 13161, name = "Aspect of the Beast"},
        {id = 20043, name = "Aspect of the Wild"},
        {id = 34074, name = "Aspect of the Viper"},
        {id = 61846, name = "Aspect of the Dragonhawk"}
    }
    
    local knownCount = 0
    for _, spell in ipairs(aspectSpells) do
        local spellName = GetSpellInfo(spell.id)
        local isKnown = IsSpellKnown(spell.id)
        if isKnown then
            DEFAULT_CHAT_FRAME:AddMessage("  [KNOWN] " .. spell.id .. ": " .. (spellName or "Unknown"), 0, 1, 0)
            knownCount = knownCount + 1
        else
            DEFAULT_CHAT_FRAME:AddMessage("  [NOT KNOWN] " .. spell.id .. ": " .. (spellName or "Unknown"), 0.5, 0.5, 0.5)
        end
    end
    DEFAULT_CHAT_FRAME:AddMessage("Total Known (Hardcoded): " .. knownCount, 1, 1, 0)
    
    -- Test the scanning function directly
    DEFAULT_CHAT_FRAME:AddMessage("--- Testing FloLib_ScanShapeshiftBar() ---", 1, 1, 0)
    if FloLib_ScanShapeshiftBar then
        local scannedForms = FloLib_ScanShapeshiftBar()
        DEFAULT_CHAT_FRAME:AddMessage("Scanned forms count: " .. #scannedForms, 1, 1, 1)
        for i, form in ipairs(scannedForms) do
            DEFAULT_CHAT_FRAME:AddMessage("  [" .. i .. "] " .. form.name .. " (ID: " .. form.id .. ", BookIndex: " .. (form.bookIndex or "nil") .. ")", 0, 1, 0)
        end
    else
        DEFAULT_CHAT_FRAME:AddMessage("FloLib_ScanShapeshiftBar function NOT FOUND", 1, 0, 0)
    end
    
    -- Check if FloAspectBar frame exists
    DEFAULT_CHAT_FRAME:AddMessage("--- FloAspectBar Frame Status ---", 1, 1, 0)
    if FloAspectBar then
        DEFAULT_CHAT_FRAME:AddMessage("FloAspectBar frame: EXISTS", 0, 1, 0)
        DEFAULT_CHAT_FRAME:AddMessage("  Is Shown: " .. tostring(FloAspectBar:IsShown()), 1, 1, 1)
        DEFAULT_CHAT_FRAME:AddMessage("  useDynamicDiscovery: " .. tostring(FloAspectBar.useDynamicDiscovery), 1, 1, 1)
        if FloAspectBar.availableSpells then
            DEFAULT_CHAT_FRAME:AddMessage("  availableSpells count: " .. #FloAspectBar.availableSpells, 1, 1, 1)
        end
        if FloAspectBar.spells then
            DEFAULT_CHAT_FRAME:AddMessage("  Configured spells: " .. #FloAspectBar.spells, 1, 1, 1)
        end
    else
        DEFAULT_CHAT_FRAME:AddMessage("FloAspectBar frame: NOT FOUND", 1, 0, 0)
    end
    
    -- Check FloBarTRAP specifically
    DEFAULT_CHAT_FRAME:AddMessage("--- FloBarTRAP Detailed Status ---", 1, 1, 0)
    if FloBarTRAP then
        DEFAULT_CHAT_FRAME:AddMessage("FloBarTRAP frame: EXISTS", 0, 1, 0)
        DEFAULT_CHAT_FRAME:AddMessage("  Is Shown: " .. tostring(FloBarTRAP:IsShown()), 1, 1, 1)
        DEFAULT_CHAT_FRAME:AddMessage("  useDynamicDiscovery: " .. tostring(FloBarTRAP.useDynamicDiscovery), 1, 1, 1)
        DEFAULT_CHAT_FRAME:AddMessage("  totemtype: " .. tostring(FloBarTRAP.totemtype), 1, 1, 1)
        if FloBarTRAP.availableSpells then
            DEFAULT_CHAT_FRAME:AddMessage("  availableSpells count: " .. #FloBarTRAP.availableSpells, 1, 1, 1)
        else
            DEFAULT_CHAT_FRAME:AddMessage("  availableSpells: NIL", 1, 0, 0)
        end
        if FloBarTRAP.spells then
            DEFAULT_CHAT_FRAME:AddMessage("  Configured spells: " .. #FloBarTRAP.spells, 1, 1, 1)
        end
        
        -- Test the scan function for traps
        if FloLib_ScanShapeshiftBar then
            local trapSpells = FloLib_ScanShapeshiftBar("trap")
            DEFAULT_CHAT_FRAME:AddMessage("  Scan for traps returned: " .. #trapSpells .. " spells", 1, 1, 1)
            for i, spell in ipairs(trapSpells) do
                DEFAULT_CHAT_FRAME:AddMessage("    [" .. i .. "] " .. spell.name, 0, 1, 0)
            end
        end
    else
        DEFAULT_CHAT_FRAME:AddMessage("FloBarTRAP frame: NOT FOUND", 1, 0, 0)
    end
    
    -- Check if totem bars exist
    DEFAULT_CHAT_FRAME:AddMessage("--- Totem Bars ---", 1, 1, 0)
    local totemBars = {"FloBarEARTH", "FloBarFIRE", "FloBarWATER", "FloBarAIR", "FloBarTRAP", "FloBarCALL"}
    for _, barName in ipairs(totemBars) do
        local bar = _G[barName]
        if bar then
            DEFAULT_CHAT_FRAME:AddMessage("  " .. barName .. ": EXISTS, Shown=" .. tostring(bar:IsShown()), 0, 1, 0)
            if bar.spells then
                DEFAULT_CHAT_FRAME:AddMessage("    Num Spells: " .. #bar.spells, 1, 1, 1)
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage("  " .. barName .. ": NOT FOUND", 0.5, 0.5, 0.5)
        end
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("=== End Diagnostic ===", 1, 1, 0)
end

-- Auto-run diagnostic on load
DEFAULT_CHAT_FRAME:AddMessage("FloBar Diagnostic loaded. Type: /run FloBarDiagnostic()", 1, 1, 0)
