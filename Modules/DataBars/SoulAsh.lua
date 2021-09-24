local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DB = KYA:GetModule('DataBars')
local DBO = E:GetModule('DataBars')

local _G = _G
local floor = floor
local format = format

local InCombatLockdown = InCombatLockdown
local HasArtifactEquipped = HasArtifactEquipped
local SocketInventoryItem = SocketInventoryItem
local UIParentLoadAddOn = UIParentLoadAddOn
local ToggleFrame = ToggleFrame
local Item = Item

local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo

local TORGHAST_WIDGETS = {
	{name = 2925, level = 2930}, -- Fracture Chambers
	{name = 2926, level = 2932}, -- Skoldus Hall
	{name = 2924, level = 2934}, -- Soulforges
	{name = 2927, level = 2936}, -- Coldheart Interstitia
	{name = 2928, level = 2938}, -- Mort'regar
	{name = 2929, level = 2940} -- The Upper Reaches
  }
local function GetTorghastProgress()
	local data = {}
	for _, widgets in ipairs(TORGHAST_WIDGETS) do
	  local nameData = C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo(widgets.name)
	  if (nameData.shownState == 1) then
		-- Available this week
		local levelData = C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo(widgets.level)
		if (levelData) then
		  table.insert(
			data,
			{
			  name = nameData.text,
			  level = levelData.shownState == 1 and levelData.text or
				string.format("|c%s%s|r", colors.torghastAvailable, L["Available"])
			}
		  )
		end
	  end
	end
  
	return data
  end

function DBO:SoulAshBar_Update(event, currencyType)
	local currencyInfo = C_CurrencyInfo_GetCurrencyInfo(1828)
	if not currencyInfo["discovered"] then return end
	local data = GetTorghastProgress()
	--E:Dump(data[1].level)
	local bar = DBO.StatusBars.SoulAsh
	DBO:SetVisibility(bar)
	if not bar.db.enable or bar:ShouldHide() then return end

	local quantity, maxQuantity = currencyInfo["quantity"], currencyInfo["maxQuantity"]
	local quantityEarnedThisWeek, maxWeeklyQuantity = currencyInfo["quantityEarnedThisWeek"], currencyInfo["maxWeeklyQuantity"]
	local totalEarned = currencyInfo["totalEarned"]
	local color = DBO.db.colors.soulash

	bar:SetStatusBarColor(color.r, color.g, color.b, color.a)
	bar:SetMinMaxValues(0, maxQuantity)
	bar:SetValue(quantity)

	local textFormat = DBO.db.soulash.textFormat
	if textFormat == 'NONE' then
		bar.text:SetText('')
	elseif textFormat == 'PERCENT' then
		bar.text:SetFormattedText('%s: %s%% [%s]', currencyInfo["name"], floor(quantity / maxQuantity * 100), totalEarned)
	--elseif textFormat == 'PERCENTPERWEEK' then
	--	bar.text:SetFormattedText('%s%% [%s]', floor(quantityEarnedThisWeek / maxWeeklyQuantity * 100), quantity)
	elseif textFormat == 'CURMAX' then
		bar.text:SetFormattedText('%s: %s - %s [%s]', currencyInfo["name"], E:ShortValue(quantity), E:ShortValue(maxQuantity), totalEarned)
	--elseif textFormat == 'CURMAXPERWEEK' then
	--	bar.text:SetFormattedText('%s - %s [%s]', E:ShortValue(quantityEarnedThisWeek), E:ShortValue(maxWeeklyQuantity), quantity)
	elseif textFormat == 'CURPERC' then
		bar.text:SetFormattedText('%s: %s - %s%% [%s]', currencyInfo["name"], E:ShortValue(quantity), floor(quantity / maxQuantity * 100), totalEarned)
	--elseif textFormat == 'CURPERCPERWEEK' then
	--	bar.text:SetFormattedText('%s - %s%% [%s]', E:ShortValue(quantity), floor(quantityEarnedThisWeek / maxWeeklyQuantity * 100), quantity)
	elseif textFormat == 'CUR' then
		bar.text:SetFormattedText('%s: %s [%s]', currencyInfo["name"], E:ShortValue(quantity), totalEarned)
	--elseif textFormat == 'CURPERWEEK' then
	--	bar.text:SetFormattedText('%s [%s]', E:ShortValue(quantityEarnedThisWeek), quantity)
	elseif textFormat == 'REM' then
		bar.text:SetFormattedText('%s: %s [%s]', currencyInfo["name"], E:ShortValue(maxQuantity - quantity), totalEarned)
	--elseif textFormat == 'REMPERWEEK' then
	--	bar.text:SetFormattedText('%s [%s]', E:ShortValue(maxWeeklyQuantity - quantityEarnedThisWeek), quantity)
	elseif textFormat == 'CURREM' then
		bar.text:SetFormattedText('%s: %s - %s [%s]', currencyInfo["name"], E:ShortValue(quantity), E:ShortValue(maxQuantity - quantity), totalEarned)
	--elseif textFormat == 'CURREMPERWEEK' then
	--	bar.text:SetFormattedText('%s - %s [%s]', E:ShortValue(quantityEarnedThisWeek), E:ShortValue(maxWeeklyQuantity - quantityEarnedThisWeek), quantity)
	elseif textFormat == 'CURPERCREM' then
		bar.text:SetFormattedText('%s: %s - %s%% (%s) [%s]', currencyInfo["name"], E:ShortValue(quantity), floor(quantity / maxQuantity * 100), E:ShortValue(maxQuantity - quantity), totalEarned)
	--elseif textFormat == 'CURPERCREMPERWEEK' then
	--	bar.text:SetFormattedText('%s - %s%% (%s) [%s]', E:ShortValue(quantityEarnedThisWeek), floor(quantityEarnedThisWeek / maxWeeklyQuantity * 100), E:ShortValue(maxWeeklyQuantity - quantityEarnedThisWeek), quantity)
	--elseif textFormat == 'CURMAXANDWEEKLYCURMAX' then
	--	bar.text:SetFormattedText('%s/%s [%s/%s]', E:ShortValue(quantity), E:ShortValue(maxQuantity), E:ShortValue(quantityEarnedThisWeek), E:ShortValue(maxWeeklyQuantity))
	--elseif textFormat == 'CURMAXPERCANDWEEKLYCURMAXPERC' then
	--	bar.text:SetFormattedText('%s/%s - %s%% [%s/%s - %s%%]', E:ShortValue(quantity), E:ShortValue(maxQuantity), floor(quantity / maxQuantity * 100), E:ShortValue(quantityEarnedThisWeek), E:ShortValue(maxWeeklyQuantity), floor(quantityEarnedThisWeek / maxWeeklyQuantity * 100))
	else
		bar.text:SetFormattedText('[%s]', totalEarned)
	end
end

do
	local curXP, maxXP, curWeekly, maxWeekly, totalEarned
	function DBO:SoulAshBar_OnEnter()
			if DBO.db.soulash.mouseover then
				E:UIFrameFadeIn(self, 0.4, self:GetAlpha(), 1)
			end			
			if _G.GameTooltip:IsForbidden() then return end
			local currencyInfo = C_CurrencyInfo_GetCurrencyInfo(1828)
			curXP, maxXP = currencyInfo["quantity"], currencyInfo["maxQuantity"]
			--curWeekly, maxWeekly = currencyInfo["quantityEarnedThisWeek"], currencyInfo["maxWeeklyQuantity"]
			--totalEarned = currencyInfo["totalEarned"]

			_G.GameTooltip:ClearLines()
			_G.GameTooltip:SetOwner(self, 'ANCHOR_CURSOR')

			_G.GameTooltip:AddDoubleLine("Shadowlands Currencies", currencyInfo["name"], nil,  nil, nil, 0.90, 0.80, 0.50) -- Temp Locale
			_G.GameTooltip:AddLine(' ')

			_G.GameTooltip:AddDoubleLine("SoulAsh", format(' %d / %d (%d%%)', curXP, maxXP, curXP / maxXP  * 100), 1, 1, 1)
			_G.GameTooltip:AddDoubleLine(L["Remaining:"], format(' %d (%d%% - %d '..L["Bars"]..')', maxXP - curXP, (maxXP - curXP) / maxXP * 100, 10 * (maxXP - curXP) / maxXP), 1, 1, 1)

			_G.GameTooltip:Show()
	end
end

function DBO:SoulAshBar_OnClick()
	if InCombatLockdown() then return end
	ToggleCharacter("TokenFrame");
end

function DBO:SoulAshBar_Toggle()
	local bar = DBO.StatusBars.SoulAsh
	bar.db = DBO.db.soulash
	if bar.db.enable then
		E:EnableMover(bar.holder.mover:GetName())
		DBO:RegisterEvent('PLAYER_ENTERING_WORLD', DBO.SoulAshBar_Update)
		DBO:RegisterEvent('CURRENCY_DISPLAY_UPDATE', DBO.SoulAshBar_Update)
		DBO:SoulAshBar_Update()
	else		
		DBO:UnregisterEvent('PLAYER_ENTERING_WORLD')
		DBO:UnregisterEvent('CURRENCY_DISPLAY_UPDATE')
		E:DisableMover(bar.holder.mover:GetName())
	end
end

function DBO:SoulAshBar()
	local SoulAsh = DBO:CreateBar('KyaUI_SoulAshBar', 'SoulAsh', DBO.SoulAshBar_Update, DBO.SoulAshBar_OnEnter, DBO.SoulAshBar_OnClick, {'TOPRIGHT', E.UIParent, 'TOPRIGHT', -3, -245})
	DBO:CreateBarBubbles(SoulAsh)
	SoulAsh.ShouldHide = function()
		local currencyInfo = C_CurrencyInfo_GetCurrencyInfo(1828)
		return not currencyInfo["discovered"] or (DBO.db.soulash.hideAtMaxLevel)
	end

	E:CreateMover(SoulAsh.holder, 'SoulAshBarMover',"SoulAsh Bar", nil, nil, nil, nil, nil, 'databars,soulash')

	DBO:SoulAshBar_Toggle()
end
