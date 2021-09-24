local KYA, E, L, V, P, G = unpack(select(2, ...));
local UF = KYA:GetModule('UnitFrames')
local ElvUI_UF = E:GetModule('UnitFrames')
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

--local quickSearchText, selectedSpell, selectedFilter, selectedStyle, filterList, spellList = '', nil, nil, nil, {}, {}
local auraBarDefaults = { enable = true, color = { r = 1, g = 1, b = 1 } }

local function GetSelectedFilters()
	local class = UF.Filters.selectedFilter == 'Aura Indicator (Class)'
	local pet = UF.Filters.selectedFilter == 'Aura Indicator (Pet)'
	local profile = UF.Filters.selectedFilter == 'Aura Indicator (Profile)'
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

local function GetSelectedStyle()
	if UF.Filters.selectedStyle and UF.Filters.selectedStyle ~= '' then
		local style = UF.Filters.selectedStyle
		if style then
			return tostring(style) or style
		end
	end
end
local styleList = {        
    timerOnly = L["Timer Only"],
    coloredIcon = L["Colored Icon"],
    texturedIcon = L["Textured Icon"],
}

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

local function InsertOptionsToElvUIFilterOptions()

    E.Options.args.filters.args.mainOptions.args.selectFilter.get = function(info) return UF.Filters.selectedFilter end
    E.Options.args.filters.args.mainOptions.args.selectFilter.set = function(info, value)
        UF.Filters.selectedFilter, UF.Filters.selectedSpell, UF.Filters.quickSearchText = nil, nil, ''
        if value ~= '' then
            UF.Filters.selectedFilter = value
        end
    end
    E.Options.args.filters.args.mainOptions.args.filterGroup.name = function() return UF.Filters.selectedFilter end
    E.Options.args.filters.args.mainOptions.args.filterGroup.hidden = function() return not UF.Filters.selectedFilter end
    E.Options.args.filters.args.mainOptions.args.filterGroup.args.selectSpell.values = SetSpellList
    E.Options.args.filters.args.mainOptions.args.filterGroup.args.selectSpell.get = function(info) return UF.Filters.selectedSpell end
    E.Options.args.filters.args.mainOptions.args.filterGroup.args.selectSpell.set = function(info, value) UF.Filters.selectedSpell = (value ~= '' and value) or nil; end
    E.Options.args.filters.args.mainOptions.args.filterGroup.args.quickSearch.get = function() return UF.Filters.quickSearchText end
    E.Options.args.filters.args.mainOptions.args.filterGroup.args.quickSearch.set = function(info,value) UF.Filters.quickSearchText = value end
    E.Options.args.filters.args.mainOptions.args.filterGroup.args.filterType.get = function() if E.global.unitframe.aurafilters[UF.Filters.selectedFilter] then return E.global.unitframe.aurafilters[UF.Filters.selectedFilter].type end return end
    E.Options.args.filters.args.mainOptions.args.filterGroup.args.filterType.set = function(info, value) E.global.unitframe.aurafilters[UF.Filters.selectedFilter].type = value; ElvUI_UF:Update_AllFrames(); end
    E.Options.args.filters.args.mainOptions.args.filterGroup.args.filterType.hidden = function() return (
        UF.Filters.selectedFilter == 'Aura Highlight' or 
        UF.Filters.selectedFilter == 'AuraBar Colors' or 
        UF.Filters.selectedFilter == 'Aura Indicator (Pet)' or 
        UF.Filters.selectedFilter == 'Aura Indicator (Profile)' or 
        UF.Filters.selectedFilter == 'Aura Indicator (Class)' or 
        UF.Filters.selectedFilter == 'Aura Indicator (Global)' or 
        UF.Filters.selectedFilter == 'Whitelist' or 
        UF.Filters.selectedFilter == 'Blacklist') end
    E.Options.args.filters.args.mainOptions.args.filterGroup.args.removeSpell.confirm = function(info, value)
        local spellName = tonumber(value) and GetSpellInfo(value)
        local name = (spellName and format('%s |cFF888888(%s)|r', spellName, value)) or tostring(value)
        return 'Remove Spell - '..name
    end
    E.Options.args.filters.args.mainOptions.args.filterGroup.args.removeSpell.get = function(info) return '' end    
    E.Options.args.filters.args.mainOptions.args.filterGroup.args.removeSpell.set = function(info, value)
        if not value then return end
        UF.Filters.selectedSpell = nil

        if UF.Filters.selectedFilter == 'Aura Highlight' then
            E.global.unitframe.DebuffHighlightColors[value] = nil;
        elseif UF.Filters.selectedFilter == 'AuraBar Colors' then
            if G.unitframe.AuraBarColors[value] then
                E.global.unitframe.AuraBarColors[value].enable = false;
            else
                E.global.unitframe.AuraBarColors[value] = nil;
            end
        elseif UF.Filters.selectedFilter == 'Aura Indicator (Pet)' or UF.Filters.selectedFilter == 'Aura Indicator (Profile)' or UF.Filters.selectedFilter == 'Aura Indicator (Class)' or UF.Filters.selectedFilter == 'Aura Indicator (Global)' then
            local selectedTable, defaultTable = GetSelectedFilters()

            if defaultTable[value] then
                selectedTable[value].enabled = false
            else
                selectedTable[value] = nil
            end
        elseif G.unitframe.aurafilters[UF.Filters.selectedFilter] and G.unitframe.aurafilters[UF.Filters.selectedFilter].spells[value] then
            E.global.unitframe.aurafilters[UF.Filters.selectedFilter].spells[value].enable = false;
        else
            E.global.unitframe.aurafilters[UF.Filters.selectedFilter].spells[value] = nil;
        end

        ElvUI_UF:Update_AllFrames();
    end
    E.Options.args.filters.args.mainOptions.args.filterGroup.args.removeSpell.values = SetSpellList
    E.Options.args.filters.args.mainOptions.args.filterGroup.args.addSpell.get = function(info) return '' end
    E.Options.args.filters.args.mainOptions.args.filterGroup.args.addSpell.set = function(info, value)
        value = tonumber(value)
        if not value then return end

        local spellName = GetSpellInfo(value)
        UF.Filters.selectedSpell = (spellName and value) or nil
        if not UF.Filters.selectedSpell then return end

        if UF.Filters.selectedFilter == 'Aura Highlight' then
            if not E.global.unitframe.DebuffHighlightColors[value] then
                E.global.unitframe.DebuffHighlightColors[value] = { enable = true, style = 'GLOW', color = {r = 0.8, g = 0, b = 0, a = 0.85} }
            end
        elseif UF.Filters.selectedFilter == 'AuraBar Colors' then
            if not E.global.unitframe.AuraBarColors[value] then
                E.global.unitframe.AuraBarColors[value] = E:CopyTable({}, auraBarDefaults)
            end
        elseif UF.Filters.selectedFilter == 'Aura Indicator (Pet)' or UF.Filters.selectedFilter == 'Aura Indicator (Profile)' or UF.Filters.selectedFilter == 'Aura Indicator (Class)' or UF.Filters.selectedFilter == 'Aura Indicator (Global)'  then
            local selectedTable = GetSelectedFilters()
            if not selectedTable[value] then
                selectedTable[value] = ElvUI_UF:AuraWatch_AddSpell(value, 'TOPRIGHT')
            end
        elseif not E.global.unitframe.aurafilters[UF.Filters.selectedFilter].spells[value] then
            E.global.unitframe.aurafilters[UF.Filters.selectedFilter].spells[value] = { enable = true, priority = 0, stackThreshold = 0 }
        end

        ElvUI_UF:Update_AllFrames()
    end
    E.Options.args.filters.args.mainOptions.args.buffIndicator.name = function()             
        local spell = GetSelectedSpell()
        local spellName = spell and GetSpellInfo(spell)
        return (spellName and spellName..' |cFF888888('..spell..')|r') or spell or ' '
    end
    E.Options.args.filters.args.mainOptions.args.buffIndicator.hidden = function()  return not UF.Filters.selectedSpell or (
        UF.Filters.selectedFilter ~= 'Aura Indicator (Pet)' and 
        UF.Filters.selectedFilter ~= 'Aura Indicator (Profile)' and 
        UF.Filters.selectedFilter ~= 'Aura Indicator (Class)' and 
        UF.Filters.selectedFilter ~= 'Aura Indicator (Global)') end
    E.Options.args.filters.args.mainOptions.args.buffIndicator.get = function(info)
        local spell = GetSelectedSpell()
        if not spell then return end

        local selectedTable = GetSelectedFilters()
        return selectedTable[spell][info[#info]]
    end
    E.Options.args.filters.args.mainOptions.args.buffIndicator.set = function(info, value)
        local spell = GetSelectedSpell()
        if not spell then return end

        local selectedTable = GetSelectedFilters()
        selectedTable[spell][info[#info]] = value;
        ElvUI_UF:Update_AllFrames()
    end
    E.Options.args.filters.args.mainOptions.args.buffIndicator.args.style.get = function(info)
        local spell = GetSelectedSpell()
        if not spell then return end
        local selectedTable = GetSelectedFilters()
        return selectedTable[spell][info[#info]]
    end
    E.Options.args.filters.args.mainOptions.args.buffIndicator.args.style.set = function(info,value)
        local spell = GetSelectedSpell()
        if not spell then return end
        local selectedTable = GetSelectedFilters()
        selectedTable[spell][info[#info]] = value
        ElvUI_UF:Update_AllFrames()
    end
    E.Options.args.filters.args.mainOptions.args.buffIndicator.args.style.values = styleList
    E.Options.args.filters.args.mainOptions.args.buffIndicator.args.displayText.get = function(info)
        local spell = GetSelectedSpell()
        if not spell then return end

        local selectedTable = GetSelectedFilters()
        return (selectedTable[spell].style == 'timerOnly') or selectedTable[spell][info[#info]]
    end
    E.Options.args.filters.args.mainOptions.args.buffIndicator.args.displayText.disabled = function()
        local spell = GetSelectedSpell()
        if not spell then return end
        local selectedTable = GetSelectedFilters()
        return selectedTable[spell].style == 'timerOnly'
    end
    E.Options.args.filters.args.mainOptions.args.buffIndicator.args.color.customWidth = 75
    E.Options.args.filters.args.mainOptions.args.buffIndicator.args.color.get = function(info)
        local spell = GetSelectedSpell()
        if not spell then return end
        local selectedTable = GetSelectedFilters()
        local t = selectedTable[spell][info[#info]]
        return t.r, t.g, t.b, t.a
    end
    E.Options.args.filters.args.mainOptions.args.buffIndicator.args.color.set = function(info, r, g, b)
        local spell = GetSelectedSpell()
        if not spell then return end
        local selectedTable = GetSelectedFilters()
        local t = selectedTable[spell][info[#info]]
        t.r, t.g, t.b = r, g, b

        ElvUI_UF:Update_AllFrames()
    end
    E.Options.args.filters.args.mainOptions.args.buffIndicator.args.color.disabled = function()
        local spell = GetSelectedSpell()
        if not spell then return end
        local selectedTable = GetSelectedFilters()
        return (selectedTable[spell].style == 'texturedIcon')
    end
    E.Options.args.filters.args.mainOptions.args.buffIndicator.args.isStatic = {
        name = L["Static Icon"],
        type = 'toggle',
        order = 4,
        hidden = function()
            local spell = GetSelectedSpell()
            if not spell then return end
            local selectedTable = GetSelectedFilters()

            if UF.db.filterExtension.enabled and (selectedTable[spell].style == 'coloredIcon') then       
                return false
            end
            return true
        end,
        get = function(info)
            local spell = GetSelectedSpell()
            if not spell then return end
            local selectedTable = GetSelectedFilters()
            return selectedTable[spell][info[#info]]
        end,
        set = function(info, value)
            local spell = GetSelectedSpell()
            if not spell then return end
            local selectedTable = GetSelectedFilters()
            if not selectedTable[spell][info[#info]] then selectedTable[spell][info[#info]] = false end   
            selectedTable[spell][info[#info]] = value
            ElvUI_UF:Update_AllFrames()
        end,
    }
    E.Options.args.filters.args.mainOptions.args.buffIndicator.args.thresholdTimedColorsGroup = {
        name = function()             
            local spell = GetSelectedSpell()
            local spellName = spell and GetSpellInfo(spell)
            return (spellName and spellName..' |cFF888888('..spell..')|r | |cffc83535Threshold Timed Colors|r') or spell or ' '
        end,
        type = 'group',
        hidden = function()
            local spell = GetSelectedSpell()
            if not spell then return end
            local selectedTable = GetSelectedFilters()
            
            if UF.db.filterExtension.enabled == true and (selectedTable[spell].style == 'coloredIcon') then  
                for i = 1, 5 do              
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
        order = -17,
        inline = true,
        args = {},
    }
    local groups = {}
    for i = 1, 5 do
        groups['thresholdGroup'..i] = {
            name = "Threshold Group "..i,
            type = 'group',
            order = i, 
            inline = true,
            args = {
                enabled = {
                    name = L['Enabled'],
                    type = 'toggle',
                    order = 0,
                    get = function(info)
                        local spell = GetSelectedSpell()
                        if not spell then return end
                        local selectedTable = GetSelectedFilters()
                        return selectedTable[spell]['thresholdGroup'..i][info[#info]]
                    end,
                    set = function(info, value)
                        local spell = GetSelectedSpell()
                        if not spell then return end
                        local selectedTable = GetSelectedFilters()
                        selectedTable[spell]['thresholdGroup'..i][info[#info]] = value
                    end,
                },
                color = {
                    name = L["COLOR"],
                    type = 'color',
                    order = 1,
                    get = function(info)
                        local spell = GetSelectedSpell()
                        if not spell then return end
                        local selectedTable = GetSelectedFilters()
                        local t = selectedTable[spell]['thresholdGroup'..i][info[#info]]
                        if not t then return end
                        return t.r,t.g,t.b,t.a
                    end,
                    set = function(info, r, g, b)
                        local spell = GetSelectedSpell()
                        if not spell then return end
                        local selectedTable = GetSelectedFilters()
                        
                        selectedTable[spell]['thresholdGroup'..i][info[#info]].r = r
                        selectedTable[spell]['thresholdGroup'..i][info[#info]].g = g
                        selectedTable[spell]['thresholdGroup'..i][info[#info]].b = b

                        ElvUI_UF:Update_AllFrames()
                    end,
                    disabled = function()
                        local spell = GetSelectedSpell()
                        if not spell then return end
                        local selectedTable = GetSelectedFilters()
                        return not selectedTable[spell]['thresholdGroup'..i].enabled
                    end,
                },                    
                colorThreshold = {
                    name = "Color Threshold",
                    desc = L["At what point should the text be displayed. Set to -1 to disable."],
                    type = 'range',
                    order = 2,
                    min = 1, max = 60, step = 1,
                    get = function(info) 
                        local spell = GetSelectedSpell()
                        if not spell then return end
                        local selectedTable = GetSelectedFilters()      
                        return selectedTable[spell]['thresholdGroup'..i][info[#info]]
                    end,
                    set = function(info,value)
                        local spell = GetSelectedSpell()
                        if not spell then return end
                        local selectedTable = GetSelectedFilters()                                       
                        selectedTable[spell]['thresholdGroup'..i][info[#info]] = value     
                        ElvUI_UF:Update_AllFrames()
                    end,
                    disabled = function()
                        local spell = GetSelectedSpell()
                        if not spell then return end
                        local selectedTable = GetSelectedFilters()
                        return not selectedTable[spell]['thresholdGroup'..i].enabled
                    end,
                },
            },
        }   
    end
    E.Options.args.filters.args.mainOptions.args.buffIndicator.args.thresholdTimedColorsGroup.args = groups
end

local thresholdList = {}

local function AddColorThreshold()

end
local function RemoveColorThreshold()

end
local function AddFilterOptions()
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
            filterExtensionGroup = {
                order = 4,
                type = "group",
                name = "Color Thresholds",
                disabled = function(info) 
                    if  UF.db.filterExtension.enabled then
                        return false
                    end
                    return true
                end,
                args = {

                },
            },
		},
	}
end
tinsert(KYA.Config, InsertOptionsToElvUIFilterOptions)
tinsert(KYA.Config, AddFilterOptions)