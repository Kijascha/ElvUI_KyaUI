local KYA, E, L, V, P, G = unpack(select(2, ...))
local KYAL = KYA:NewModule("kyaUILayout", "AceHook-3.0", "AceEvent-3.0")
local LO = E:GetModule("Layout")

--Cache global variables
--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local GameTooltip = _G["GameTooltip"]
local PlaySound = PlaySound
local SOUNDKIT = SOUNDKIT
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function KYAL:LoadLayout()
	--Create extra panels
end
hooksecurefunc(LO, "Initialize", KYAL.LoadLayout)


function KYAL:Initialize()
	--Layout init goes in here
end

KYA:RegisterModule(KYAL:GetName())
