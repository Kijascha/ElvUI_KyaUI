local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MBR = KYA:GetModule('MinimapButtonsRevamp');

--[[
    Setup Variables, Flags and Constants
]]
MBR.Constants = {
    NUM_QUICKACCESS_SLOTS = 5,
    NUM_BUTTONBAG_SLOTS = 20,
    MINIMAP_BUTTON_SLOTTYPE = 12679, -- experimenting with a custom id instead of a simple 1,2,3,... etc
    MINIMAP_BUTTON_SLOTTYPE2 = "MinimapActionSlot",
    MINIMAP_BUTTON_TYPE = { -- Define all allowed buttonTypes that are allowed to place on the actionBar
                            -- Currently working with simple ids instead of the actual name - just for testing purposes
        LibDBIcon                   = 1,
        MailButton                  = 2,
        LFRQueueButton              = 3,
        TrackingButton              = 4,
        GarrisonButton              = 5,
        OrderHallButton             = 6,
        CovenantButton              = 7,
        InstanceDifficultyButton    = 8,
    },
}
MBR.Flags = {
    Slot = {
        EMPTY = false,
        FULL = true 
    },
    
}
MBR.BarTypes = {
    Bar = "minimapActionBar",
    Grid = "minimapActionGrid",
}
MBR.CursorStates =  {
    Enter       = 1,
    Leave       = 2,
    Down        = 3,
    Up          = 4,
    Clicked     = 5,
    DragStart   = 6,
    DragEnd     = 7,
}
--[[
    Initiate Mixins
]]
MBR.Mixins = {}
MBR.Mixins.LibDBSlotMixin = {};
MBR.Mixins.LibDBButtonMixin = {};
MBR.Mixins.LibDBQuickAccessBarMixin = {};
MBR.Mixins.LibDBButtonBagMixin = {};

MBR.RegisteredSlots = {}

MBR.DraggableButtons = {}

-- [[ Minimap LDBIcon Slot ]]
MBR.LibDBSlotMixin = {}
-- [[ Minimap LDBIcon Button ]]
MBR.LibDBButtonMixin = {}

-- [[ Minimap LDBIcon Bar ]]
MBR.LibDBQuickAccessBar = {}
MBR.LibDBQuickAccessBarMixin = {}

-- [[ Minimap LDBIcon Bag ]]
MBR.LibDBButtonBag = {}
MBR.LibDBButtonBagMixin = {}

function MBR.RegisterSlot(slot)
    if not tContains(self.RegisteredSlots, slot) then
        tinsert(self.RegisteredSlots, slot); -- only register button if it is not already registered
        return true;
    end
    return false;
end
function MBR.UnregisterSlot(button)
    if  tContains(self.RegisteredSlots, slot) then
        tremove(self.RegisteredSlots, slot); -- only unregister button if it is registered
        return true;
    end
    return false;
end
function MBR.UnregisterAllSlots() -- unregister all buttons
    if self.RegisteredSlots and #self.RegisteredSlots > 0 then
        for index, slot in ipairs(self.RegisteredSlots) do
            tremove(self.RegisteredSlots, slot);
        end
        return true;
    end
    return false;
end
function MBR:GetNumRegisteredSlots()
    return #self.RegisteredSlots;
end

function MBR.RegisterButtonForDrag(button)
    if not tContains(self.DraggableButtons, button) then
        tinsert(self.DraggableButtons, button); -- only register button if it is not already registered
        return true;
    end
    return false;
end
function MBR.UnregisterButtonForDrag(button)
    if  tContains(self.DraggableButtons, button) then
        tremove(self.DraggableButtons, button); -- only unregister button if it is registered
        return true;
    end
    return false;
end
function MBR.UnregisterAllButtonsForDrag() -- unregister all buttons
    if self.DraggableButtons and #self.DraggableButtons > 0 then
        for index, button in ipairs(self.DraggableButtons) do
            tremove(self.DraggableButtons, button);
        end
        return true;
    end
    return false;
end
