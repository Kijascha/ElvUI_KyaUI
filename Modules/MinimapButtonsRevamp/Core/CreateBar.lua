local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MBR = KYA:GetModule('MinimapButtonsRevamp');


function MBR:CreateBar(barName, events, mixin)
	local frame = CreateFrame("Frame", barName, E.UIParent, "BackdropTemplate")
    
    if events and type(events) == "table" then
        for k,v in ipairs(events) do
            frame:RegisterEvent(v);
        end
    end

    frame = Mixin(frame, mixin);

	frame:SetScript("OnEvent", function(self,event,...)        
        if event == "ADDON_LOADED" then 
            frame:OnLoad(self);
        else
            frame:OnEvent(event,...);
        end
    end);
	return frame;
end