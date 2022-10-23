local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MABS = KYA:GetModule('MinimapAddOnButtonSystem');
--[[ Initialize Module ]]
function MABS:Initialize()
    -- set DeveloperMode
    self.DeveloperMode = false;

    
    self.Initialized = true
end

-- [[ Register Module ]]
KYA:RegisterModule(MABS:GetName())