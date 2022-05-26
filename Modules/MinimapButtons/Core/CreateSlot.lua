local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons')

if not MB.Core then MB.Core = {} end

function MB.Core:CreateSlot(bar, slotNumber)	
    if not MB.db then return end
    if not bar then return end
    if not bar.Buttons then bar.Buttons = {} end

    bar.Buttons[slotNumber] = CreateFrame("Button",bar:GetName().."Slot"..slotNumber,bar,"BackdropTemplate");
    bar.Buttons[slotNumber]:SetTemplate("Transparent")
    bar.Buttons[slotNumber]:SetPoint('LEFT',bar, 0,0)	
    bar.Buttons[slotNumber]:SetSize(MB.db.bars.defaultSize or 32,MB.db.bars.defaultSize or 32)
    bar.Buttons[slotNumber]:SetFrameStrata(bar:GetFrameStrata())	
    bar.Buttons[slotNumber]:SetFrameLevel(bar:GetFrameLevel() + 5)
    bar.Buttons[slotNumber]:Show()
    bar.Buttons[slotNumber].isShown = false
    bar.Buttons[slotNumber].isMouseEnter = false	
    bar.Buttons[slotNumber].isMouseLeave = false	
    bar.Buttons[slotNumber].isMouseUp = false
    bar.Buttons[slotNumber].isMouseDown = false
    bar.Buttons[slotNumber].isEmpty = true
    bar.Buttons[slotNumber].MinimapButton = nil;
    bar.Buttons[slotNumber].tooltipText = ''
end