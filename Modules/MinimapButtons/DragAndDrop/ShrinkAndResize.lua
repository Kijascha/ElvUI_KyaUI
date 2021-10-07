local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

if not MB.DragAndDrop then return end

function MB.DragAndDrop:ShrinkAndResize(frame, isDragging)

    if isDragging then
        frame.oldSize = frame:GetWidth();
        frame.oldIconSize = frame.icon:GetWidth();

        local scalingFactor = 0.8
        local newSize = frame.oldSize*scalingFactor;
        local newIconSize = frame.oldIconSize*scalingFactor;
        frame:SetSize(newSize,newSize);
        frame.icon:SetSize(newIconSize,newIconSize);
    else
        frame:SetSize(frame.oldSize,frame.oldSize);
        frame.icon:SetSize(frame.oldIconSize,frame.oldIconSize);
    end
end