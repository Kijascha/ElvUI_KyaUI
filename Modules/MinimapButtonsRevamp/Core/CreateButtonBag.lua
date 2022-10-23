
local eventsToRegister = {
	"PLAYER_ENTERING_WORLD",
	"ADDON_LOADED"
}

ButtonBagMixin = {}

function ButtonBagMixin:OnLoad(self)
	
end

function ButtonBagMixin:OnEvent(event,...)
end

function ButtonBagMixin:SetDefaultAppearance()
	--[[
		TODO: 
			create a default appearance
	]]
	self:SetTemplate("Transparent");
    self:SetFrameLevel(5);
    self:SetFrameStrata("MEDIUM");
    self:SetBackdropColor(0,0,0,.5);    
    self:SetPoint("CENTER",E.UIParent,"CENTER",0,0)

	self.Slots = {}

    local layout = MBR:CreateBagLayout()
    local startIndex = layout.Bag.StartIndex;
    local numOfSlots = layout.Bag.NumberOfSlots;
    local maxNumOfSlots = layout.Bag.MaxNumberOfSlots;
    local numOfRows = layout.Bag.NumberOfRows;
	local paddingLeft = layout.Slot.Padding.Left;
	local paddingTop = layout.Slot.Padding.Top;

	local size = layout.Slot.Size

    local columns, rows = mod(numOfSlots/numOfRows), numOfRows
    local bagXpos, bagYpos = 0, 0; -- start position (top left corner) just for better readability

    for y=1, rows do
        for x=1, columns do
            
            local slotID = (y*x)+startIndex;
            local slot = CreateFrame("Button","LibDBSlot"..slotID, self, "LibDBSlotCodeTemplate, BackdropTemplate");
            slot:SetTemplate("Transparent")
            slot:SetFrameLevel(15);
            slot:SetFrameStrata(self:GetFrameStrata());
            slot:SetBackdropBorderColor(0,0,0,1);
            slot:SetBackdropColor(0,0,0,.5);
            slot:Size(size,size);

            local xOffSet = bagXpos + paddingLeft * (x + 1) + (size * x)
            local yOffSet = bagYpos - paddingLeft * (y + 1) - (size * y)

            slot:Point("TOPLEFT", self, "TOPLEFT", xOffSet, yOffSet);

            slot.ID = slotID;
            slot.Button = nil
            slot.HasButton = function() 
                if not slot.Button then return false end
                return true;
            end;

            slot:HookScript("OnEnter", function(self)
                if not self.HasButton() then
                    self:SetBackdropColor(36/255,36/255,36/255,.5);
                else
                end

            end)
            slot:HookScript("OnLeave", function(self)
                self:SetBackdropBorderColor(0,0,0,1);
                self:SetBackdropColor(0,0,0,.5);
            end)
            slot:Show();
            tinsert(self.Slots, slot);
            MBR.RegisterSlot(slot);
        end
    end
	--[[
		Calculate Size
	]]
	--local barWidth = E:Scale(E.Border*2) + (slotCount+1)*E:Scale(spacing) + E:Scale(size)*slotCount -- calculate width
	--local barHeight = E.Border*2 + 2*spacing + E:Scale(size) -- calculate height

	self:SetSize(layout.Bag.Width,layout.Bag.Height);
end

function ButtonBagMixin:GetButton(minimapButtonSlot)
	if self.Slots then
		return self.Slots[minimapButtonSlot]
	end
end

function MBR:CreateButtonBag()
	local buttonBag = self:CreateBar("MBR_ButtonBag", eventsToRegister, ButtonBagMixin);
	buttonBag:SetDefaultAppearance();
	return buttonBag;
end
