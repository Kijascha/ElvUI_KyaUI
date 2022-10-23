local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MBR = KYA:GetModule('MinimapButtonsRevamp');

function MBR:CreateBagLayout()
    local numOfSlots =  self.Constants.NUM_BUTTONBAG_SLOTS;
    local rows = 2
    local slotSize = 36
    local slotPaddingLeft, slotPaddingTop = 2, 2

    local layout = {
        Bag = {
            Width = ((numOfSlots/rows) * (slotSize + slotPaddingLeft) + slotPaddingLeft),
            Height = ((rows) * (slotSize + slotPaddingTop) + slotPaddingTop),
            NumberOfSlots = numOfSlots,
            MaxNumberOfSlots = self.Constants.NUM_QUICKACCESS_SLOTS + numOfSlots,
            NumberOfRows = rows,
            StartIndex = self.Constants.NUM_QUICKACCESS_SLOTS,
        },
        Slot = {
            Size = slotSize,
            Padding = {
                Left = slotPaddingLeft, 
                Top = slotPaddingTop,
            },
        },
    }
    return layout
end
