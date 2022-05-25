local KYA, E, L, V, P, G = unpack(select(2, ...));
local UF = KYA:GetModule('UnitFrames')
local ElvUI_UF = E:GetModule('UnitFrames')
local ACH = E.Libs.ACH
local gsub = gsub
local wipe = wipe
local next = next
local pairs = pairs
local format = format
local strmatch = strmatch
local tonumber = tonumber
local tostring = tostring
local GetSpellInfo = GetSpellInfo

-- GLOBALS: MAX_PLAYER_LEVEL

local quickSearchText, selectedStyle, selectedSpell, selectedFilter, selectedColorCount, selectedColoringBasedOnType, selectedNumberOfThresholds, filterList, spellList = '', nil, nil, nil, nil, nil, nil, {}, {}
local defaultFilterList = {	['Aura Indicator (Global)'] = 'Aura Indicator (Global)', ['Aura Indicator (Class)'] = 'Aura Indicator (Class)', ['Aura Indicator (Pet)'] = 'Aura Indicator (Pet)',  ['Aura Indicator (Profile)'] = 'Aura Indicator (Profile)', ['AuraBar Colors'] = 'AuraBar Colors', ['Aura Highlight'] = 'Aura Highlight' }
local auraBarDefaults = { enable = true, color = { r = 1, g = 1, b = 1 } }

local settingsChanged = false;

local filterTypes = {
    class = 'Aura Indicator (Class)',
    pet = 'Aura Indicator (Pet)',
    profile = 'Aura Indicator (Profile)',
}
local styleList = {        
    timerOnly = L["Timer Only"],
    coloredIcon = L["Colored Icon"],
    colorStaticIcon = L["Colored Static Icon"],
    texturedIcon = L["Textured Icon"],
    coloredWatchIcon = L["Colored Watch Icon"],
}
local colorCountList = {
    [1] = '1', 
    [2] = '2', 
    [3] = '3', 
    [4] = '4', 
    [5] = '5', 
    [6] = '6', 
    [7] = '7', 
    [8] = '8', 
    [9] = '9',  
}
local coloringBasedOnTypeList = {
    numberOfStacks = L["Number of stacks"],
    remainingTime = L["Remaining time"],
    elapsedTime = L["Elapsed time"],
}

local function GetSelectedFilters()
	local class = UF.Filters.selectedFilter == filterTypes.class
	local pet = UF.Filters.selectedFilter == filterTypes.pet
	local profile = UF.Filters.selectedFilter == filterTypes.profile
	local selected = (profile and E.db.unitframe.filters.aurawatch) or (pet and (E.global.unitframe.aurawatch.PET or {})) or class and (E.global.unitframe.aurawatch[E.myclass] or {}) or E.global.unitframe.aurawatch.GLOBAL
	local default = (profile and P.unitframe.filters.aurawatch) or (pet and G.unitframe.aurawatch.PET) or class and G.unitframe.aurawatch[E.myclass] or G.unitframe.aurawatch.GLOBAL
	return selected, default
end

local function GetSelectedFiltersLocal()
	local class = selectedFilter == filterTypes.class
	local pet = selectedFilter == filterTypes.pet
	local profile = selectedFilter == filterTypes.profile
	local selected = (profile and E.db.unitframe.filters.aurawatch) or (pet and (E.global.unitframe.aurawatch.PET or {})) or class and (E.global.unitframe.aurawatch[E.myclass] or {}) or E.global.unitframe.aurawatch.GLOBAL
	local default = (profile and P.unitframe.filters.aurawatch) or (pet and G.unitframe.aurawatch.PET) or class and G.unitframe.aurawatch[E.myclass] or G.unitframe.aurawatch.GLOBAL
	return selected, default
end

local function GetSelectedColorCountLocal()
	if selectedColorCount and selectedColorCount ~= '' then
		local colorCount = strmatch(selectedColorCount, ' %((%d+)%)$') or selectedColorCount
		if colorCount then
			return tonumber(colorCount) or colorCount
		end
	end
end
local function GetSelectedSpell()
    if UF.Filters.selectedSpell and UF.Filters.selectedSpell ~= '' then
		local spell = strmatch(UF.Filters.selectedSpell, ' %((%d+)%)$') or UF.Filters.selectedSpell
		if spell then
			return tonumber(spell) or spell
		end
	end
end

local function GetSelectedSpellLocal()
	if selectedSpell and selectedSpell ~= '' then
		local spell = strmatch(selectedSpell, ' %((%d+)%)$') or selectedSpell
		if spell then
			return tonumber(spell) or spell
		end
	end
end

local function GetSelectedStyle()
	if UF.Filters.selectedStyle and UF.Filters.selectedStyle ~= '' then
		local style = UF.Filters.selectedStyle
		if style then
			return tostring(style) or style
		end
	end
end

local function GetSelectedStyleLocal()
	if selectedStyle and selectedStyle ~= '' then
		local style = selectedStyle
		if style then
			return tostring(style) or style
		end
	end
end

local function filterMatch(s,v)
	local m1, m2, m3, m4 = '^'..v..'$', '^'..v..',', ','..v..'$', ','..v..','
	return (strmatch(s, m1) and m1) or (strmatch(s, m2) and m2) or (strmatch(s, m3) and m3) or (strmatch(s, m4) and v..',')
end

local function removePriority(value)
	if not value then return end
	local x,y,z=E.db.unitframe.units,E.db.nameplates.units;
	for n, t in pairs(x) do
		if t and t.buffs and t.buffs.priority and t.buffs.priority ~= '' then
			z = filterMatch(t.buffs.priority, E:EscapeString(value))
			if z then E.db.unitframe.units[n].buffs.priority = gsub(t.buffs.priority, z, '') end
		end
		if t and t.debuffs and t.debuffs.priority and t.debuffs.priority ~= '' then
			z = filterMatch(t.debuffs.priority, E:EscapeString(value))
			if z then E.db.unitframe.units[n].debuffs.priority = gsub(t.debuffs.priority, z, '') end
		end
		if t and t.aurabar and t.aurabar.priority and t.aurabar.priority ~= '' then
			z = filterMatch(t.aurabar.priority, E:EscapeString(value))
			if z then E.db.unitframe.units[n].aurabar.priority = gsub(t.aurabar.priority, z, '') end
		end
	end
	for n, t in pairs(y) do
		if t and t.buffs and t.buffs.priority and t.buffs.priority ~= '' then
			z = filterMatch(t.buffs.priority, E:EscapeString(value))
			if z then E.db.nameplates.units[n].buffs.priority = gsub(t.buffs.priority, z, '') end
		end
		if t and t.debuffs and t.debuffs.priority and t.debuffs.priority ~= '' then
			z = filterMatch(t.debuffs.priority, E:EscapeString(value))
			if z then E.db.nameplates.units[n].debuffs.priority = gsub(t.debuffs.priority, z, '') end
		end
	end
end

local function SetFilterList()
	wipe(UF.Filters.filterList)
	E:CopyTable(UF.Filters.filterList, defaultFilterList)

	local list = E.global.unitframe.aurafilters
	if list then
		for filter in pairs(list) do
			UF.Filters.filterList[filter] = filter
		end
	end

	return UF.Filters.filterList
end

local function SetFilterListLocal()
	wipe(filterList)
	E:CopyTable(filterList, defaultFilterList)

	local list = E.global.unitframe.aurafilters
	if list then
		for filter in pairs(list) do
			filterList[filter] = filter
		end
	end

	return filterList
end

local function ResetFilterList()
	wipe(UF.Filters.filterList)

	E:CopyTable(UF.Filters.filterList, defaultFilterList)

	local list = G.unitframe.aurafilters
	if list then
		for filter in pairs(list) do
			UF.Filters.filterList[filter] = filter
		end
	end

	return UF.Filters.filterList
end

local function ResetFilterListLocal()
	wipe(filterList)

	E:CopyTable(defaultFilterList)

	local list = G.unitframe.aurafilters
	if list then
		for filter in pairs(list) do
			filterList[filter] = filter
		end
	end

	return filterList
end

local function DeleteFilterList()
	wipe(UF.Filters.filterList)

	local list = E.global.unitframe.aurafilters
	local defaultList = G.unitframe.aurafilters
	if list then
		for filter in pairs(list) do
			if not defaultList[filter] then
				UF.Filters.filterList[filter] = filter
			end
		end
	end

	return UF.Filters.filterList
end

local function DeleteFilterListLocal()
	wipe(filterList)

	local list = E.global.unitframe.aurafilters
	local defaultList = G.unitframe.aurafilters
	if list then
		for filter in pairs(list) do
			if not defaultList[filter] then
				filterList[filter] = filter
			end
		end
	end

	return filterList
end

local function SetSpellList()
	local list
	if UF.Filters.selectedFilter == 'Aura Highlight' then
		list = E.global.unitframe.AuraHighlightColors
	elseif UF.Filters.selectedFilter == 'AuraBar Colors' then
		list = E.global.unitframe.AuraBarColors
	elseif UF.Filters.selectedFilter == 'Aura Indicator (Pet)' or UF.Filters.selectedFilter == 'Aura Indicator (Profile)' or UF.Filters.selectedFilter == 'Aura Indicator (Class)' or UF.Filters.selectedFilter == 'Aura Indicator (Global)' then
		list = GetSelectedFilters()
	else
		list = E.global.unitframe.aurafilters[UF.Filters.selectedFilter].spells
        
	end

	if not list then return end
	wipe(UF.Filters.spellList)

	local searchText = UF.Filters.quickSearchText:lower()
	for filter, spell in pairs(list) do
		if spell.id and (UF.Filters.selectedFilter == 'Aura Indicator (Pet)' or UF.Filters.selectedFilter == 'Aura Indicator (Profile)' or UF.Filters.selectedFilter == 'Aura Indicator (Class)' or UF.Filters.selectedFilter == 'Aura Indicator (Global)') then
			filter = spell.id
		end

		local spellName = tonumber(filter) and GetSpellInfo(filter)
		local name = (spellName and format('%s |cFF888888(%s)|r', spellName, filter)) or tostring(filter)

		if name:lower():find(searchText) then
			UF.Filters.spellList[filter] = name
		end
	end

	if not next(UF.Filters.spellList) then
		UF.Filters.spellList[''] = L["NONE"]
	end

	return UF.Filters.spellList
end

local function SetSpellListLocal()
	local list
	if selectedFilter == 'Aura Highlight' then
		list = E.global.unitframe.AuraHighlightColors
	elseif selectedFilter == 'AuraBar Colors' then
		list = E.global.unitframe.AuraBarColors
	elseif selectedFilter == 'Aura Indicator (Pet)' or selectedFilter == 'Aura Indicator (Profile)' or selectedFilter == 'Aura Indicator (Class)' or selectedFilter == 'Aura Indicator (Global)' then
		list = GetSelectedFiltersLocal()
	else
		list = E.global.unitframe.aurafilters[selectedFilter].spells
	end

	if not list then return end
	wipe(spellList)

	local searchText = quickSearchText:lower()
	for filter, spell in pairs(list) do
		if spell.id and (selectedFilter == 'Aura Indicator (Pet)' or selectedFilter == 'Aura Indicator (Profile)' or selectedFilter == 'Aura Indicator (Class)' or selectedFilter == 'Aura Indicator (Global)') then
			filter = spell.id
		end

		local spellName = tonumber(filter) and GetSpellInfo(filter)
		local name = (spellName and format('%s |cFF888888(%s)|r', spellName, filter)) or tostring(filter)

		if name:lower():find(searchText) then
			spellList[filter] = name
		end
	end

	if not next(spellList) then
		spellList[''] = L["NONE"]
	end

	return spellList
end

local function AddFilterOptions()

    E.Options.args.kyaui.args.filterExtension = {
		order = 5,
		type = "group",
		name = L["Filter Extension"],
        childGroups = "tab",
		args = {
			filterExtensionHeader = {
				order = 1,
				type = "header",
				name = KYA:cOption(L["Filter Extension"]),
			},
			filterExtensionToggle = {
				order = 2,
				type = "toggle",
				name = L["Enable"],
                desc = L["Filter Extension Desc"],    
                get = function(info)
                    return UF.db.filterExtension.enabled
                end,
                set = function(info, value)
                    UF.db.filterExtension.enabled = value
                    ElvUI_UF:Update_AllFrames()
                end,                    
            },
            selectFilterGroup = {
                order = 4,
                type = "group",
                name = L["Select filter"],
                disabled = function(info) 
                    if  UF.db.filterExtension.enabled then
                        return false
                    end
                    return true
                end,
                args = {  
                    selectFilter = {
                        order = 1,
                        type = 'select',
                        name = L["Select Filter"],
                        get = function(info) return selectedFilter end,
                        set = function(info, value)
                            selectedFilter, selectedSpell, quickSearchText = nil, nil, ''
                            if value ~= '' then
                                selectedFilter = value
                            end
                        end,
                        values = SetFilterListLocal,
                    },
                    selectSpell = {
                        name = function() return selectedFilter end,
                        hidden = function() return not selectedFilter end,
                        --name = L["Select Spell"],
                        type = 'select',
                        order = 2,
                        customWidth = 350,
                        get = function(info) return selectedSpell or '' end,
                        set = function(info, value)
                            selectedSpell = (value ~= '' and value) or nil
                        end,
                        values = SetSpellListLocal,
                    },
                             
                    selectedFilterHeader = {
                        order = 3,
                        type = "header",
                        name = function()
                            if selectedFilter then
                                if selectedSpell then
                                    local spellName = select(1,GetSpellInfo(selectedSpell));
                                    local spellIcon = select(3,GetSpellInfo(selectedSpell));

                                    return string.format(L["Selected filter: %s - Selected spell: %s (%s)"], selectedFilter, spellName, selectedSpell)
                                end
                                return string.format(L["Selected filter: %s - No spell selected"], selectedFilter)
                            end
                            return L["No filter selected"]
                        end,                  
                    },
                    auraIndicator = {
                        type = 'group',
                        name = function()
                            local spell = GetSelectedSpellLocal()
                            local spellName = spell and GetSpellInfo(spell)
                            return (spellName and spellName..' |cFF888888('..spell..')|r') or spell or ' '
                        end,
                        hidden = function() return not selectedSpell or 
                            (selectedFilter ~= 'Aura Indicator (Pet)' and 
                            selectedFilter ~= 'Aura Indicator (Profile)' and 
                            selectedFilter ~= 'Aura Indicator (Class)' and 
                            selectedFilter ~= 'Aura Indicator (Global)') end,
                        get = function(info)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
    
                            local selectedTable = GetSelectedFiltersLocal()
                            return selectedTable[spell][info[#info]]
                        end,
                        set = function(info, value)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
    
                            local selectedTable = GetSelectedFiltersLocal()
                            selectedTable[spell][info[#info]] = value
                            ElvUI_UF:Update_AllFrames()
                        end,
                        order = -10,
                        inline = true,
                        args = {
                            enabled = {
                                name = L["Enable"],
                                order = 1,
                                type = 'toggle',
                            },
                            point = {
                                name = L["Anchor Point"],
                                order = 2,
                                type = 'select',
                                values = {
                                    TOPLEFT = 'TOPLEFT',
                                    LEFT = 'LEFT',
                                    BOTTOMLEFT = 'BOTTOMLEFT',
                                    RIGHT = 'RIGHT',
                                    TOPRIGHT = 'TOPRIGHT',
                                    BOTTOMRIGHT = 'BOTTOMRIGHT',
                                    CENTER = 'CENTER',
                                    TOP = 'TOP',
                                    BOTTOM = 'BOTTOM',
                                }
                            },
                            style = {
                                name = L["Style"],
                                order = 3,
                                type = 'select',
                                values = styleList,
                                get = function(info) 
                                    local spell = GetSelectedSpellLocal()
                                    if not spell then return end
            
                                    local selectedTable = GetSelectedFiltersLocal()
                                    return selectedTable[spell][info[#info]]
                                end,
                                set = function(info, value)
                                    local spell = GetSelectedSpellLocal()
                                    if not spell then return end
                                    
                                    local selectedTable = GetSelectedFiltersLocal()
                                    selectedTable[spell][info[#info]] = value
                                end,
                            },
                            color = {
                                name = L["COLOR"],
                                type = 'color',
                                order = 4,
                                get = function(info)
                                    local spell = GetSelectedSpellLocal()
                                    if not spell then return end
                                    local selectedTable = GetSelectedFiltersLocal()
                                    local t = selectedTable[spell][info[#info]]
                                    return t.r, t.g, t.b, t.a
                                end,
                                set = function(info, r, g, b)
                                    local spell = GetSelectedSpellLocal()
                                    if not spell then return end
                                    local selectedTable = GetSelectedFiltersLocal()
                                    local t = selectedTable[spell][info[#info]]
                                    t.r, t.g, t.b = r, g, b
    
                                    --ElvUI_UF:Update_AllFrames()
                                end,
                                disabled = function()
                                    local spell = GetSelectedSpellLocal()
                                    if not spell then return end
                                    local selectedTable = GetSelectedFiltersLocal()
                                    return selectedTable[spell].style == 'texturedIcon'
                                end,
                            },
                            sizeOffset = {
                                order = 5,
                                type = 'range',
                                name = L["Size Offset"],
                                desc = L["This changes the size of the Aura Icon by this value."],
                                min = -25, max = 25, step = 1,
                            },
                            xOffset = {
                                order = 6,
                                type = 'range',
                                name = L["X-Offset"],
                                min = -75, max = 75, step = 1,
                            },
                            yOffset = {
                                order = 7,
                                type = 'range',
                                name = L["Y-Offset"],
                                min = -75, max = 75, step = 1,
                            },
                            textThreshold = {
                                name = L["Text Threshold"],
                                desc = L["At what point should the text be displayed. Set to -1 to disable."],
                                type = 'range',
                                order = 8,
                                min = -1, max = 60, step = 1,
                            },
                            anyUnit = {
                                name = L["Show Aura From Other Players"],
                                order = 9,
                                customWidth = 205,
                                type = 'toggle',
                            },
                            onlyShowMissing = {
                                name = L["Show When Not Active"],
                                order = 10,
                                type = 'toggle',
                            },
                            displayText = {
                                name = L["Display Text"],
                                type = 'toggle',
                                order = 11,
                                get = function(info)
                                    local spell = GetSelectedSpellLocal()
                                    if not spell then return end
    
                                    local selectedTable = GetSelectedFiltersLocal()
                                    return (selectedTable[spell].style == 'timerOnly') or selectedTable[spell][info[#info]]
                                end,
                                disabled = function()
                                    local spell = GetSelectedSpellLocal()
                                    if not spell then return end
                                    local selectedTable = GetSelectedFiltersLocal()
                                    return selectedTable[spell].style == 'timerOnly'
                                end
                            },                            
                        },
                    },
                },
            },
            thresholdConfig={                
                order = 5,
                type = "group",
                name = L["Threshold configuration"],
                hidden = function(info) 
                    if selectedSpell then 
                        local selectedTable = GetSelectedFiltersLocal()
                        
                        -- SetDefaults if nothing is set yet
                        local selStyle = selectedTable[selectedSpell].style;
                        if not selectedTable[selectedSpell].colorCount and (selStyle == "coloredIcon" or selStyle =="coloredWatchIcon") then
                            selectedTable[selectedSpell].colorCount = 1
                            selectedTable[selectedSpell].coloringBasedOnType = "numberOfStacks"
                            selectedTable[selectedSpell].color1 = selectedTable[selectedSpell].color;
                        end

                        return false;
                    end
                    return true;
                end,
                disabled = function(info) 
                    if  UF.db.filterExtension.enabled then
                        return false
                    end
                    return true
                end,
                args = { 
                    thresholdConfigurationHeader = {
                        order = 1,
                        type = "header",
                        name = function() 
                            if selectedSpell then
                                local spellName = select(1, GetSpellInfo(selectedSpell))
                                return L["Threshold configuration"].." - Selected spell: "..spellName.." ("..selectedSpell..")";
                            end
                            return L["Threshold configuration"]
                        end,
                    },
                    colorCount = {                        
                        order = 2,
                        type = "select",
                        name = L["Color count"],
                        desc = L["Select how many colors the selected spell status must provide."],
                        values = colorCountList,
                        get = function(info) 
                            if selectedSpell then  
                                local selectedTable = GetSelectedFiltersLocal() 
                                return selectedTable[selectedSpell][info[#info]]
                            end 

                            return selectedColorCount 
                        end,
                        set = function(info, value)
                            if selectedSpell then  
                                local selectedTable = GetSelectedFiltersLocal() 
                                selectedColorCount = nil
                                if value ~= '' then
                                    selectedColorCount = value
                                    selectedTable[selectedSpell][info[#info]] = selectedColorCount;
                                    settingsChanged = true
                                end
                            end 
                        end,
                    },
                    coloringBasedOnType = {                        
                        order = 3,
                        type = "select",
                        name = L["Coloring based on"],
                        values = coloringBasedOnTypeList,
                        desc = L["Select the threshold-type the coloring is based on."],
                        hidden =  function(info)  
                            if selectedSpell then 
                                local selectedTable = GetSelectedFiltersLocal() 
                                
                                if selectedTable[selectedSpell].colorCount and selectedTable[selectedSpell].colorCount > 1 then
                                    return false;
                                end
                            end
                            return true;
                        end,
                        get = function(info) 
                            if selectedSpell then  
                                local selectedTable = GetSelectedFiltersLocal() 
                                return selectedTable[selectedSpell][info[#info]]
                            end 

                            return selectedColoringBasedOnType
                        end,
                        set = function(info, value)
                            if selectedSpell then  
                                local selectedTable = GetSelectedFiltersLocal() 
                                selectedColoringBasedOnType = nil
                                if value ~= '' then
                                    selectedColoringBasedOnType = value
                                    selectedTable[selectedSpell][info[#info]] = selectedColoringBasedOnType;
                                    settingsChanged = true
                                end
                            end 
                        end,
                    },  
                    baseColor = {
                        order = 4, 
                        type = "color",
                        name = L["Base color"],
                        get = function(info)                        
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            local t = selectedTable[spell].color
                            if not t then return end
                            return t.r, t.g, t.b, t.a
                        end,
                        set = function(info, r, g, b)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            selectedTable[spell].color = {
                                r = r,
                                g = g,
                                b = b,
                            }
                            settingsChanged = true
                        end, 
                        hidden = function() 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            return selectedTable[spell].style == 'texturedIcon'
                        end,
                    },                    
                    setColorHeader = {
                        order = 5,
                        type = "header",
                        name = KYA:cOption(L["Set Colors"]),
                    },
                    --ACH:Color(name, desc, order, alpha, width, get, set, disabled, hidden)
                    color1 = {
                        order = 6, 
                        type = "color",
                        name = L["Color 1"],
                        get = function(info)                        
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            local t = selectedTable[spell][info[#info]]
                            if not t then return end
                            return t.r, t.g, t.b, t.a
                        end,
                        set = function(info, r, g, b)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            selectedTable[spell][info[#info]] = {
                                r = r or 1,
                                g = g or 1,
                                b = b or 1,
                            }
                            settingsChanged = true
                        end, 
                        hidden = function() 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 1 then
                                return false;
                            end
                            return true;
                        end,
                    },                  
                    color2 = {
                        order = 6, 
                        type = "color",
                        name = L["Color 2"],
                        get = function(info)                        
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            local t = selectedTable[spell][info[#info]]
                            if not t then return end
                            return t.r, t.g, t.b, t.a
                        end,
                        set = function(info, r, g, b)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            selectedTable[spell][info[#info]] = {
                                r = r or 1,
                                g = g or 1,
                                b = b or 1,
                            }
                            settingsChanged = true
                        end, 
                        hidden = function() 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 2 then
                                return false;
                            end
                            return true;
                        end,
                    },                    
                    color3 = {
                        order = 7, 
                        type = "color",
                        name = L["Color 3"],
                        get = function(info)                        
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            local t = selectedTable[spell][info[#info]]
                            if not t then return end
                            return t.r, t.g, t.b, t.a
                        end,
                        set = function(info, r, g, b)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            selectedTable[spell][info[#info]] = {
                                r = r or 1,
                                g = g or 1,
                                b = b or 1,
                            }
                            settingsChanged = true
                        end, 
                        hidden = function() 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 3 then
                                return false;
                            end
                            return true;
                        end,
                    },                    
                    color4 = {
                        order = 8, 
                        type = "color",
                        name = L["Color 4"],
                        get = function(info)                        
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            local t = selectedTable[spell][info[#info]]
                            if not t then return end
                            return t.r, t.g, t.b, t.a
                        end,
                        set = function(info, r, g, b)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            selectedTable[spell][info[#info]] = {
                                r = r or 1,
                                g = g or 1,
                                b = b or 1,
                            }
                            settingsChanged = true
                        end, 
                        hidden = function() 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 4 then
                                return false;
                            end
                            return true;
                        end,
                    },                    
                    color5 = {
                        order = 9, 
                        type = "color",
                        name = L["Color 5"],
                        get = function(info)                        
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            local t = selectedTable[spell][info[#info]]
                            if not t then return end
                            return t.r, t.g, t.b, t.a
                        end,
                        set = function(info, r, g, b)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            selectedTable[spell][info[#info]] = {
                                r = r or 1,
                                g = g or 1,
                                b = b or 1,
                            }
                            settingsChanged = true
                        end, 
                        hidden = function() 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 5 then
                                return false;
                            end
                            return true;
                        end,
                    },                    
                    color6 = {
                        order = 10, 
                        type = "color",
                        name = L["Color 6"],
                        get = function(info)                        
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            local t = selectedTable[spell][info[#info]]
                            if not t then return end
                            return t.r, t.g, t.b, t.a
                        end,
                        set = function(info, r, g, b)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            selectedTable[spell][info[#info]] = {
                                r = r or 1,
                                g = g or 1,
                                b = b or 1,
                            }
                            settingsChanged = true
                        end, 
                        hidden = function() 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 6 then
                                return false;
                            end
                            return true;
                        end,
                    },                    
                    color7 = {
                        order = 11, 
                        type = "color",
                        name = L["Color 7"],
                        get = function(info)                        
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            local t = selectedTable[spell][info[#info]]
                            if not t then return end
                            return t.r, t.g, t.b, t.a
                        end,
                        set = function(info, r, g, b)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            selectedTable[spell][info[#info]] = {
                                r = r or 1,
                                g = g or 1,
                                b = b or 1,
                            }
                            settingsChanged = true
                        end, 
                        hidden = function() 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 7 then
                                return false;
                            end
                            return true;
                        end,
                    },                    
                    color8 = {
                        order = 12, 
                        type = "color",
                        name = L["Color 8"],
                        get = function(info)                        
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            local t = selectedTable[spell][info[#info]]
                            if not t then return end
                            return t.r, t.g, t.b, t.a
                        end,
                        set = function(info, r, g, b)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            selectedTable[spell][info[#info]] = {
                                r = r or 1,
                                g = g or 1,
                                b = b or 1,
                            }
                            settingsChanged = true
                        end, 
                        hidden = function() 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 8 then
                                return false;
                            end
                            return true;
                        end,
                    },                    
                    color9 = {
                        order = 13, 
                        type = "color",
                        name = L["Color 9"],
                        get = function(info)                        
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            local t = selectedTable[spell][info[#info]]
                            if not t then return end
                            return t.r, t.g, t.b, t.a
                        end,
                        set = function(info, r, g, b)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            selectedTable[spell][info[#info]] = {
                                r = r or 1,
                                g = g or 1,
                                b = b or 1,
                            }
                            settingsChanged = true
                        end, 
                        hidden = function() 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount == 9 then
                                return false;
                            end
                            return true;
                        end,
                    }, 
                    thresholdValuesHeader = {
                        order = 14,
                        type = "header",
                        name = KYA:cOption(L["Set threshold values"]),
                    },                  
                    threshold1 = {
                        name = L["Threshold 1 (Color 1)"],
                        desc = L["At what point should the color be displayed. Set to -1 to disable."],
                        type = 'range',
                        order = 15,
                        min = 0, max = 60, step = 1,
                        get = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].threshold1Values then
                                if selectedTable[spell].coloringBasedOnType == "remainingTime" and selectedTable[spell].threshold1Values.remainingTime then
                                    return selectedTable[spell].threshold1Values.remainingTime;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" and selectedTable[spell].threshold1Values.elapsedTime then
                                    return selectedTable[spell].threshold1Values.elapsedTime;
                                end
                            end

                            return selectedTable[spell][info[#info]];
                        end,
                        set = function(info,value)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal() 

                                if not selectedTable[spell].threshold1Values then selectedTable[spell].threshold1Values = {}; end

                                if selectedTable[spell].coloringBasedOnType == "remainingTime" then
                                    selectedTable[spell].threshold1Values.remainingTime = value;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" then
                                    selectedTable[spell].threshold1Values.elapsedTime = value;
                                end
                                selectedTable[spell].threshold1Values.color = selectedTable[spell].color1

                                selectedTable[spell][info[#info]] = value; 
                                settingsChanged = true       
                        end,
                        hidden = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 1 and (selectedTable[spell].coloringBasedOnType == "remainingTime" or selectedTable[spell].coloringBasedOnType == "elapsedTime") then
                                return false;
                            end
                            return true;
                        end,
                    },                  
                    threshold2 = {
                        name = L["Threshold 2 (Color 2)"],
                        desc = L["At what point should the color be displayed. Set to -1 to disable."],
                        type = 'range',
                        order = 16,
                        min = 0, max = 60, step = 1,
                        get = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].threshold2Values then
                                if selectedTable[spell].coloringBasedOnType == "remainingTime" and selectedTable[spell].threshold2Values.remainingTime then
                                    return selectedTable[spell].threshold2Values.remainingTime;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" and selectedTable[spell].threshold2Values.elapsedTime then
                                    return selectedTable[spell].threshold2Values.elapsedTime;
                                end
                            end

                            return selectedTable[spell][info[#info]];
                        end,
                        set = function(info,value)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal() 

                                if not selectedTable[spell].threshold2Values then selectedTable[spell].threshold2Values = {}; end

                                if selectedTable[spell].coloringBasedOnType == "remainingTime" then
                                    selectedTable[spell].threshold2Values.remainingTime = value;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" then
                                    selectedTable[spell].threshold2Values.elapsedTime = value;
                                end
                                selectedTable[spell].threshold2Values.color = selectedTable[spell].color2

                                selectedTable[spell][info[#info]] = value; 
                                settingsChanged = true   
                                --ElvUI_UF:Update_AllFrames()             
                        end,
                        hidden = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 2 and (selectedTable[spell].coloringBasedOnType == "remainingTime" or selectedTable[spell].coloringBasedOnType == "elapsedTime") then
                                return false;
                            end
                            return true;
                        end,
                    },                   
                    threshold3 = {
                        name = L["Threshold 3 (Color 3)"],
                        desc = L["At what point should the color be displayed. Set to -1 to disable."],
                        type = 'range',
                        order = 17,
                        min = 0, max = 60, step = 1,
                        get = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].threshold3Values then
                                if selectedTable[spell].coloringBasedOnType == "remainingTime" and selectedTable[spell].threshold3Values.remainingTime then
                                    return selectedTable[spell].threshold3Values.remainingTime;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" and selectedTable[spell].threshold3Values.elapsedTime then
                                    return selectedTable[spell].threshold3Values.elapsedTime;
                                end
                            end

                            return selectedTable[spell][info[#info]];
                        end,
                        set = function(info,value)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal() 
                            if selectedTable[spell][info[#info]] then 

                                if not selectedTable[spell].threshold3Values then selectedTable[spell].threshold3Values = {}; end

                                if selectedTable[spell].coloringBasedOnType == "remainingTime" then
                                    selectedTable[spell].threshold3Values.remainingTime = value;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" then
                                    selectedTable[spell].threshold3Values.elapsedTime = value;
                                end
                                selectedTable[spell].threshold3Values.color = selectedTable[spell].color3

                                selectedTable[spell][info[#info]] = value;
                                settingsChanged = true
                            end                            
                        end,
                        hidden = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 3 and (selectedTable[spell].coloringBasedOnType == "remainingTime" or selectedTable[spell].coloringBasedOnType == "elapsedTime") then
                                return false;
                            end
                            return true;
                        end,
                    },                    
                    threshold4 = {
                        name = L["Threshold 4 (Color 4)"],
                        desc = L["At what point should the color be displayed. Set to -1 to disable."],
                        type = 'range',
                        order = 18,
                        min = 0, max = 60, step = 1,
                        get = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].threshold4Values then
                                if selectedTable[spell].coloringBasedOnType == "remainingTime" and selectedTable[spell].threshold4Values.remainingTime then
                                    return selectedTable[spell].threshold4Values.remainingTime;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" and selectedTable[spell].threshold4Values.elapsedTime then
                                    return selectedTable[spell].threshold4Values.elapsedTime;
                                end
                            end

                            return selectedTable[spell][info[#info]];
                        end,
                        set = function(info,value)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal() 

                                if not selectedTable[spell].threshold4Values then selectedTable[spell].threshold4Values = {}; end

                                if selectedTable[spell].coloringBasedOnType == "remainingTime" then
                                    selectedTable[spell].threshold4Values.remainingTime = value;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" then
                                    selectedTable[spell].threshold4Values.elapsedTime = value;
                                end
                                selectedTable[spell].threshold4Values.color = selectedTable[spell].color4

                                selectedTable[spell][info[#info]] = value; 
                                settingsChanged = true                 
                        end,
                        hidden = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 4 and (selectedTable[spell].coloringBasedOnType == "remainingTime" or selectedTable[spell].coloringBasedOnType == "elapsedTime") then
                                return false;
                            end
                            return true;
                        end,
                    },                       
                    threshold5 = {
                        name = L["Threshold 5 (Color 5)"],
                        desc = L["At what point should the color be displayed. Set to -1 to disable."],
                        type = 'range',
                        order = 19,
                        min = 0, max = 60, step = 1,
                        get = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].threshold5Values then
                                if selectedTable[spell].coloringBasedOnType == "remainingTime" and selectedTable[spell].threshold5Values.remainingTime then
                                    return selectedTable[spell].threshold5Values.remainingTime;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" and selectedTable[spell].threshold5Values.elapsedTime then
                                    return selectedTable[spell].threshold5Values.elapsedTime;
                                end
                            end

                            return selectedTable[spell][info[#info]];
                        end,
                        set = function(info,value)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal() 

                                if not selectedTable[spell].threshold5Values then selectedTable[spell].threshold5Values = {}; end

                                if selectedTable[spell].coloringBasedOnType == "remainingTime" then
                                    selectedTable[spell].threshold5Values.remainingTime = value;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" then
                                    selectedTable[spell].threshold5Values.elapsedTime = value;
                                end
                                selectedTable[spell].threshold5Values.color = selectedTable[spell].color5

                                selectedTable[spell][info[#info]] = value;
                                settingsChanged = true                
                        end,
                        hidden = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 5 and (selectedTable[spell].coloringBasedOnType == "remainingTime" or selectedTable[spell].coloringBasedOnType == "elapsedTime") then
                                return false;
                            end
                            return true;
                        end,
                    },                   
                    threshold6 = {
                        name = L["Threshold 6 (Color 6)"],
                        desc = L["At what point should the color be displayed. Set to -1 to disable."],
                        type = 'range',
                        order = 20,
                        min = 0, max = 60, step = 1,
                        get = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].threshold6Values then
                                if selectedTable[spell].coloringBasedOnType == "remainingTime" and selectedTable[spell].threshold6Values.remainingTime then
                                    return selectedTable[spell].threshold6Values.remainingTime;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" and selectedTable[spell].threshold6Values.elapsedTime then
                                    return selectedTable[spell].threshold6Values.elapsedTime;
                                end
                            end

                            return selectedTable[spell][info[#info]];
                        end,
                        set = function(info,value)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal() 

                                if not selectedTable[spell].threshold6Values then selectedTable[spell].threshold6Values = {}; end

                                if selectedTable[spell].coloringBasedOnType == "remainingTime" then
                                    selectedTable[spell].threshold6Values.remainingTime = value;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" then
                                    selectedTable[spell].threshold6Values.elapsedTime = value;
                                end
                                selectedTable[spell].threshold6Values.color = selectedTable[spell].color6

                                selectedTable[spell][info[#info]] = value;
                                settingsChanged = true                   
                        end,
                        hidden = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 6 and (selectedTable[spell].coloringBasedOnType == "remainingTime" or selectedTable[spell].coloringBasedOnType == "elapsedTime") then
                                return false;
                            end
                            return true;
                        end,
                    },                   
                    threshold7 = {
                        name = L["Threshold 7 (Color 7)"],
                        desc = L["At what point should the color be displayed. Set to -1 to disable."],
                        type = 'range',
                        order = 21,
                        min = 0, max = 60, step = 1,
                        get = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].threshold7Values then
                                if selectedTable[spell].coloringBasedOnType == "remainingTime" and selectedTable[spell].threshold7Values.remainingTime then
                                    return selectedTable[spell].threshold7Values.remainingTime;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" and selectedTable[spell].threshold7Values.elapsedTime then
                                    return selectedTable[spell].threshold7Values.elapsedTime;
                                end
                            end

                            return selectedTable[spell][info[#info]];
                        end,
                        set = function(info,value)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal() 

                                if not selectedTable[spell].threshold7Values then selectedTable[spell].threshold7Values = {}; end

                                if selectedTable[spell].coloringBasedOnType == "remainingTime" then
                                    selectedTable[spell].threshold7Values.remainingTime = value;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" then
                                    selectedTable[spell].threshold7Values.elapsedTime = value;
                                end
                                selectedTable[spell].threshold7Values.color = selectedTable[spell].color7

                                selectedTable[spell][info[#info]] = value;  
                                settingsChanged = true                  
                        end,
                        hidden = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 7 and (selectedTable[spell].coloringBasedOnType == "remainingTime" or selectedTable[spell].coloringBasedOnType == "elapsedTime") then
                                return false;
                            end
                            return true;
                        end,
                    },                   
                    threshold8 = {
                        name = L["Threshold 8 (Color 8)"],
                        desc = L["At what point should the color be displayed. Set to -1 to disable."],
                        type = 'range',
                        order = 22,
                        min = 0, max = 60, step = 1,
                        get = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].threshold8Values then
                                if selectedTable[spell].coloringBasedOnType == "remainingTime" and selectedTable[spell].threshold8Values.remainingTime then
                                    return selectedTable[spell].threshold8Values.remainingTime;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" and selectedTable[spell].threshold8Values.elapsedTime then
                                    return selectedTable[spell].threshold8Values.elapsedTime;
                                end
                            end

                            return selectedTable[spell][info[#info]];
                        end,
                        set = function(info,value)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal() 
                                if not selectedTable[spell].threshold8Values then selectedTable[spell].threshold8Values = {}; end

                                if selectedTable[spell].coloringBasedOnType == "remainingTime" then
                                    selectedTable[spell].threshold8Values.remainingTime = value;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" then
                                    selectedTable[spell].threshold8Values.elapsedTime = value;
                                end
                                selectedTable[spell].threshold8Values.color = selectedTable[spell].color8

                                selectedTable[spell][info[#info]] = value; 
                                settingsChanged = true                          
                        end,
                        hidden = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount >= 8 and (selectedTable[spell].coloringBasedOnType == "remainingTime" or selectedTable[spell].coloringBasedOnType == "elapsedTime") then
                                return false;
                            end
                            return true;
                        end,
                    },                  
                    threshold9 = {
                        name = L["Threshold 9 (Color 9)"],
                        desc = L["At what point should the color be displayed. Set to -1 to disable."],
                        type = 'range',
                        order = 23,
                        min = 0, max = 60, step = 1,
                        get = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].threshold9Values then
                                if selectedTable[spell].coloringBasedOnType == "remainingTime" and selectedTable[spell].threshold9Values.remainingTime then
                                    return selectedTable[spell].threshold9Values.remainingTime;
                                elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" and selectedTable[spell].threshold9Values.elapsedTime then
                                    return selectedTable[spell].threshold9Values.elapsedTime;
                                end
                            end

                            return selectedTable[spell][info[#info]];
                        end,
                        set = function(info,value)
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal() 

                            if not selectedTable[spell].threshold9Values then selectedTable[spell].threshold9Values = {}; end
                            
                            if selectedTable[spell].coloringBasedOnType == "remainingTime" then
                                selectedTable[spell].threshold9Values.remainingTime = value;
                            elseif selectedTable[spell].coloringBasedOnType == "elapsedTime" then
                                selectedTable[spell].threshold9Values.elapsedTime = value;
                            end
                            selectedTable[spell].threshold9Values.color = selectedTable[spell].color9

                            selectedTable[spell][info[#info]] = value; 
                            settingsChanged = true                 
                        end,
                        hidden = function(info) 
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            
                            local selectedTable = GetSelectedFiltersLocal()

                            if selectedTable[spell].colorCount == 9 and (selectedTable[spell].coloringBasedOnType == "remainingTime" or selectedTable[spell].coloringBasedOnType == "elapsedTime") then
                                return false;
                            end
                            return true;
                        end,
                    },
                    execUpdate = {
                        name = L["Update Unitframes"],
                        type = "execute",
                        order = 24,
                        disabled = function()
                            if settingsChanged then
                                return false
                            end
                            return true;
                        end,
                        func = function() 
                            ElvUI_UF:Update_AllFrames()                            
                            settingsChanged = false
                        end,
                    },
                },
            }      
		},
	}
        E.Options.args.filters.args.mainOptions.args.buffIndicator.args.thresholdTimedColorsGroup.args = groups
        --ACH:Select(L["Position"], nil, 6, { TOP = L["Top"], BOTTOM = L["Bottom"], LEFT = L["Left"], RIGHT = L["Right"] })
end

tinsert(KYA.Config, AddFilterOptions)