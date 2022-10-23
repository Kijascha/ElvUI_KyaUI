local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MicroBar')
local ElvMB = E:GetModule('ActionBars')

local _G = _G
local pairs = pairs
local assert = assert
local unpack = unpack
local CreateFrame = CreateFrame
local C_StorePublic_IsEnMBled = C_StorePublic.IsEnabled
local UpdateMicroButtonsParent = UpdateMicroButtonsParent
local GetCurrentRegionName = GetCurrentRegionName
local RegisterStateDriver = RegisterStateDriver
local InCombatLockdown = InCombatLockdown
local UnitSex = UnitSex
local GetNetStats = GetNetStats

if not MB.MicroButtons then MB.MicroButtons = {} end;
local gradientPacks = MB.Utils.Colors.GradientPacks;

function MB.MicroButtons:EJMicroButton(button)
    if button.Name == "EJMicroButton" then
		button.Texture:SetTexture(MB.Utils:GetMicroBarIcon("EJ"))

		button.tooltipText = MicroButtonTooltipText(ADVENTURE_JOURNAL, "TOGGLEENCOUNTERJOURNAL");
		
		if _G["EncounterJournal"] then
			_G["EncounterJournal"]:HookScript("OnShow", function(self)
				button.isShown = _G["EncounterJournal"]:IsShown()
				MB.Events:OnMouse(button)
			end)
			_G["EncounterJournal"]:HookScript("OnHide", function(self)
				MB:SetColorGradient(button, "VERTICAL", gradientPacks.Normal)
				button.isShown = false
				button.isMouseEnter = false	
				button.isMouseLeave = false	
				button.isMouseUp = false
				button.isMouseDown = false	
			end)
		end
		button:SetScript('OnClick', function(self)
			if InCombatLockdown() then
				return
			end
			_G["ToggleEncounterJournal"]()
			self.isShown = _G["EncounterJournal"]:IsShown()
			MB.Events:OnMouse(self)
			_G["EncounterJournal"].CloseButton:HookScript("OnClick",function(self)
				MB:SetColorGradient(button, "VERTICAL", gradientPacks.Normal)
				button.isShown = false
				button.isMouseEnter = false	
				button.isMouseLeave = false	
				button.isMouseUp = false
				button.isMouseDown = false					
			end)
		end)
    end
end