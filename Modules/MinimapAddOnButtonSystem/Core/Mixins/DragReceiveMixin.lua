local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MABS = KYA:GetModule('MinimapAddOnButtonSystem');

local DragReceiveMixin = {}

--[[ PRIVATE class members ]]
local receivedDrag = false

--[[ PUBLIC class members ]]
function DragReceiveMixin:HasReceivedDrag()
    return receivedDrag
end
function DragReceiveMixin:SetReceivedDrag(hasReceivedDrag)
    if not (type(hasReceivedDrag) == "boolean") then error("The parameter 'hasReceivedDrag' has to be of type boolean!"); end
    receivedDrag = hasReceivedDrag;
end
function DragReceiveMixin:OnReceiveDrag()    
    self:SetReceivedDrag(true)
end

--[[ Store Mixin in the Mixins table ]]
MABS.Mixins.DragReceiveMixin = DragReceiveMixin