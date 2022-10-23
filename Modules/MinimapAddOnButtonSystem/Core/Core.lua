local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MABS = KYA:GetModule('MinimapAddOnButtonSystem');

--[[ Mixins table ]]
MABS.Mixins = {}

--[[ DragData and DragCache for holding temporary minimap button data while being dragged ]]
MABS.DragData = {}
MABS.DragCache = {}

MABS.Actions = {}