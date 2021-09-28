local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

if not MB.DragAndDrop then return end

function MB.DragAndDrop:AttachToSlot(frame, slot)
	local xA,yA = frame:GetCenter();
    local xS,yS = slot:GetCenter();
	local parent = frame:GetParent() or UIParent;
	local xP,yP = parent:GetCenter();
	local sA,sP,sS = frame:GetEffectiveScale(), parent:GetEffectiveScale(), slot:GetEffectiveScale();

	--xP,yP = (xP*sP) / sA, (yP*sP) / sA
    xS,yS = (xS*sS) / sA, (yS*sS) / sA;
	--local xo,yo = (xP - xA)*-1, (yP - yA)*-1
	local xo,yo = (xS - xA)*-1, (yS - yA)*-1;

	frame:ClearAllPoints();
    frame:SetParent(slot);
    frame:SetPoint("CENTER",slot,"CENTER",0, 0);
end