local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

local _G = _G
local GetCursorPosition = GetCursorPosition;
local pairs = pairs

if not MB.DragAndDrop then return end

function MB.DragAndDrop:Drag(frame, frameList, xoffset, yoffset, left, top, right, bottom)
    return function() 
		local x,y = GetCursorPosition()
		local s = frame:GetEffectiveScale()
		local sticky = nil

		x,y = x/s,y/s

		frame:ClearAllPoints()
		frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x+xoffset, y+yoffset)

		MB.DragAndDrop.Sticky[frame] = nil

        if frameList then
            for k,v in pairs(frameList) do
                if frame ~= v and frame ~= v:GetParent() and not IsShiftKeyDown() and v:IsVisible()  then 
                    if self:SnapToFrame(frame, v, left, top, right, bottom) then
                        --print("over allowed Frame: "..v:GetName())
                        MB.DragAndDrop.Sticky[frame] = v
                        break
                    end
                else                    
                    --print("over forbidden Frame: "..v:GetName())
                end
            end
        end
	end
end