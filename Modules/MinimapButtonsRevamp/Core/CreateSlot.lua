local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MBR = KYA:GetModule('MinimapButtonsRevamp');


function MBR.Mixins.LibDBSlotMixin:OnInitialized()
    print(self:GetName().. " fired from OnInit")
end
function MBR.Mixins.LibDBSlotMixin:OnLoad()
    print(self:GetName().. " fired from OnLoad")

end
function MBR.Mixins.LibDBSlotMixin:OnEvent(event, ...)
    print(event.. " fired from OnEvent")
end
function MBR.Mixins.LibDBSlotMixin:OnEnter()
    print(self:GetName().. " fired from OnEnter")
end
function MBR.Mixins.LibDBSlotMixin:OnLeave()
    print(self:GetName().. " fired from OnLeave")
end
function MBR.Mixins.LibDBSlotMixin:OnReceiveDrag(obj)
    local cursorInfo = GetCursorInfo();

    print(self:GetName())
    if obj then
        print(type(obj))
    end
    
    for k,v in pairs(cursorInfo) do print(tostring(k).." - "..tostring(v)) end
end

function MBR.Mixins.LibDBSlotMixin:CleanSlot()
    self.Button = nil;
end

function MBR:CreateSlot(bar, slotID)
    
    local borderThickness = 1
	local spacing = 2
	local size = 36

    local slot = CreateFrame("Button","LibDBSlot"..slotID, bar, "BackdropTemplate");
    slot = Mixin(slot, MBR.Mixins.LibDBSlotMixin)
    
    slot:SetTemplate("Transparent")
    slot:SetFrameLevel(15);
    slot:SetFrameStrata(bar:GetFrameStrata());
    slot:SetBackdropBorderColor(0,0,0,1);
    slot:SetBackdropColor(0,0,0,.5);
    slot:Size(size,size);

    if slotID == 1 then
        local firstSpacing = (1 + spacing)
        slot:SetPoint("LEFT", bar, "LEFT", firstSpacing, 0);
    elseif _G["LibDBSlot"..slotID-1] then
        slot:Point("LEFT", "LibDBSlot"..slotID-1, "RIGHT", spacing, 0);
    end

    slot.ID = slotID;
    slot.Button = nil;
    slot.HasButton = function() 
        if not slot.Button then return false end
        return true;
    end;
    slot:SetScript("OnReceiveDrag", slot.OnReceiveDrag);
    slot:SetScript("OnLoad", slot.OnLoad);
    slot:SetScript("OnEnter", slot.OnEnter);
    slot:SetScript("OnLeave", slot.OnLeave);
    
    slot:HookScript("OnEnter", function(self)
        if not self:HasButton() then
            self:SetBackdropColor(36/255,36/255,36/255,.5);
        end
    end)
    slot:HookScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0,0,0,1);
        self:SetBackdropColor(0,0,0,.5);
    end)
    return slot;
end