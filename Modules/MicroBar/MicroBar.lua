local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MicroBar')
local ElvMB = E:GetModule('ActionBars')

local _G = _G
local unpack = unpack
local CreateFrame = CreateFrame

--[[ PRIVATE ]]
local function DisableElvUI_MicroBar()
	if E.db.actionbar.microbar.enabled then
		E.db.actionbar.microbar.enabled=false
		ElvMB:UpdateMicroButtons()
	end
end

--[[ PUBLIC ]]
MB.tooltip = CreateFrame('GameTooltip', 'MicroBarTooltip', E.UIParent, 'GameTooltipTemplate')
MB.tooltip:SetTemplate("Transparent")

function MB:UpdateMicroBar(self, event)
	if MB.MicroBar.Buttons ~= nil then

		local borderThickness = 1
		local borderInset = 2 * borderThickness
		local borderSpacing = (MB.db.borderSpacing or 1) + borderInset

		local buttonSpacing = (MB.db.buttonSpacing or 1) + borderInset
		local numButtonsWidth = #MB.MicroBar.Buttons * MB.db.size
		local numButtonsSpacing = (#MB.MicroBar.Buttons) * buttonSpacing - buttonSpacing

		local spacingSides = 2 * borderSpacing

		local barWidth = (numButtonsWidth + numButtonsSpacing + spacingSides)
		local barHeight = MB.db.size + spacingSides

		MB.MicroBar:SetSize(barWidth,barHeight)
		MB.MicroBar:SetScale(MB.db.scale or 1)

		local count = #MB.MicroBar.Buttons

		for i = 1, count do
			if i == 1 then
				MB.MicroBar.Buttons[i]:SetPoint('LEFT',MB.MicroBar, borderSpacing,0)
			else
				MB.MicroBar.Buttons[i]:SetPoint('LEFT',MB.MicroBar.Buttons[i-1], MB.db.size + buttonSpacing ,0)	
			end
			MB:HandleButton(MB.MicroBar.Buttons[i])
		end
	end	
end

function MB:CreateMicroBar()
	-- Create Bar
	MB.MicroBar = CreateFrame("Frame","KyaUI_MicroBar",E.UIParent,'BackdropTemplate');
	MB.MicroBar:SetPoint('TOP',E.UIParent,'TOP',0,-29);
	MB.MicroBar:SetFrameStrata("MEDIUM")
	MB.MicroBar:EnableMouse(true)
	MB.MicroBar:SetScript("OnEvent", function(self,event)
		if MB.db.hideInCombat then 
			if event == "PLAYER_REGEN_DISABLED" then
				self:Hide() 
			elseif event == "PLAYER_REGEN_ENABLED" then
				self:Show()
			end
		end
	end)
	if MB.db.scale == 0 then MB.db.scale = 0.5 end
	MB.MicroBar:SetScale(MB.db.scale or 1)
	MB.MicroBar:SetTemplate(MB.db.template or "Transparent")
	E.FrameLocks[MB.MicroBar] = true
	
	-- Create MicroButtons
	MB:CreateButton("CharacterMicroButton")
	MB:CreateButton("SocialMicroButton")
	MB:CreateButton("GuildMicroButton")
	MB:CreateButton("AchievementMicroButton")
	MB:CreateButton("QuestLogMicroButton")
	MB:CreateButton("EJMicroButton")
	MB:CreateButton("LFDMicroButton")
	MB:CreateButton("SpellbookMicroButton")
	MB:CreateButton("TalentMicroButton")
	MB:CreateButton("CollectionsMicroButton")
	MB:CreateButton("StoreMicroButton")
	MB:CreateButton("MainMenuMicroButton")
	
	E:CreateMover(MB.MicroBar, "KyaUI_MicroBarMover", "KyaUI_MicroBarMover", nil, nil, nil, "ALL,ACTIONBARS,KYAUI", nil, "kyaui,actionbars")	
end

function MB:Toggle()
	if not MB.db then return end
	if not MB.MicroBar then MB:CreateMicroBar() end

	if MB.db.enabled then
		MB:RegisterEvent("ADDON_LOADED", MB.UpdateMicroBar)
		MB.MicroBar:RegisterEvent("PLAYER_REGEN_ENABLED", MB.UpdateMicroBar)
		MB.MicroBar:RegisterEvent("PLAYER_REGEN_DISABLED", MB.UpdateMicroBar)
		MB.MicroBar:RegisterEvent("PLAYER_ENTERING_WORLD", MB.UpdateMicroBar)
		MB.MicroBar:RegisterEvent("PLAYER_TALENT_UPDATE", MB.Utils.UpdateCurrentTalentSpecialization)
		MB.MicroBar:Show()
		MB:UpdateMicroBar()
		DisableElvUI_MicroBar()
		E:EnableMover(MB.MicroBar.mover:GetName())
	else
		MB:UnregisterEvent("ADDON_LOADED")
		MB.MicroBar:UnregisterEvent("PLAYER_REGEN_ENABLED")
		MB.MicroBar:UnregisterEvent("PLAYER_REGEN_DISABLED")
		MB.MicroBar:UnregisterEvent("PLAYER_ENTERING_WORLD")
		MB.MicroBar:UnregisterEvent("PLAYER_TALENT_UPDATE")
		MB.MicroBar:Hide()
		E:DisableMover(MB.MicroBar.mover:GetName())
		MB:UpdateMicroBar()
	end
end

function MB:Initialize()
	-- set ProfileDB
	MB.db = E.db.kyaui.microBar
	
	-- Only proceed if Module is enabled
	if MB.db.enabled ~= true then return end

	MB.NumButtons = 0;
	MB.Wait, MB.Count =.5, 0 ; 

	-- Create the MicroBar
	MB:Toggle()	

	function MB:ForUpdateAll()
		MB:Toggle()
	end
	MB:ForUpdateAll()

	MB.Initialized = true
	
end

KYA:RegisterModule(MB:GetName())