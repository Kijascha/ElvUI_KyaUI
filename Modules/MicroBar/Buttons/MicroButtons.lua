local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MicroBar')

local _G = _G
local unpack = unpack
local CreateFrame = CreateFrame

if not MB.MicroButtons then MB.MicroButtons = {} end

local gradientPacks = MB.Utils.Colors.GradientPacks;

function MB:SetColorGradient(button, orientation , gradientPack)
	if not gradientPack then return end
	button.Texture:SetGradient(orientation, gradientPack.From, gradientPack.To)
end
function MB:CreateButton(buttonName)
    if not MB.db then return end
    if not MB.MicroBar.Buttons then MB.MicroBar.Buttons = {} end

    local size = MB.db.size or 32;
	MB.NumButtons = MB.NumButtons + 1;
	MB.MicroBar.Buttons[MB.NumButtons] = CreateFrame("Button",nil,MB.MicroBar);
	MB.MicroBar.Buttons[MB.NumButtons].Name = buttonName;
	MB.MicroBar.Buttons[MB.NumButtons]:SetPoint('LEFT',MB.MicroBar, 0,0);	
	MB.MicroBar.Buttons[MB.NumButtons]:SetSize(size, size);
	MB.MicroBar.Buttons[MB.NumButtons]:SetFrameLevel(6);
	MB.MicroBar.Buttons[MB.NumButtons]:RegisterEvent("UPDATE_BINDINGS");
	MB.MicroBar.Buttons[MB.NumButtons]:Show();
	MB.MicroBar.Buttons[MB.NumButtons].isShown = false;
	MB.MicroBar.Buttons[MB.NumButtons].isMouseEnter = false;	
	MB.MicroBar.Buttons[MB.NumButtons].isMouseLeave = false;	
	MB.MicroBar.Buttons[MB.NumButtons].isMouseUp = false;
	MB.MicroBar.Buttons[MB.NumButtons].isMouseDown = false;
	MB.MicroBar.Buttons[MB.NumButtons].tooltipText = '';
end

function MB:HandleButton(button)	

	local backdrop = CreateFrame('Frame', nil, button, 'BackdropTemplate')
	backdrop:SetFrameLevel(1)
	backdrop:SetFrameStrata('BACKGROUND')
	backdrop:SetTemplate(nil, true)
	backdrop:SetOutside(button)
	button.backdrop = backdrop

	button:SetSize(MB.db.size,MB.db.size);
	button.text = button:CreateFontString(nil, 'ARTWORK', "GameTooltipText")
	button.text:SetPoint("CENTER", 0, 0)
	button.Texture = button:CreateTexture(nil,"ARTWORK",nil,-6)
	button.Texture:SetTexCoord(0,1,0,1)
	button.Texture:SetInside(button,2,2)
	--button.Texture:SetAllPoints(button)
	button.Texture:SetPoint("BOTTOMLEFT", button, 2,2)
	button.Texture:SetBlendMode('BLEND') --make texture same size as button
	button.Texture:SetSize(button:GetSize(), button:GetSize())
	
	MB:SetColorGradient(button, "VERTICAL", gradientPacks.Normal)
	
	button:SetScript("OnUpdate", function(self,elapsed) 
        MB.Events:OnUpdate(self,elapsed);
    end)

	button:SetScript("OnMouseDown", function(self)	
		self.isMouseDown = true	
		self.isMouseUp = false	
		MB.Events:OnMouse(self)
	end)
	button:SetScript("OnMouseUp", function(self)	
		self.isMouseDown = false	
		self.isMouseUp = true	
		MB.Events:OnMouse(self)
	end)
	button:SetScript('OnEnter', function(self)	
		self.isMouseEnter = true
		self.isMouseLeave = false		
		MB.tooltip:SetOwner(self,"ANCHOR_BOTTOM")	
		MB.Events:OnUpdate(self,GetTime())
		MB.tooltip:Show()
		MB.Events:OnMouse(self)
	end)
	button:SetScript('OnLeave', function(self)
		self.isMouseLeave = true
		self.isMouseEnter = false		
		MB.tooltip:Hide()
		MB.Events:OnMouse(self)
	end)

	MB.MicroButtons:CharacterMicroButton(button);
	MB.MicroButtons:SocialMicroButton(button);
	MB.MicroButtons:GuildMicroButton(button);
	MB.MicroButtons:AchievementMicroButton(button);
	MB.MicroButtons:QuestLogMicroButton(button);
	MB.MicroButtons:EJMicroButton(button);
	MB.MicroButtons:LFDMicroButton(button);
	MB.MicroButtons:SpellbookMicroButton(button);
	MB.MicroButtons:TalentMicroButton(button);
	MB.MicroButtons:CollectionsMicroButton(button);
	MB.MicroButtons:StoreMicroButton(button);
	MB.MicroButtons:MainMenuMicroButton(button);	
end