local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

local _G = _G
local GetCursorPosition = GetCursorPosition;
local pairs = pairs

if not MB.DragAndDrop then return end

function MB.DragAndDrop:SnapToFrame(frameA, frameB, left, top, right, bottom)

    
	local sA, sB = frameA:GetEffectiveScale(), frameB:GetEffectiveScale()
	local xA, yA = frameA:GetCenter() -- Center Frame A
	local xB, yB = frameB:GetCenter() -- Center Frame B
	local hA, hB = frameA:GetHeight() / 2, ((frameB:GetHeight() * sB) / sA) / 2
	local wA, wB = frameA:GetWidth() / 2, ((frameB:GetWidth() * sB) / sA) / 2

	local newX, newY = xA, yA

	if not left then left = 0 end
	if not top then top = 0 end
	if not right then right = 0 end
	if not bottom then bottom = 0 end

	-- Lets translate B's coords into A's scale
	if not xB or not yB or not sB or not sA or not sB then return end
	xB, yB = (xB*sB) / sA, (yB*sB) / sA
    
    local stickyAx, stickyAy = wA * 0.75, hA * 0.75
	local stickyBx, stickyBy = wB * 0.75, hB * 0.75

	-- Grab the edges of each frame, for easier comparison

	local lA, tA, rA, bA = frameA:GetLeft(), frameA:GetTop(), frameA:GetRight(), frameA:GetBottom()
	local lB, tB, rB, bB = frameB:GetLeft(), frameB:GetTop(), frameB:GetRight(), frameB:GetBottom()
	local snap = nil
    
    -- Translate into A's scale
	lB, tB, rB, bB = (lB * sB) / sA, (tB * sB) / sA, (rB * sB) / sA, (bB * sB) / sA

    --- Comparison between both frames
    -- if bottomA is between bottomB and topB and leftA is between leftB and rightB
    
    if (bA <= tB and bA >= bB) and (lA <= rB and lA >= lB) then
        --print(string.format("bottomA: %d <= topB: %d and bottomA: %d >= bottomB: %d", bA, tB, bA, bB))
        --print(string.format("leftA: %d <= rightB: %d and leftA: %d >= leftB: %d", lA, rB, lA, lB))
        snap = true;

        
    end

    -- Zu tun: Den Größeren Bereich, auf dem FrameA überlappt, herausfinden
    local isOverBottomLeft  = (xA >= lB and xA <= xB) and (yA >= bB and yA <= yB);
    local isOverTopLeft     = (xA >= lB and xA <= xB) and (yA >= yB and yA <= tB);
    local isOverTopRight    = (xA >= xB and xA <= rB) and (yA >= yB and yA <= tB);
    local isOverBottomRight = (xA >= xB and xA <= rB) and (yA >= yB and yA <= tB);

    -- FrameA is over BOTTOMLEFT of FrameB
    if isOverBottomLeft then
        print(string.format("%s is over BOTTOMLEFT of %s", frameA:GetName(), frameB:GetName()))  
        snap = true;     
    -- FrameA is over TOPLEFT of FrameB
    elseif isOverTopLeft then
        print(string.format("%s is over TOPLEFT of %s", frameA:GetName(), frameB:GetName()))
        snap = true;
    -- FrameA is over TOPRIGHT of FrameB
    elseif isOverTopRight then
        print(string.format("%s is over TOPRIGHT of %s", frameA:GetName(), frameB:GetName()))
        snap = true;
    -- FrameA is over BOTTOMRIGHT of FrameB
    elseif isOverBottomRight then
        print(string.format("%s is over BOTTOMRIGHT of %s", frameA:GetName(), frameB:GetName()))
        snap = true;
    end
    
    if isOverBottomLeft or isOverTopLeft or isOverTopRight or isOverBottomRight then
        print(string.format("%s is over %s", frameA:GetName(), frameB:GetName()))
        newX = xA
        newY = yA
        snap = true;
    end
    --- ---------------
    if snap then
		frameA:ClearAllPoints()
		frameA:SetPoint("CENTER", E.UIParent, "BOTTOMLEFT", newX, newY)
		return true
	end
end