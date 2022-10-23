local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MBR = KYA:GetModule('MinimapButtonsRevamp');

local eventsToRegister = {
	"PLAYER_ENTERING_WORLD",
	"ADDON_LOADED"
}

QuickAccessBarMixin = {}

function QuickAccessBarMixin:OnLoad(self)
	
end

function QuickAccessBarMixin:OnEvent(event,...)
end

function QuickAccessBarMixin:SetDefaultAppearance()
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

	local borderThickness = 1
	local spacing = 2
	local slotCount = MBR.Constants.NUM_QUICKACCESS_SLOTS + 1 --Add one additional slot for the toggle button
	local size = 36

	for i=1, slotCount do
		local slot = CreateFrame("Button","LibDBSlot"..i, self, "LibDBSlotCodeTemplate, BackdropTemplate");
		slot:SetTemplate("Transparent")
		slot:SetFrameLevel(15);
		slot:SetFrameStrata(self:GetFrameStrata());
		slot:SetBackdropBorderColor(0,0,0,1);
		slot:SetBackdropColor(0,0,0,.5);
		slot:Size(size,size);

		if i == 1 then
			local firstSpacing = (1 + spacing)
			slot:SetPoint("LEFT", self, "LEFT", firstSpacing, 0);
		else
			slot:Point("LEFT", "LibDBSlot"..i-1, "RIGHT", spacing, 0);
		end

		slot.ID = i;
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

	--[[
		Calculate Size
	]]
	local barWidth = E:Scale(E.Border*2) + (slotCount+1)*E:Scale(spacing) + E:Scale(size)*slotCount -- calculate width
	local barHeight = E.Border*2 + 2*spacing + E:Scale(size) -- calculate height

	self:SetSize(barWidth,barHeight);
end

function QuickAccessBarMixin:GetButton(minimapButtonSlot)
	if self.Slots then
		return self.Slots[minimapButtonSlot]
	end
end

function MBR:CreateQuickAccessBar()
	local quickAccessBar = self:CreateBar("MBR_QuickAccessBar", eventsToRegister, QuickAccessBarMixin);
	quickAccessBar:SetDefaultAppearance();
	return quickAccessBar;
end
