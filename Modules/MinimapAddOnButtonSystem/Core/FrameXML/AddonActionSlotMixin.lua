local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MABS = KYA:GetModule('MinimapAddOnButtonSystem');

-- Mix the basic functional mixins into one mixin
AddonActionSlotMixin = CreateFromMixins({}, MABS.Mixins.MouseEventMixin, MABS.Mixins.DragReceiveMixin);

--[[
    TODO:
        - Add specific methods/variables related to AddonActionSlots here
]]
function AddonActionSlotMixin:OnLoad() 
    -- init button stuff when button is loaded
    print(self:GetName().." is loaded.")
    self:SetTemplate("Transparent");
end
function AddonActionSlotMixin:OnEvent(event,...) 
    -- init button stuff when button is loaded
    print(self:GetName().." got an event message.")
end