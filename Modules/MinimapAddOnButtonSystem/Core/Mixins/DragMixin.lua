local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MABS = KYA:GetModule('MinimapAddOnButtonSystem');

local DragMixin = {}

local DragCache = {
    Actions = {},
    Scripts = {},
}

local function cacheContains(cache, actionID)
    if cache[actionID] ~= nil then return true end
    return false
end
local function ClearDragCache(actionID)
    --tContains(table, value)
    -- if actionID is in the actions table and therefor valid then clear cache
    if cacheContains(MABS.Actions, actionID) then
        DragCache.Actions[actionID] = nil
        DragCache.Scripts[actionID] = nil
    end
end
local function PickupButton(action)

    -- Store original Button
    DragCache.Actions[action] = action;
    
    --[[
        TODO: 
            - remove button from slot
            - set cursor to the button's icon
            - hide button.
    ]]

    if frame.Icon then
        SetCursor(frame.Icon:GetTexture());
    end

    --DragCache.Scripts[frame] = frame:GetScript("OnUpdate");
    --frame:SetScript("OnUpdate", frame.OnDrag)
end
local function PlaceButton(frame)
    --frame:SetScript("OnUpdate", DragCache.Scripts[frame])
    --DragCache.Scripts[frame] = nil;    

    --[[ 
        TODO:
            - Check if the slot has already an action
                - if yes - swap action
                - if no - place action
    ]]

    SetCursor(nil);
    DragCache.Actions[frame] = nil;
end

DragMixin.isDragging = false;
function DragMixin:OnDrag()
    if self.isDragging then
    
    end
end
function DragMixin:OnDragStart()
    self.isDragging = true;
    PickupButton(self);
end
function DragMixin:OnDragEnd()
    self.isDragging = false;
    PlaceButton(self);
end



--[[ Store Mixin in the Mixins table ]]
MABS.Mixins.DragMixin = DragMixin;