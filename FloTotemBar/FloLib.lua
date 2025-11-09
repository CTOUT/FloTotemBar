-- Some shared functions
-- Prevent multi-loading
if not FLOLIB_VERSION or FLOLIB_VERSION < 1.25 then

local NUM_SPELL_SLOTS = 10;
FLOLIB_VERSION = 1.25;

FLOLIB_ACTIVATE_SPEC_1 = GetSpellInfo(63645);
FLOLIB_ACTIVATE_SPEC_2 = GetSpellInfo(63644);

StaticPopupDialogs["FLOLIB_CONFIRM_RESET"] = {
	text = FLOLIB_CONFIRM_RESET,
	button1 = YES,
	button2 = NO,
	OnAccept = function(self, varName)
		setglobal(varName, nil);
		ReloadUI();
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
};

-- Reset addon
function FloLib_ResetAddon(addonName)

	local dialog = StaticPopup_Show("FLOLIB_CONFIRM_RESET", addonName);
	if dialog then
		dialog.data = string.upper(addonName.."_OPTIONS");
	end

end

-- Show borders on a frame
function FloLib_ShowBorders(self)

	self:SetBackdrop( { bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
	                    edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
	                    tile = true,
	                    tileSize = 16,
	                    edgeSize = 16,
	                    insets = { left = 5, right = 5, top = 5, bottom = 5 } });
	-- Cosmetic
	if self.settings and self.settings.color then
		local r, g, b, a = unpack(self.settings.color);
		self:SetBackdropBorderColor((r + 1.0)/2.0, (g + 1.0)/2.0, (b + 1.0)/2.0);
		self:SetBackdropColor(r, g, b, a);
	else
		self:SetBackdropBorderColor(0.5, 0.5, 0.5);
		self:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 0.7);
	end

end

-- Hide borders on a frame
function FloLib_HideBorders(self)

	self:SetBackdrop(nil);
end

-- Copy content of src into dst, preserve existing values, recursive
function FloLib_CopyPreserve(src, dst)

	for k, v in pairs(src) do
		if dst[k] == nil then
			if type(v) == "table" then
				dst[k] = {};
				FloLib_CopyPreserve(v, dst[k]);
			else
				dst[k] = v;
			end
		elseif type(v) == "table" and type(dst[k]) == "table" then
			FloLib_CopyPreserve(v, dst[k]);
		end
	end
end

-- Init an array of integers from 1 to n
function FloLib_Identity(n)

	local tmp = {};
	for i = 1, n do
		tmp[i] = i;
	end

	return tmp;
end


-- Swap 2 vals in an integer indexed array
function FloLib_Swap(tab, val1, val2)

	local idx1, idx2;
	
	for i = 1, #tab do
		if tab[i] == val1 then
			idx1 = i;
		end
		if tab[i] == val2 then
			idx2 = i;
		end
	end

	if not idx1 and idx2 then
		-- one of the value not found, do nothing
		return;
	end
	tab[idx2] = val1;
	tab[idx1] = val2;

end


-- Update the bindings
function FloLib_UpdateBindings(self, bindingPrefix)

	if InCombatLockdown() then
		return;
	end

	local key1, key2;
	local buttonPrefix = self:GetName().."Button";

	ClearOverrideBindings(self);

	for i = 1, 10 do
		key1, key2 = GetBindingKey(bindingPrefix.."BUTTON"..i);
		if key1 then
			SetOverrideBindingClick(self, true, key1, buttonPrefix..i);
		end
		if key2 then
			SetOverrideBindingClick(self, true, key2, buttonPrefix..i);
		end
	end
end

-- Common receive drag function
function FloLib_ReceiveDrag(self, releaseCursor)

	if InCombatLockdown() then
		return;
	end

	local cursorType, index, info;

	cursorType, index, info = GetCursorInfo();

	if cursorType ~= "spell" or info ~= BOOKTYPE_SPELL then
		return;
	end

	local button = self;
	local newspell = GetSpellName(index, info);
	self = self:GetParent();

	-- find the spell in the curent list
	for i = 1, #self.availableSpells do
		if self.availableSpells[i].name == newspell then
			if releaseCursor then
				ClearCursor();
			end
			FloLib_Swap(self.settings.buttonsOrder, self.settings.buttonsOrder[button:GetID()], i);
			FloLib_Setup(self);
			break;
		end
	end

end

-- Return the rank of a talent
function FloLib_GetTalentRank(talentName, tree)

	local nt = GetNumTalents(tree);
	local n, r, m;

	for i = 1, nt do
		n, _, _, _, r, m = GetTalentInfo(tree, i);
		if n == talentName then
			return r, m;
		end
	end
	return 0, 0;
end

-- Returns the ID of the last rank of a spell from the spellbook
function FloLib_GetSpellId(spell)

	local i = 1;
	local valid = -1;
	local validRank = nil;
	local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)
	while spellName do
		if spellName == spell then
			valid = i;
			validRank = spellRank;
		elseif valid > -1 then
			return valid, validRank;
		end
		i = i + 1;
		spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)
	end
	return valid, validRank;
end

-- Dynamically scan player's spellbook for aspects/auras/traps
-- This works with any spell IDs and client language (Project Ascension compatible)
-- Pass searchPattern to customize what to look for (default is aspects/auras)
function FloLib_ScanShapeshiftBar(searchPattern)
	local forms = {};
	searchPattern = searchPattern or "aspect|aura|stance|seal|presence";
	
	-- First, try the stance bar (works for retail WoW)
	local numForms = GetNumShapeshiftForms();
	if numForms > 0 then
		for i = 1, numForms do
			local icon, name, isActive, isCastable = GetShapeshiftFormInfo(i);
			if icon and name then
				table.insert(forms, {
					id = i * 10000, -- Use a high number to avoid conflicts
					name = name,
					texture = icon,
					shapeshiftSlot = i
				});
			end
		end
		return forms;
	end
	
	-- If stance bar is empty (Project Ascension/Hunters), scan spellbook for aspect-like spells
	-- Look for spells that match common patterns
	local spellIndex = 1;
	local spellName, spellRank = GetSpellName(spellIndex, BOOKTYPE_SPELL);
	local spellsByBaseName = {}; -- Track highest rank of each spell
	
	while spellName do
		local lowerName = string.lower(spellName);
		-- Check if spell name contains keywords based on search pattern
		local matches = false;
		for pattern in string.gmatch(searchPattern, "[^|]+") do
			if string.find(lowerName, pattern) then
				matches = true;
				break;
			end
		end
		
		if matches then
			
			-- Check if it's a passive spell (we want to exclude these)
			local isPassive = IsPassiveSpell(spellIndex, BOOKTYPE_SPELL);
			
			if not isPassive then
				-- Get spell texture - use the name and rank to get the texture
				local texture = GetSpellTexture(spellName, spellRank);
				
				-- Extract base spell name (without rank)
				local baseName = spellName;
				if spellRank and spellRank ~= "" then
					-- Remove rank from name if it's at the end
					baseName = string.gsub(spellName, "%s*Rank%s*%d+$", "");
					baseName = string.gsub(baseName, "%s*" .. spellRank .. "$", "");
				end
				
				-- Store or update if this is a higher rank
				if not spellsByBaseName[baseName] or 
				   (spellRank and spellRank > (spellsByBaseName[baseName].rank or "")) then
					spellsByBaseName[baseName] = {
						id = spellIndex,
						name = spellName,
						texture = texture,
						rank = spellRank,
						bookIndex = spellIndex,
						baseName = baseName
					};
				end
			end
		end
		
		spellIndex = spellIndex + 1;
		spellName, spellRank = GetSpellName(spellIndex, BOOKTYPE_SPELL);
	end
	
	-- Convert the table to an array (only highest ranks)
	for _, spell in pairs(spellsByBaseName) do
		table.insert(forms, spell);
	end
	
	-- Sort alphabetically by spell name
	table.sort(forms, function(a, b)
		return a.name < b.name;
	end);
	
	return forms;
end

-- Show/hide a spell
function FloLib_ToggleSpell(self, bar, idx)

	if bar.settings.hiddenSpells[idx] then
		bar.settings.hiddenSpells[idx] = nil;
	else
		bar.settings.hiddenSpells[idx] = 1;
	end

	FloLib_Setup(bar);
end

-- Setup the spell in a FloBar
function FloLib_Setup(self)

	-- Protection if no settings
	if not self.settings then
		return;
	end

	local numSpells = 0;
	local button;
	local isKnown, spell;
	local i = 1;
	local totemIdByName = nil;

	self.spells = {};
	
	-- Project Ascension: Dynamic spell discovery from stance/shapeshift bar
	if self.useDynamicDiscovery then
		-- Determine search pattern based on bar type
		local searchPattern = "aspect|aura|stance|seal|presence";
		if self.totemtype == "TRAP" then
			searchPattern = "trap";
		elseif self.totemtype == "EARTH" or self.totemtype == "FIRE" or 
		       self.totemtype == "WATER" or self.totemtype == "AIR" then
			searchPattern = "totem";
		end
		
		self.availableSpells = FloLib_ScanShapeshiftBar(searchPattern);
		if #self.availableSpells == 0 then
			-- No aspects/stances/traps found, hide the bar
			if not InCombatLockdown() then
				self:Hide();
			end
			return;
		end
	end

	-- Load totem ids
	if self.slot then
		local totemIds = {GetMultiCastTotemSpells(self.slot)};
		totemIdByName = {};
		for i, id in ipairs(totemIds) do
			totemIdByName[GetSpellInfo(id)] = id;
		end
	end

	-- Check already positionned spells
	while self.settings.buttonsOrder[i] do

		local n = self.settings.buttonsOrder[i];

		isKnown = false;
		if not self.settings.hiddenSpells[n] then
			spell = self.availableSpells[n];
			-- For dynamic discovery, spells are already known (from stance bar)
			if self.useDynamicDiscovery then
				isKnown = spell ~= nil;
			else
				isKnown = spell and IsSpellKnown(spell.id);
			end
		end

		if isKnown then
			if not spell.name then
				spell.name, _, spell.texture = GetSpellInfo(spell.id);
			end
			if totemIdByName then
				spell.refId = totemIdByName[spell.name];
			end
			self:SetupSpell(spell, i);
			i = i + 1;
		else
			-- this spell is unavailable, shift the remaining indexes by 1
			for j = i, #self.settings.buttonsOrder do
				self.settings.buttonsOrder[j] = self.settings.buttonsOrder[j+1];
			end
		end

	end

	numSpells = i - 1;

	for n = 1, #self.availableSpells do

		if n > NUM_SPELL_SLOTS then
			break;
		end

		spell = self.availableSpells[n];
		if not spell.name then
			spell.name, _, spell.texture = GetSpellInfo(spell.id);
		end
		if totemIdByName then
			spell.refId = totemIdByName[spell.name];
		end

		-- Check if this spell is already positionned
		local alreadyPositioned = false;
		for j = 1, #self.settings.buttonsOrder do
			if self.settings.buttonsOrder[j] == n then
				alreadyPositioned = true;
				break;
			end
		end

		if not alreadyPositioned then
			isKnown = false;
			if not self.settings.hiddenSpells[n] then
				-- For dynamic discovery, spells are already known (from stance bar)
				if self.useDynamicDiscovery then
					isKnown = true;
				else
					isKnown = IsSpellKnown(spell.id);
				end
			end
			if isKnown then

				numSpells = numSpells + 1;

				self:SetupSpell(spell, numSpells);
				self.settings.buttonsOrder[numSpells] = n;
			end
		end
	end

	-- Avoid tainting
	if not InCombatLockdown() then
		if numSpells > 0 then

			local timerOffset;
			if _G[self:GetName().."Countdown"] then
				timerOffset = 15;
			elseif _G[self:GetName().."Countdown3"] then
				timerOffset = 37;
			else
				timerOffset = 0;
			end
			self:Show();
			self:SetWidth(numSpells * 35 + 12 + timerOffset);

			for i=1, NUM_SPELL_SLOTS do

				button = _G[self:GetName().."Button"..i];

				if i <= numSpells then
					button:Show();
				else
					button:Hide();
				end
			end
		else
			self:Hide();
		end
	end

	if self.OnSetup then
		self:OnSetup();
	end
	FloLib_UpdateState(self);
end

-- Update the state of the buttons in a FloBar
function FloLib_UpdateState(self)

	local numSpells = #self.spells;
	local spell, cooldown, normalTexture, icon;
	local start, duration, enable, isUsable, noMana;

	for i=1, numSpells do

		if self.UpdateState then
			self:UpdateState(i);
		end

		spell = self.spells[i];

		--Cooldown stuffs
		cooldown = _G[self:GetName().."Button"..i.."Cooldown"];
		start, duration, enable = GetSpellCooldown(spell.name);
		CooldownFrame_SetTimer(cooldown, start, duration, enable);

		--Castable stuffs
		normalTexture = _G[self:GetName().."Button"..i.."NormalTexture"];
		icon = _G[self:GetName().."Button"..i.."Icon"];
		isUsable, noMana = IsUsableSpell(spell.name);

		if isUsable then
			icon:SetVertexColor(1.0, 1.0, 1.0);
			normalTexture:SetVertexColor(1.0, 1.0, 1.0);
		elseif noMana then
			icon:SetVertexColor(0.5, 0.5, 1.0);
			normalTexture:SetVertexColor(0.5, 0.5, 1.0);
		else
			icon:SetVertexColor(0.4, 0.4, 0.4);
			normalTexture:SetVertexColor(1.0, 1.0, 1.0);
		end

	end

end

function FloLib_Button_SetTooltip(self)
	if GetCVar("UberTooltips") == "1" then
		if self:GetParent().settings.position ~= "auto" then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			--GameTooltip_SetDefaultAnchor(GameTooltip, self);
		else
			GameTooltip:SetOwner(self, "ANCHOR_NONE");
			GameTooltip:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y + self:GetHeight());
			GameTooltip.default = 1;
		end
	else
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	end
	local spell = self:GetParent().spells[self:GetID()];
	if spell then
		--Display the tooltip
		local spellId, spellRank = FloLib_GetSpellId(spell.name)
		GameTooltip:SetSpell(spellId, BOOKTYPE_SPELL);
		GameTooltipTextRight1:SetText(spellRank);
		GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5);
		GameTooltipTextRight1:Show();
		GameTooltip:Show();
	end
end


-- Bar Dropdown
function FloLib_BarDropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, FloLib_BarDropDown_Initialize, "MENU");
	UIDropDownMenu_SetButtonWidth(self, 20);
	UIDropDownMenu_SetWidth(self, 20);
end

function FloLib_BarDropDown_Initialize(frame, level, menuList)

	local info;
	local bar = frame:GetParent();

	-- If level 3
	if UIDROPDOWNMENU_MENU_LEVEL == 3 then
		return;
	end

	-- If level 2
	if UIDROPDOWNMENU_MENU_LEVEL == 2 then

		-- If this is the position menu
		if UIDROPDOWNMENU_MENU_VALUE == "position" then

			-- Add the possible values to the menu
			for value, text in pairs(FLOLIB_POSITIONS) do
				info = UIDropDownMenu_CreateInfo();
				info.text = text;
				info.value = value;
				info.func = bar.menuHooks.SetPosition;
				info.arg1 = bar;
				info.arg2 = value;

				if value == bar.settings.position then
					info.checked = 1;
				end
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end

		-- If this is the layout menu
		elseif UIDROPDOWNMENU_MENU_VALUE == "layout" then

			-- Use the provided hook to populate the menu
			bar.menuHooks.SetLayoutMenu();

		-- If this is the spell menu
		elseif UIDROPDOWNMENU_MENU_VALUE == "spells" then

			-- Add the possible values to the menu
			for i, spell in ipairs(bar.availableSpells) do
				info = UIDropDownMenu_CreateInfo();
				info.text = spell.name;
				info.value = i;
				info.func = FloLib_ToggleSpell;
				info.arg1 = bar;
				info.arg2 = i;

				if not bar.settings.hiddenSpells[i] then
					info.checked = 1;
				end
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end

		end
		return;
	end

	-- Position menu
	if bar.menuHooks and bar.menuHooks.SetPosition then
		info = UIDropDownMenu_CreateInfo();
		info.text = FLOLIB_POSITION;
		info.value = "position";
		info.hasArrow = 1;
		info.func = nil;
		UIDropDownMenu_AddButton(info);
	end

	-- Layout menu
	if bar.menuHooks and bar.menuHooks.SetLayoutMenu then
		info = UIDropDownMenu_CreateInfo();
		info.text = FLOLIB_LAYOUT;
		info.value = "layout";
		info.hasArrow = 1;
		info.func = nil;
		UIDropDownMenu_AddButton(info);
	end

	-- Spells menu
	if bar.menuHooks then
		info = UIDropDownMenu_CreateInfo();
		info.text = SPELLS;
		info.value = "spells";
		info.hasArrow = 1;
		info.func = nil;
		UIDropDownMenu_AddButton(info);
	end

	-- Border options
	if bar.menuHooks and bar.menuHooks.SetBorders then
		info = UIDropDownMenu_CreateInfo();
		info.text = FLOLIB_SHOWBORDERS;
		info.func = bar.menuHooks.SetBorders;
		info.arg1 = not bar.globalSettings.borders;

		if bar.globalSettings.borders then
			info.checked = 1;
		end
		UIDropDownMenu_AddButton(info);
	end

	-- Background
	if bar.menuHooks then
		info = UIDropDownMenu_CreateInfo();
		info.text = BACKGROUND;
		info.hasColorSwatch = 1;
		info.r = bar.settings.color[1];
		info.g = bar.settings.color[2];
		info.b = bar.settings.color[3];
		-- Done because the slider is reversed
		info.opacity = 1.0 - bar.settings.color[4];
		info.swatchFunc = FloLib_BarDropDown_SetBackGroundColor;
		info.func = UIDropDownMenuButton_OpenColorPicker;
		info.hasOpacity = 1;
		info.opacityFunc = FloLib_BarDropDown_SetOpacity;
		info.cancelFunc = FloLib_BarDropDown_CancelColorSettings;
		UIDropDownMenu_AddButton(info);
	end

end

function FloLib_BarDropDown_SetBackGroundColor()
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local bar = UIDropDownMenu_GetCurrentDropDown():GetParent();

	bar.settings.color[1] = r;
	bar.settings.color[2] = g;
	bar.settings.color[3] = b;

	if bar.globalSettings.borders then
		FloLib_ShowBorders(bar)
	end
end

function FloLib_BarDropDown_SetOpacity()
	local a = 1.0 - OpacitySliderFrame:GetValue();
	local bar = UIDropDownMenu_GetCurrentDropDown():GetParent();

	bar.settings.color[4] = a;

	if bar.globalSettings.borders then
		FloLib_ShowBorders(bar)
	end
end

function FloLib_BarDropDown_CancelColorSettings(previous)
	local bar = UIDropDownMenu_GetCurrentDropDown():GetParent();

	bar.settings.color[1] = previous.r;
	bar.settings.color[2] = previous.g;
	bar.settings.color[3] = previous.b;
	bar.settings.color[4] = 1.0 - previous.opacity;

	if bar.globalSettings.borders then
		FloLib_ShowBorders(bar)
	end
end

function FloLib_BarDropDown_Show(self, button)

	-- If Rightclick bring up the options menu
	if button == "RightButton" then
		GameTooltip:Hide();
		self:StopMovingOrSizing();
		ToggleDropDownMenu(1, nil, _G[self:GetName().."DropDown"], self:GetName(), 0, 0);
		return;
	end

	-- Close all dropdowns
	CloseDropDownMenus();
end

end
