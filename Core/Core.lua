local KYA, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM

-- Cache global variables
-- Lua functions
local _G = _G
local format = string.format
local print, pairs = print, pairs
local tinsert = table.insert
-- WoW API / Variables
local GetAddOnMetadata = GetAddOnMetadata
local GetAddOnEnableState = GetAddOnEnableState
local DisableAddOn = DisableAddOn
local EnableAddOn = EnableAddOn
local GetAddOnInfo = GetAddOnInfo
local ReloadUI = ReloadUI
local SetCVar = SetCVar

-- GLOBALS: ElvDB, hooksecurefunc, BINDING_HEADER_KYA
-- GLOBALS: KYAData, KYADataPerChar, ElvDB

KYA["styling"] = {}
KYA.AddonProfileKey = 'KyaUI_Details_V1';

KYA.Logo = [[Interface\AddOns\ElvUI_KyaUI\Media\Logo\KyaUI.tga]]
KYA.Title = GetAddOnMetadata("ElvUI_KyaUI", "Title")
KYA.Version = tonumber(GetAddOnMetadata("ElvUI_KyaUI", "Version"))
BINDING_HEADER_KYA = KYA.Title

KYA.profileStrings = {
	[1] = L['Successfully created and applied profile(s) for |cffffff00%s|r'],
	[2] = L['|cffffff00%s|r profile for this character already exists. Aborting.'],
}

function KYA:IsAddOnEnabled(addon) -- Credit: Azilroka
	return GetAddOnEnableState(E.myname, addon) == 2
end

-- AskForOther AddOns
KYA.AS = KYA:IsAddOnEnabled("AddOnSkins")
KYA.BAG = KYA:IsAddOnEnabled("Bagnon")
KYA.BUI = KYA:IsAddOnEnabled("ElvUI_BenikUI")
KYA.BS = KYA:IsAddOnEnabled("BugSack")
KYA.MUI = KYA:IsAddOnEnabled("ElvUI_MerathilisUI")
KYA.WT = KYA:IsAddOnEnabled("ElvUI_WindTools")
KYA.NP = KYA:IsAddOnEnabled("NeatPlates")
KYA.MRT = KYA:IsAddOnEnabled("MRT")

local function PrintURL(url) -- Credit: Azilroka
	return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

--[[
	TODO:
		- add my own pre-defined color functions for various cases
]]
function KYA:cOption(name)
	local color = "|cffff7d0a%s |r"
	return (color):format(name)
end

function KYA:OpenOptions()
	E:ToggleOptionsUI(); LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "kyaui")
end

function KYA:LoadCommands()
	self:RegisterChatCommand("kyaui", "OpenOptions")
	self:RegisterChatCommand('kyauierror', 'LuaError')
end


function KYA:AddMoverCategories()
	tinsert(E.ConfigModeLayouts, #(E.ConfigModeLayouts) + 1, "KYAUI")
	E.ConfigModeLocalizedStrings["KYAUI"] = KYA.Title
end

function KYA:IsAddOnEnabled(addon) -- Credit: Azilroka
	return GetAddOnEnableState(E.myname, addon) == 2
end
function KYA:Print(...)
	(_G.DEFAULT_CHAT_FRAME):AddMessage(strjoin('', '|cff00c0fa', 'KyaUI:|r ', ...))
end
do	--Update font/texture paths when they are registered by the addon providing them
	--This helps fix most of the issues with fonts or textures reverting to default because the addon providing them is loading after ElvUI.
	--We use a wrapper to avoid errors in :UpdateMedia because 'self' is passed to the function with a value other than ElvUI.
	local function LSMCallback() E:UpdateMedia() end
	LSM.RegisterCallback(E, 'LibSharedMedia_Registered', LSMCallback)
end

function KYA:Initialize()

	-- ElvUI versions check
	if KYA.Eversion < KYA.Erelease then
		E:StaticPopup_Show("VERSION_MISMATCH")
		return -- If ElvUI Version is outdated stop right here. So things don't get broken.
	end

	-- Create empty saved vars if they doesn't exist
	if not KYAData then
		KYAData = {}
	end

	if not KYADataPerChar then
		KYADataPerChar = {}
	end

	hooksecurefunc(E, "PLAYER_ENTERING_WORLD", function(self, _, initLogin)
		if initLogin or not ElvDB.KYAErrorDisabledAddOns then
			ElvDB.KYAErrorDisabledAddOns = {}
		end
	end)

	--E:Delay(6, function() KYA:CheckVersion() end)

	-- run the setup again when a profile gets deleted.
	local profileKey = ElvDB.profileKeys[E.myname.." - "..E.myrealm]
	if ElvDB.profileKeys and profileKey == nil then
		E:GetModule("PluginInstaller"):Queue(KYA.installTable)
	end

	if E.db.kyaui.installed and E.db.kyaui.general.LoginMsg then
		print(KYA.Title..format(" v|cff00c0fa%s|r", KYA.Version)..L[" is loaded."])
	end

	-- run install when ElvUI install finishes
	if E.private.install_complete == E.version and E.db.kyaui.installed == nil then
		E:GetModule("PluginInstaller"):Queue(KYA.installTable)
	end
	
	-- Details
	if KYA:IsAddOnEnabled('Details') then
		KYA:LoadDetailsProfile()
	end
	-- AddOnSkins
	if KYA.AS then
		KYA:LoadAddOnSkinsProfile()
	end
end
