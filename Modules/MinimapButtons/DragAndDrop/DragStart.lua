local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

if not MB.DragAndDrop then return end

function MB.DragAndDrop:DragStart(frame, frameList, left, right, top, bottom)

    -- Get Cursor Coordinates
	local x,y = GetCursorPosition()
    -- Get Center of the Moving Frame
	local aX,aY = frame:GetCenter()
    -- Get the effective Scale - because not every monitor display it the same way
	local aS = frame:GetEffectiveScale()

    -- set the frame's Center x/y to the scaled version -for more accuracy
	aX,aY = aX*aS,aY*aS

    -- Set the Offset X/Y to the difference between frame's X/Y and the cursorCoordinates
	local xoffset,yoffset = (aX - x),(aY - y)
    -- save the original Update Function in a table - for restoring later after dropping the frame
	self.Scripts[frame] = frame:GetScript("OnUpdate")
    -- Set a new UpdateFunction for handling the drag
	frame:SetScript("OnUpdate", self:Drag(frame, frameList, xoffset, yoffset, left, top, right, bottom))
end