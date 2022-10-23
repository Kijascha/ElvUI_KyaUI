local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MBR = KYA:GetModule('MinimapButtonsRevamp');

local function GetMinimapButtonSlotById(id)
    if not MBR.QuickAccessBar then return end
    if not MBR.QuickAccessBar.Slots then return end

    local slotCount = #MBR.QuickAccessBar.Slots 

    for i, slot in ipairs(MBR.QuickAccessBar.Slots) do
        if i == id then
            return slot;
        end
    end
    return nil;
end
function MBR.PickupMinimapButton(minimapButtonSlot)
     
    button = Mixin(button, MBR.SlotInfoMixin)


end