local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MicroBar')
local ElvMB = E:GetModule('ActionBars')

local _G = _G
local pairs = pairs
local assert = assert
local unpack = unpack
local CreateFrame = CreateFrame
local C_StorePublic_IsEnMBled = C_StorePublic.IsEnabled
local UpdateMicroButtonsParent = UpdateMicroButtonsParent
local GetCurrentRegionName = GetCurrentRegionName
local RegisterStateDriver = RegisterStateDriver
local InCombatLockdown = InCombatLockdown
local UnitSex = UnitSex
local GetNetStats = GetNetStats
local GetSpecialization = GetSpecialization

-- UTILS
if not MB.Utils then MB.Utils = {} end

MB.Utils.Colors = {}
MB.Utils.Colors.Base = CreateColor(1, 1, 1, 1)
MB.Utils.Colors.Class = E:ClassColor(E.myclass, true)
MB.Utils.Colors.Hover = { r = MB.Utils.Colors.Class.r, g = MB.Utils.Colors.Class.g, b = MB.Utils.Colors.Class.b }
MB.Utils.Colors.Status = {
	'|cff0CD809',
	'|cffE8DA0F',
	'|cffFF9000',
	'|cffD80909'
} 
MB.Utils.Colors.GradientPacks = {}
MB.Utils.Colors.GradientPacks.Normal = {
	From = CreateColor(.5 * MB.Utils.Colors.Base.r, .5 * MB.Utils.Colors.Base.b, .5 * MB.Utils.Colors.Base.b, .9),
	To = CreateColor(1 * MB.Utils.Colors.Base.r, 1 * MB.Utils.Colors.Base.g, 1 * MB.Utils.Colors.Base.b, .9)
}
MB.Utils.Colors.GradientPacks.Highlight = {
	From = CreateColor(.5 * MB.Utils.Colors.Hover.r, .5 * MB.Utils.Colors.Hover.b, .5 * MB.Utils.Colors.Hover.b, .9),
	To = CreateColor(1 * MB.Utils.Colors.Hover.r, 1 * MB.Utils.Colors.Hover.g, 1 * MB.Utils.Colors.Hover.b, .9)
}
MB.Utils.Colors.GradientPacks.Pushed = {
	From = CreateColor(1 * MB.Utils.Colors.Hover.r, 1 * MB.Utils.Colors.Hover.g, 1 * MB.Utils.Colors.Hover.b, .9),
	To = CreateColor(.5 * MB.Utils.Colors.Hover.r, .5 * MB.Utils.Colors.Hover.g, .5 * MB.Utils.Colors.Hover.b, .9)
}
MB.Utils.Colors.GradientPacks.Disabled = {
	From = CreateColor(.2 * MB.Utils.Colors.Base.r, .2 * MB.Utils.Colors.Base.g, .2 * MB.Utils.Colors.Base.b, .9),
	To = CreateColor(.7 * MB.Utils.Colors.Base.r, .7 * MB.Utils.Colors.Base.g, .7 * MB.Utils.Colors.Base.b, .9)
}

MB.Utils.GenderCodes = { uni = 1, male = 2, female = 3}

MB.Utils.PerformanceStrings = {}
MB.Utils.PerformanceStrings.Bandwidth = 'Down: %.3f Mbps / Up: %.3f Mbps'
MB.Utils.PerformanceStrings.Percentage = '%.2f%%'
MB.Utils.PerformanceStrings.HomeLatency = '%d ms'
MB.Utils.PerformanceStrings.KiloByte = '%d KB'
MB.Utils.PerformanceStrings.MegaByte = '%.2f MB'
MB.Utils.PerformanceStrings.FPS = '%d f/s'

function MB.Utils:GetMicroBarIcon(IconName)
	local IconPath = "Interface\\AddOns\\ElvUI_KyaUI\\Media\\Textures\\Icons\\MicroBar\\"
	local ending = ".tga"
	return (IconPath..IconName..ending);
end

function MB.Utils:ExpandTooltip(tooltip,button)
	if button.Name == "MainMenuMicroButton" then
		local down, up, lagHome, lagWorld = GetNetStats();
		tooltip:AddLine(format("Current Bandwith: %d KB/s / %d KB/s", down,up), 1, 1, 1, 1)
	end
	return tooltip
end

local currentTalentSpecialization = nil;
function MB.Utils:GetCurrentTalentSpecialization()
    return currentTalentSpecialization or GetSpecialization();
end
function MB.Utils.UpdateCurrentTalentSpecialization(activeSpec)
    currentTalentSpecialization = activeSpec;
end