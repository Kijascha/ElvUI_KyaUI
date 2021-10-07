local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

if not MB.DragAndDrop then return end

function MB.DragAndDrop:ShrinkAndResize(frame, isDragging)
    frame.oldWidth = frame:GetWidth();
    frame.oldHeight = frame:GetHeight();
    frame.oldIconWidth = frame.icon:GetWidth();
    frame.oldIconHeight = frame.icon:GetWidth();
    print(frame.oldWidth)

    frame:SetSize(frame.oldWidth,frame.oldHeight);
    frame.icon:SetSize(frame.oldIconWidth,frame.oldIconHeight);

    if isDragging then
        local scalingFactor = 0.8
        local newSize = frame.oldWidth*scalingFactor;
        print(newSize)
        frame:SetSize(newSize,newSize);
        frame.icon:SetSize(frame.oldIconWidth*scalingFactor,frame.oldIconHeight*scalingFactor);
    end
end