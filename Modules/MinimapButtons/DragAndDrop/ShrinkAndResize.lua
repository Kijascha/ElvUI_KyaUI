local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

if not MB.DragAndDrop then return end

function MB.DragAndDrop:ShrinkAndResize(frame, isDragging)
    if isDragging then
        frame.oldWidth = frame:GetWidth();
        frame.oldHeight = frame:GetHeight();
        frame.oldIconWidth = frame.icon:GetWidth();
        frame.oldIconHeight = frame.icon:GetWidth();
        local scalingFactor = 0.8
        frame:SetSize(frame.oldWidth*scalingFactor,frame.oldHeight*scalingFactor);
        frame.icon:SetSize(frame.oldIconWidth*scalingFactor,frame.oldIconHeight*scalingFactor);
    else
        frame:SetSize(frame.oldWidth,frame.oldHeight);
        frame.icon:SetSize(frame.oldIconWidth,frame.oldIconHeight);
    end
end