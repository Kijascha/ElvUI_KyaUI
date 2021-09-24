local E, L, V, P, G = unpack(ElvUI)
local EP = LibStub('LibElvUIPlugin-1.0')
local addon, Engine = ...

local KYA = E.Libs.AceAddon:NewAddon(addon, 'AceConsole-3.0', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
local locale = (E.global.general.locale and E.global.general.locale ~= "auto") and E.global.general.locale or GetLocale()
local L = E.Libs.ACL:GetLocale('ElvUI', locale)
KYA.Libs = E.Libs
-- Cache global variables
-- Lua functions
local _G = _G
local pairs = pairs
local format = format
-- WoW API / Variables
-- GLOBALS:

--Setting up table to unpack.
Engine[1] = KYA
Engine[2] = E
Engine[3] = L
Engine[4] = V
Engine[5] = P
Engine[6] = G
_G[addon] = Engine

KYA.Config = {}
KYA.RegisteredModules = {}
KYA.Eversion = tonumber(E.version)
KYA.Erelease = tonumber(GetAddOnMetadata("ElvUI_KyaUI", "X-ElvuiVersion"))

do
	E:AddLib('LDI', 'LibDBIcon-1.0')
end

KYA.MicroBar = KYA:NewModule('MicroBar','AceHook-3.0','AceEvent-3.0')
KYA.MinimapButtons = KYA:NewModule('MinimapButtons','AceEvent-3.0','AceHook-3.0','AceTimer-3.0')
KYA.UnitFrames = KYA:NewModule('UnitFrames','AceTimer-3.0','AceEvent-3.0','AceHook-3.0')
KYA.DataBars = KYA:NewModule('DataBars','AceEvent-3.0')

function KYA:AddOptions() -- function added in Core\Config.lua
	for _, func in ipairs(KYA.Config) do
		func()
	end
end

-- Register own Modules
function KYA:RegisterModule(name)
	if self.initialized then
		local module = self:GetModule(name)
		if (module and module.Initialize) then
			module:Initialize()
		end
	else
		self["RegisteredModules"][#self["RegisteredModules"] + 1] = name
	end
end

function KYA:GetRegisteredModules()
	return self["RegisteredModules"]
end

function KYA:InitializeModules()
	for _, moduleName in pairs(KYA["RegisteredModules"]) do
		local module = self:GetModule(moduleName)
		if module.Initialize then
			module:Initialize()
		end
	end
end

function KYA:Init()
	self.initialized = true
	
	self:Initialize()
	self:InitializeModules()
	EP:RegisterPlugin(addon, self.AddOptions)
end

E.Libs.EP:HookInitialize(KYA, KYA.Init)