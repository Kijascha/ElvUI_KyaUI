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

function MB.MicroButtons:MainMenuMicroButton(button)
    if button.Name == "MainMenuMicroButton" then
		button.Texture:SetTexture(MB.Utils:GetMicroBarIcon("MainMenu"))		
		button.tooltipText = MicroButtonTooltipText(MAINMENU_BUTTON, "TOGGLEGAMEMENU")		
		if _G["GameMenuFrame"] then
			_G["GameMenuFrame"]:HookScript("OnShow", function(self)
				button.isShown = _G["GameMenuFrame"]:IsShown()
				MB.Events:OnMouse(button)
			end)
			_G["GameMenuFrame"]:HookScript("OnHide", function(self)
				button.Texture:SetGradientAlpha("VERTICAL", unpack(gradientPacks.Normal))
				button.isShown = false
				button.isMouseEnter = false	
				button.isMouseLeave = false	
				button.isMouseUp = false
				button.isMouseDown = false	
			end)
		end
		button:SetScript('OnClick', function(self,button)
			if InCombatLockdown() then			
				if _G.GameMenuFrame:IsShown() then
					PlaySound(SOUNDKIT.IG_MAINMENU_QUIT);
					_G.GameMenuFrame:Hide();
				else
					PlaySound(SOUNDKIT.IG_MAINMENU_OPEN);
					_G.GameMenuFrame:Show();
				end
				return
			end
			
			if _G.GameMenuFrame:IsShown() then
				PlaySound(SOUNDKIT.IG_MAINMENU_QUIT);
				HideUIPanel(_G.GameMenuFrame);
			else
				PlaySound(SOUNDKIT.IG_MAINMENU_OPEN);
				ShowUIPanel(_G.GameMenuFrame);
			end

			self.isShown = _G["GameMenuFrame"]:IsShown()
			MB.Events:OnMouse(self)
		end)

		-- Create BugSackNotificationIcon when BugSack addon is loaded
		if KYA.BS then 
			button.bsNotify = CreateFrame("Frame", "BugSack_Notify", button);
			button.bsNotify:SetPoint("CENTER", button, 0,0)
			button.bsNotify:SetSize(18,18);
			button.bsNotify:SetFrameLevel(button:GetFrameLevel()-5);
			button.bsNotify.Texture = button.bsNotify:CreateTexture(nil,"ARTWORK",nil,-6)
			button.bsNotify.Texture:SetTexCoord(0,1,0,1)
			button.bsNotify.Texture:SetInside(button.bsNotify,2,2)
			--button.bsNotify.Texture:SetAllPoints(button)
			button.bsNotify.Texture:SetPoint("CENTER", button.bsNotify,0,0)
			--button.bsNotify.Texture:SetBlendMode('BLEND') --make texture same size as button
			button.bsNotify.Texture:SetSize(button.bsNotify:GetSize(), button.bsNotify:GetSize())
			button.bsNotify.Texture:SetTexture(MB.Utils:GetMicroBarIcon("BugSackNotification"));	
			button.bsNotify.Texture:SetColorTexture(85/255, 200/255, 85/255,225/255); 
			hooksecurefunc(BugSack, "UpdateDisplay", function(self)
				local errors = self:GetErrors(BugGrabber:GetSessionId());
				if #errors > 0 then
					button.bsNotify.Texture:SetColorTexture(200/255, 80/255, 80/255,225/255); 
				end
			end)
		end
    end
end