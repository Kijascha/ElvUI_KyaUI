local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MABS = KYA:GetModule('MinimapAddOnButtonSystem');

local MouseEventMixin = {}

--[[ PRIVATE class members ]]
local hasMouseFocus = false


--[[ PUBLIC class members ]]
function MouseEventMixin:HasMouseFocus() -- returns wether the mouse is entering the frame or leaving the frame
    return hasMouseFocus;
end
function MouseEventMixin:OnMouseEnter()
    hasMouseFocus = true;
    --[[
        TODO: 
            - Handle basic or custom MouseEnter stuff here
    ]]
end
function MouseEventMixin:OnMouseLeave()
    hasMouseFocus = false;
    --[[
        TODO: 
            - Handle basic or custom MouseLeave stuff here
    ]]
end



--[[ Store Mixin in the Mixins table ]]
MABS.Mixins.MouseEventMixin = MouseEventMixin