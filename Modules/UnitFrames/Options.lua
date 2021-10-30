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

local quickSearchText, selectedStyle, selectedSpell, selectedFilter, selectedNumberOfThresholds, filterList, spellList = '', nil, nil, nil, nil, {}, {}
local defaultFilterList = {	['Aura Indicator (Global)'] = 'Aura Indicator (Global)', ['Aura Indicator (Class)'] = 'Aura Indicator (Class)', ['Aura Indicator (Pet)'] = 'Aura Indicator (Pet)',  ['Aura Indicator (Profile)'] = 'Aura Indicator (Profile)', ['AuraBar Colors'] = 'AuraBar Colors', ['Aura Highlight'] = 'Aura Highlight' }
local auraBarDefaults = { enable = true, color = { r = 1, g = 1, b = 1 } }
local filterTypes = {
    class = 'Aura Indicator (Class)',
    pet = 'Aura Indicator (Pet)',
    profile = 'Aura Indicator (Profile)',
}
local styleList = {        
    timerOnly = L["Timer Only"],
    coloredIcon = L["Colored Icon"],
    texturedIcon = L["Textured Icon"],
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
    E.Options.args.filters.args.mainOptions.args.buffIndicator.disabled = function() 
        if UF.db.filterExtension.enabled then
            return true
        end
        return false
    end

    E.Options.args.kyaui.args.filterExtension = {
		order = 4,
		type = "group",
		name = "Filter Extension",
		args = {
			filterExtensionHeader = {
				order = 1,
				type = "header",
				name = KYA:cOption("Filter Extension"),
			},
			filterExtensionToggle = {
				order = 2,
				type = "toggle",
				name = L["Enable"],
                desc = "Enable some enhanced features for the filter (Aura Indicator) section.",    
                get = function(info)
                    return UF.db.filterExtension.enabled
                end,
                set = function(info, value)
                    UF.db.filterExtension.enabled = value
                    ElvUI_UF:Update_AllFrames()
                end,                    
            },
            addOrRemoveThresholdGroup = {
                order = 4,
                type = "group",
                name = "Select filters Group",
                disabled = function(info) 
                    if  UF.db.filterExtension.enabled then
                        return false
                    end
                    return true
                end,
                args = {                    
                    selectFilterHeader = {
                        order = 1,
                        type = "header",
                        name = L["Select Filters"],                  
                    },
                    selectFilter = {
                        order = 2,
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
                        order = 3,
                        customWidth = 350,
                        get = function(info) return selectedSpell or '' end,
                        set = function(info, value)
                            selectedSpell = (value ~= '' and value) or nil
                        end,
                        values = SetSpellListLocal,
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
                            numOfThresholds = {
                                name = L["Number of thresholds"],
                                desc = L["Sets the number of thresholds you want for this particular spell. Set it to zero will deactivate it"],
                                type = 'range',
                                order = 12,
                                min = 0, max = 10, step = 1,
                                get = function(info)
                                    local spell = GetSelectedSpellLocal()
                                    if not spell then return end
            
                                    local selectedTable = GetSelectedFiltersLocal()
    
                                    if selectedTable[spell].numOfThresholds and UF.db.filterExtension.enabled == true and (selectedTable[spell].style == 'coloredIcon') then
                                        local groups = {}
                                        for i = 1, selectedTable[spell].numOfThresholds do
                                            groups['thresholdGroup'..i] = {
                                                name = "Threshold Group "..i,
                                                type = 'group',
                                                order = i, 
                                                inline = false,
                                                get = function(info)
                                                    local spell = GetSelectedSpellLocal()
                                                    if not spell then return end
                                                    local selectedTable = GetSelectedFiltersLocal()
                                                    return selectedTable[spell]['thresholdGroup'..i][info[#info]]
                                                end,
                                                set = function(info, value)
                                                    local spell = GetSelectedSpellLocal()
                                                    if not spell then return end
                                                    local selectedTable = GetSelectedFiltersLocal()
                                                    selectedTable[spell]['thresholdGroup'..i][info[#info]] = value
                                
                                                    ElvUI_UF:Update_AllFrames()
                                                end,
                                                args = {
                                                    enabled = {
                                                        name = L["Enable"],
                                                        type = "toggle",
                                                        order = 1,
                                                    },
                                                    color = {
                                                        name = L["COLOR"],
                                                        type = 'color',
                                                        order = 2,
                                                        get = function(info)
                                                            local spell = GetSelectedSpellLocal()
                                                            if not spell then return end
                                                            local selectedTable = GetSelectedFiltersLocal()
                                                            local t = selectedTable[spell]['thresholdGroup'..i][info[#info]]
                                                            if not t then return end
                                                            return t.r,t.g,t.b--,t.a
                                                        end,
                                                        set = function(info, r, g, b)
                                                            local spell = GetSelectedSpellLocal()
                                                            if not spell then return end
                                                            local selectedTable = GetSelectedFiltersLocal()
                                                            
                                                            selectedTable[spell]['thresholdGroup'..i][info[#info]].r = r
                                                            selectedTable[spell]['thresholdGroup'..i][info[#info]].g = g
                                                            selectedTable[spell]['thresholdGroup'..i][info[#info]].b = b
                                
                                                            --ElvUI_UF:Update_AllFrames()
                                                        end,
                                                        disabled = function()
                                                            local spell = GetSelectedSpellLocal()
                                                            if not spell then return end
                                                            local selectedTable = GetSelectedFiltersLocal()
                                                            return not selectedTable[spell]['thresholdGroup'..i].enabled
                                                        end,
                                                    },                    
                                                    colorThreshold = {
                                                        name = "Color Threshold",
                                                        desc = L["At what point should the text be displayed. Set to -1 to disable."],
                                                        type = 'range',
                                                        order = 3,
                                                        min = 1, max = 60, step = 1,
                                                        get = function(info) 
                                                            local spell = GetSelectedSpellLocal()
                                                            if not spell then return end
                                                            local selectedTable = GetSelectedFiltersLocal()      
                                                            return selectedTable[spell]['thresholdGroup'..i][info[#info]]
                                                        end,
                                                        set = function(info,value)
                                                            local spell = GetSelectedSpellLocal()
                                                            if not spell then return end
                                                            local selectedTable = GetSelectedFiltersLocal()                                       
                                                            selectedTable[spell]['thresholdGroup'..i][info[#info]] = value
                                                        end,
                                                        disabled = function()
                                                            local spell = GetSelectedSpellLocal()
                                                            if not spell then return end
                                                            local selectedTable = GetSelectedFiltersLocal()
                                                            return not selectedTable[spell]['thresholdGroup'..i].enabled
                                                        end,
                                                    },
                                                },
                                            }   
                                        end
                                        E.Options.args.kyaui.args.filterExtension.args.addOrRemoveThresholdGroup.args.thresholdTimedColorsGroup.args = groups;
                                    end
                                    return selectedTable[spell][info[#info]]
                                end,
                                set = function(info, value)
                                    local spell = GetSelectedSpellLocal()
                                    if not spell then return end
            
                                    local selectedTable = GetSelectedFiltersLocal()
                                    selectedTable[spell][info[#info]] = value
                                end,
                            },
                            execUpdate = {
                                name = L["Update Unitframes"],
                                type = "execute",
                                order = 13,
                                func = function() 
                                    ElvUI_UF:Update_AllFrames()
                                end,
                            },
                        },
                    },
                   thresholdTimedColorsGroup = {
                        name = function()             
                            local spell = GetSelectedSpellLocal()
                            local spellName = spell and GetSpellInfo(spell)
                            return (spellName and spellName..' |cFF888888('..spell..')|r | |cffc83535Threshold Timed Colors|r') or spell or ' '
                        end,
                        type = 'group',
                        hidden = function()
                            local spell = GetSelectedSpellLocal()
                            if not spell then return end
                            local selectedTable = GetSelectedFiltersLocal()
                            
                            if  selectedTable[spell].numOfThresholds and UF.db.filterExtension.enabled == true and (selectedTable[spell].style == 'coloredIcon') then  
                                for i = 1, selectedTable[spell].numOfThresholds do              
                                    if not selectedTable[spell]['thresholdGroup'..i]  then 
                                        selectedTable[spell]['thresholdGroup'..i] = {} 
                                        selectedTable[spell]['thresholdGroup'..i].enabled = false
                                        selectedTable[spell]['thresholdGroup'..i].color = {}
                                        selectedTable[spell]['thresholdGroup'..i].color.r = 1
                                        selectedTable[spell]['thresholdGroup'..i].color.g = 1
                                        selectedTable[spell]['thresholdGroup'..i].color.b = 1
                                        selectedTable[spell]['thresholdGroup'..i].color.a = 1
                                        selectedTable[spell]['thresholdGroup'..i].colorThreshold = 1
                                    end      
                                end      
                                return false
                            end   
                            return true
                        end,
                        order = -1,
                        inline = true,
                        args = {},
                    },
                },
            },      
		},
	}
        --E.Options.args.filters.args.mainOptions.args.buffIndicator.args.thresholdTimedColorsGroup.args = groups
        --ACH:Select(L["Position"], nil, 6, { TOP = L["Top"], BOTTOM = L["Bottom"], LEFT = L["Left"], RIGHT = L["Right"] })
end

tinsert(KYA.Config, AddFilterOptions)