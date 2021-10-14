local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

if not MB.Bars then return end

MB.Bars.DB = {}

function MB.Bars.DB:SaveLayout(barName, buttonLayout)
    if not MB.db.bars[barName] then MB.db.bars[barName] = {} end -- this implementation might to be changed
    if not MB.db.bars[barName].Buttons then MB.db.bars[barName].Buttons = {} end -- this implementation might to be changed

    -- Grab current button setup
    local currentButtonLayout = buttonLayout;
    local savedButtonLayout =  {};

    for i = 1, #currentButtonLayout do 
        if not currentButtonLayout[i].isEmpty then
            local set = {					
                SlotID = i,
                SlotName = currentButtonLayout[i]:GetName(),
                IsEmpty = currentButtonLayout[i].isEmpty,
                MinimapButton = currentButtonLayout[i].MinimapButton.Name,

            }
            print("Slot: ".. set.SlotName .. " - IsEmpty: " .. tostring(set.IsEmpty) .. " - " .. tostring(set.MinimapButton))
            savedButtonLayout[i] = set;
        end
    end
    MB.db.bars[barName].Buttons = savedButtonLayout;
end
function MB.Bars.DB:LoadLayout(barName)
    if not MB.db.bars[barName] then return end 
        
    if MB.db.bars[barName].Buttons then
        return MB.db.bars[barName].Buttons;
    end
    return nil;
end
    