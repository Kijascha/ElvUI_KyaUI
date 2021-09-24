local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

-- Init Drag And Drop Class
MB.DragAndDrop = {};

MB.DragAndDrop.Scripts = MB.DragAndDrop.Scripts or {};
MB.DragAndDrop.RangeX = 15;
MB.DragAndDrop.RangeY = 15;
MB.DragAndDrop.Sticky = MB.DragAndDrop.Sticky or {};
