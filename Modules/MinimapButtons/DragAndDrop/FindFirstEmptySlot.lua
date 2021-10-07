local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

if not MB.DragAndDrop then return end

function MB.DragAndDrop:FindFirstEmptySlot(frame)
    if not frame:GetName() == "KyaUI_ButtonGrid" then return end

    local slot = nil;
    
    for i = 1, #frame.Buttons do
        if frame.Buttons[i].isEmpty then 
            slot = frame.Buttons[i];
            break;
        end
    end    
    
    return slot;
end