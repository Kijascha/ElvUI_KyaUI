local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = KYA:GetModule('UnitFrames')
local ElvUI_UF = E:GetModule('UnitFrames')
local _G = _G
local select, type, unpack, assert, tostring = select, type, unpack, assert, tostring
local min, pairs, ipairs, tinsert, strsub = min, pairs, ipairs, tinsert, strsub
local strfind, gsub, format = strfind, gsub, format

UF.Filters = {}
function UF:ToggleExtendedOptions()
	if not UF.db then return end
	if UF.Initialized then
		if UF.db.filterExtension.enabled == true then
		else
		end
	end
end
function UF:Initialize()
	UF.db = E.db.kyaui

	UF.Initialized = true
	UF.Enabled = false

	UF.Filters.quickSearchText = ''
	UF.Filters.selectedFilter = nil
	UF.Filters.selectedSpell = nil
	UF.Filters.selectedStyle = nil
	UF.Filters.spellName = nil
	UF.Filters.filterList = {}
	UF.Filters.spellList = {}
	
	UF.Filters.isStatic = true;

	--[[for k,v in pairs(ElvUI_UF) do
		
		print(tostring(k))
	end
	table.foreach(ElvUF.objects, function(k,v)	
		if v.AuraWatch then
			table.foreach(v.AuraWatch, function(i,t)
					v.AuraWatch.PostUpdateIcon = UF.BuffIndicator_PostUpdateIcon
					v.AuraWatch.PostCreateIcon = UF.BuffIndicator_PostCreateIcon
			end)
		end
	end)]]
	ElvUI_UF.BuffIndicator_PostUpdateIcon = UF.BuffIndicator_PostUpdateIcon
	ElvUI_UF.BuffIndicator_PostCreateIcon = UF.BuffIndicator_PostCreateIcon
end
KYA:RegisterModule(UF:GetName())

