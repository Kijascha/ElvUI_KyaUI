local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

if not MB.DragAndDrop then return end

function MB.DragAndDrop:Drop(frame)    
	frame:SetScript("OnUpdate", self.Scripts[frame])
	self.Scripts[frame] = nil
    
	if MB.DragAndDrop.Sticky[frame] then
        -- Save the sticky Frame in a temp variable
		local sticky = MB.DragAndDrop.Sticky[frame]
        -- Delete it in the table
		MB.DragAndDrop.Sticky[frame] = nil
        -- return the sticke Frame
		return true, sticky
	else
		return false, nil
	end
end