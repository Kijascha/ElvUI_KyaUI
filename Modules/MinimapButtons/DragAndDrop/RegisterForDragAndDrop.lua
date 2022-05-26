local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

if not MB.DragAndDrop then return end

local count = 1

function MB.DragAndDrop:RegisterForDragAndDrop(minimapButton)
    if not minimapButton then return end
    if not MB.DragAndDrop.RegisteredMinimapButtons then return end
    
    -- check if a LibDBIcon does already exist: - if not then proceed with the registration process
    if not MB.DragAndDrop.RegisteredMinimapButtons[minimapButton:GetName()] then 

        -- if not IsRegisteredForDragAndDrop or false then add to minimapButton and set IsRegisteredForDragAndDrop as true
        if not minimapButton.IsRegisteredForDragAndDrop then minimapButton.IsRegisteredForDragAndDrop = true end

        -- only for developing purposes
        if MB.DeveloperMode then
            print(count.." - "..minimapButton:GetName() .. " - "..tostring(minimapButton.IsRegisteredForDragAndDrop))
            count = count + 1
        end    
        -- store the minimapButton in the registered table
        MB.DragAndDrop.RegisteredMinimapButtons[minimapButton:GetName()] = minimapButton;
    end
end