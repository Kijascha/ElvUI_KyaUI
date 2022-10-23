local KYA, E, L, V, P, G = unpack(select(2, ...))

--Cache Lua / WoW API
local _G = _G
local ceil, format, checkTable = ceil, string.format, next
local tinsert, twipe, tsort, tconcat, tforeach = table.insert, table.wipe, table.sort, table.concat, table.foreach
local GetCVarBool = GetCVarBool
local ReloadUI = ReloadUI
local StopMusic = StopMusic

-- These are things we do not cache
-- GLOBALS: PluginInstallStepComplete, PluginInstallFrame
local function SetupCVars()
	-- Setup CVar
	SetCVar("autoQuestProgress", 1)
	SetCVar("guildMemberNotify", 1)
	SetCVar("TargetNearestUseNew", 1)
	SetCVar("cameraSmoothStyle", 0)
	SetCVar("cameraDistanceMaxZoomFactor", 2.6)
	SetCVar("UberTooltips", 1)
	SetCVar("lockActionBars", 1)
	SetCVar("chatMouseScroll", 1)
	SetCVar("chatStyle", "classic")
	SetCVar("whisperMode", "inline")
	SetCVar("violenceLevel", 5)
	SetCVar("blockTrades", 0)
	SetCVar("countdownForCooldowns", 1)
	SetCVar("showQuestTrackingTooltips", 1)
	SetCVar("ffxGlow", 0)
	SetCVar("floatingCombatTextCombatState", 1)	
	SetCVar("autoLootDefault", 1)

	--nameplates
	SetCVar("ShowClassColorInNameplate", 1)

	PluginInstallStepComplete.message = KYA.Title..L["CVars Set"]
	PluginInstallStepComplete:Show()
end
function KYA:SetupDataBars() -- Seperate InstallPage
	
	E.db["movers"] = E.db["movers"] or {}
	E.db["general"]["bottomPanel"] = true

	E.db.databars["transparent"] = true
	E.db.databars["customTexture"] = true
	E.db.databars["statusbar"] = "KyaOnePixel"

	for _, databar in pairs({ 'experience', 'reputation', 'honor', 'azerite'}) do
		E.db.databars[databar].enable = true
		E.db.databars[databar].width = 380
		E.db.databars[databar].height = 20
		E.db.databars[databar].textFormat = 'CURPERCREM'
		E.db.databars[databar].fontSize = 12
		E.db.databars[databar].font = "Continuum Medium"
		E.db.databars[databar].fontOutline = 'OUTLINE'
		E.db.databars[databar].xOffset = 0
		E.db.databars[databar].yOffset = 0
		E.db.databars[databar].displayText = true
		E.db.databars[databar].anchorPoint = 'CENTER'
		E.db.databars[databar].mouseover = false
		E.db.databars[databar].clickThrough = false
		E.db.databars[databar].hideInCombat = false
		E.db.databars[databar].orientation = 'HORIZONTAL'
		E.db.databars[databar].reverseFill = false
		E.db.databars[databar].showBubbles = false
		E.db.databars[databar].frameStrata = 'LOW'
		E.db.databars[databar].frameLevel = 1		 
	end

	E.db.databars['honor'].hideOutsidePvP = false
	E.db.databars['experience'].hideAtMaxLevel = false

	E.db["movers"]["HonorBarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,0"
	E.db["movers"]["AzeriteBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,0"
	E.db["movers"]["ReputationBarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-381,0"
	E.db["movers"]["ExperienceBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,381,0"

	E:UpdateAll(true)
	--Show message about layout being set
	PluginInstallStepComplete.message = L["DataBars Set"]
	PluginInstallStepComplete:Show()
end
function KYA:SetupUnitframes(Role) -- Seperate InstallPage
	
	--[[CustomTexts Initialization
		------------------------------
		Current Texts: 'Status', 'KyaUI_Name', 'KyaUI_Group'
	]]
		tforeach(E.db["unitframe"]["units"], function(k,v)
			if k == 'tank' then return end
			if k == 'assist' then return end
			if v.customTexts == nil then v.customTexts = {} end
			
			if v.customTexts.KyaUI_Status 	== nil then v.customTexts.KyaUI_Status = {} end
			if v.customTexts.KyaUI_Name 	== nil then v.customTexts.KyaUI_Name = {} end
			if v.customTexts.KyaUI_Group 	== nil then v.customTexts.KyaUI_Group = {} end
			if v.customTexts.KyaUI_Health 	== nil then v.customTexts.KyaUI_Health = {} end
			
			if k == "boss" then
				if v.customTexts.Class 		== nil then v.customTexts.Class = {} end
				if v.customTexts.Life 		== nil then v.customTexts.Life = {} end
				if v.customTexts.Percent 	== nil then v.customTexts.Percent = {} end
				if v.customTexts.BigName 	== nil then v.customTexts.BigName = {} end
			end

			--[[ 
				CustomTexts Definition | KyaUI_Status
			]]
				v.customTexts["KyaUI_Status"]["attachTextTo"] = "Health"
				v.customTexts["KyaUI_Status"]["enable"] = true
				v.customTexts["KyaUI_Status"]["text_format"] = "[statustimer]"
				v.customTexts["KyaUI_Status"]["yOffset"] = -10
				v.customTexts["KyaUI_Status"]["font"] = "Continuum Medium"
				v.customTexts["KyaUI_Status"]["justifyH"] = "CENTER"
				v.customTexts["KyaUI_Status"]["fontOutline"] = "OUTLINE"
				v.customTexts["KyaUI_Status"]["xOffset"] = 0
				v.customTexts["KyaUI_Status"]["size"] = 12
			--[[ 
				CustomTexts Definition | KyaUI_Name
			]]
				v.customTexts["KyaUI_Name"]["attachTextTo"] = "InfoPanel"
				v.customTexts["KyaUI_Name"]["enable"] = true
				v.customTexts["KyaUI_Name"]["text_format"] = "[name:short]"
				v.customTexts["KyaUI_Name"]["yOffset"] = 0
				v.customTexts["KyaUI_Name"]["font"] = "Continuum Medium"
				v.customTexts["KyaUI_Name"]["justifyH"] = "LEFT"
				v.customTexts["KyaUI_Name"]["fontOutline"] = "OUTLINE"
				v.customTexts["KyaUI_Name"]["xOffset"] = 18
				v.customTexts["KyaUI_Name"]["size"] = 12
			--[[ 
				CustomTexts Definition | KyaUI_Group
			]]
				v.customTexts["KyaUI_Group"]["attachTextTo"] = "InfoPanel"
				v.customTexts["KyaUI_Group"]["enable"] = true
				v.customTexts["KyaUI_Group"]["text_format"] = "[group]"
				v.customTexts["KyaUI_Group"]["yOffset"] = 0
				v.customTexts["KyaUI_Group"]["font"] = "Continuum Medium"
				v.customTexts["KyaUI_Group"]["justifyH"] = "CENTER"
				v.customTexts["KyaUI_Group"]["fontOutline"] = "OUTLINE"
				v.customTexts["KyaUI_Group"]["xOffset"] = 0
				v.customTexts["KyaUI_Group"]["size"] = 12
			--[[ 
				CustomTexts Definition | KyaUI_Health
			]]	
				v.customTexts["KyaUI_Health"]["attachTextTo"] = "Health"
				v.customTexts["KyaUI_Health"]["enable"] = true
				v.customTexts["KyaUI_Health"]["text_format"] = "[health:current-max-percent]"
				v.customTexts["KyaUI_Health"]["yOffset"] = 0
				v.customTexts["KyaUI_Health"]["font"] = "Continuum Medium"
				v.customTexts["KyaUI_Health"]["justifyH"] = "LEFT"
				v.customTexts["KyaUI_Health"]["fontOutline"] = "OUTLINE"
				v.customTexts["KyaUI_Health"]["xOffset"] = 0
				v.customTexts["KyaUI_Health"]["size"] = 12
		
			if k == "boss" then
				--[[ 
					CustomTexts Definition | Class
				]]
				v.customTexts["Class"]["enable"] = true
				v.customTexts["Class"]["attachTextTo"] = "InfoPanel"
				v.customTexts["Class"]["font"] = "Continuum Medium"
				v.customTexts["Class"]["justifyH"] = "RIGHT"
				v.customTexts["Class"]["fontOutline"] = "OUTLINE"
				v.customTexts["Class"]["xOffset"] = 0
				v.customTexts["Class"]["text_format"] = "[namecolor][smartclass][difficultycolor][level][shortclassification]"
				v.customTexts["Class"]["yOffset"] = 1
				--[[ 
					CustomTexts Definition | Life
				]]
				v.customTexts["Life"]["enable"] = true
				v.customTexts["Life"]["attachTextTo"] = "Health"
				v.customTexts["Life"]["text_format"] = "[health:current-mUI]"
				v.customTexts["Life"]["yOffset"] = 0
				v.customTexts["Life"]["font"] = "Continuum Medium"
				v.customTexts["Life"]["justifyH"] = "LEFT"
				v.customTexts["Life"]["fontOutline"] = "OUTLINE"
				v.customTexts["Life"]["xOffset"] = 0
				v.customTexts["Life"]["size"] = 14
				--[[ 
					CustomTexts Definition | Percent
				]]
				v.customTexts["Percent"]["enable"] = true
				v.customTexts["Percent"]["attachTextTo"] = "Health"
				v.customTexts["Percent"]["text_format"] = "[perhp<%]"
				v.customTexts["Percent"]["yOffset"] = 0
				v.customTexts["Percent"]["font"] = "Continuum Medium"
				v.customTexts["Percent"]["justifyH"] = "RIGHT"
				v.customTexts["Percent"]["fontOutline"] = "OUTLINE"
				v.customTexts["Percent"]["xOffset"] = 0
				v.customTexts["Percent"]["size"] = 14
				--[[ 
					CustomTexts Definition | BigName
				]]
				v.customTexts["BigName"]["enable"] = true
				v.customTexts["BigName"]["attachTextTo"] = "InfoPanel"
				v.customTexts["BigName"]["text_format"] = "[name:medium]"
				v.customTexts["BigName"]["yOffset"] = 1
				v.customTexts["BigName"]["font"] = "Continuum Medium"
				v.customTexts["BigName"]["justifyH"] = "LEFT"
				v.customTexts["BigName"]["fontOutline"] = "OUTLINE"
				v.customTexts["BigName"]["xOffset"] = 0
				v.customTexts["BigName"]["size"] = 11
			end
		end)

	-- General Unit Frames Stuff
	-- Units: Pet
		E.db["unitframe"]["units"]["pet"]["debuffs"]["enable"] = true
		E.db["unitframe"]["units"]["pet"]["debuffs"]["countFont"] = "Merathilis Expressway"
		E.db["unitframe"]["units"]["pet"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["pet"]["debuffs"]["countFontSize"] = 9
		E.db["unitframe"]["units"]["pet"]["disableTargetGlow"] = false
		E.db["unitframe"]["units"]["pet"]["castbar"]["height"] = 10
		E.db["unitframe"]["units"]["pet"]["castbar"]["iconSize"] = 32
		E.db["unitframe"]["units"]["pet"]["castbar"]["width"] = 100
		E.db["unitframe"]["units"]["pet"]["width"] = 270
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["height"] = 14
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["pet"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["pet"]["health"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["pet"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["health"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["pet"]["power"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["pet"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["pet"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["pet"]["height"] = 29
		E.db["unitframe"]["units"]["pet"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["pet"]["name"]["text_format"] = "[name:medium]"

	-- Units: Tank
		E.db["unitframe"]["units"]["tank"]["enable"] = false

	-- Units: Party
		E.db["unitframe"]["units"]["party"]["debuffs"]["countFont"] = "Continuum Medium"
		E.db["unitframe"]["units"]["party"]["debuffs"]["xOffset"] = 1
		E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = 12
		E.db["unitframe"]["units"]["party"]["debuffs"]["attachTo"] = "POWER"
		E.db["unitframe"]["units"]["party"]["debuffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["party"]["debuffs"]["maxDuration"] = 0
		E.db["unitframe"]["units"]["party"]["debuffs"]["priority"] = "Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
		E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 30
		E.db["unitframe"]["units"]["party"]["debuffs"]["perrow"] = 3
		E.db["unitframe"]["units"]["party"]["portrait"]["overlayAlpha"] = 0.45
		E.db["unitframe"]["units"]["party"]["portrait"]["style"] = "Class"
		E.db["unitframe"]["units"]["party"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["party"]["portrait"]["width"] = 50
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["anchorPoint"] = "BOTTOM"
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["name"]["text_format"] = "[name:short]"
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["width"] = 79
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["height"] = 16
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["yOffset"] = -14
		E.db["unitframe"]["units"]["party"]["threatStyle"] = "BORDERS"
		E.db["unitframe"]["units"]["party"]["healPrediction"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["infoPanel"]["height"] = 20
		E.db["unitframe"]["units"]["party"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["party"]["name"]["attachTextTo"] = "Frame"
		E.db["unitframe"]["units"]["party"]["name"]["xOffset"] = 4
		E.db["unitframe"]["units"]["party"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["name"]["position"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["party"]["startFromCenter"] = true
		E.db["unitframe"]["units"]["party"]["height"] = 59
		E.db["unitframe"]["units"]["party"]["verticalSpacing"] = -1
		E.db["unitframe"]["units"]["party"]["visibility"] = "[@raid6,exists][nogroup]hide;show"
		E.db["unitframe"]["units"]["party"]["raidicon"]["attachTo"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["party"]["raidicon"]["xOffset"] = 1
		E.db["unitframe"]["units"]["party"]["raidicon"]["attachToObject"] = "Health"
		E.db["unitframe"]["units"]["party"]["raidicon"]["yOffset"] = -16
		E.db["unitframe"]["units"]["party"]["horizontalSpacing"] = -1
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["font"] = "Continuum Medium"
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["size"] = 25
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["fontSize"] = 12
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["yOffset"] = 25
		E.db["unitframe"]["units"]["party"]["growthDirection"] = "DOWN_RIGHT"
		E.db["unitframe"]["units"]["party"]["buffIndicator"]["size"] = 10
		E.db["unitframe"]["units"]["party"]["cutaway"]["health"]["enabled"] = true
		E.db["unitframe"]["units"]["party"]["raidWideSorting"] = true
		E.db["unitframe"]["units"]["party"]["readycheckIcon"]["size"] = 30
		E.db["unitframe"]["units"]["party"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["party"]["power"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["party"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["power"]["displayAltPower"] = true
		E.db["unitframe"]["units"]["party"]["power"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["power"]["yOffset"] = 2
		E.db["unitframe"]["units"]["party"]["summonIcon"]["attachTo"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["summonIcon"]["attachToObject"] = "Health"
		E.db["unitframe"]["units"]["party"]["summonIcon"]["size"] = 35
		E.db["unitframe"]["units"]["party"]["width"] = 200
		E.db["unitframe"]["units"]["party"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["party"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["health"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["party"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = 2
		E.db["unitframe"]["units"]["party"]["roleIcon"]["attachTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["roleIcon"]["size"] = 18
		E.db["unitframe"]["units"]["party"]["roleIcon"]["damager"] = false
		E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["party"]["petsGroup"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["petsGroup"]["height"] = 16
		E.db["unitframe"]["units"]["party"]["petsGroup"]["width"] = 60
		E.db["unitframe"]["units"]["party"]["petsGroup"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["petsGroup"]["yOffset"] = -1
		E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["buffs"]["sizeOverride"] = 30
		E.db["unitframe"]["units"]["party"]["buffs"]["perrow"] = 3
		E.db["unitframe"]["units"]["party"]["buffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["party"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["buffs"]["priority"] = "MER_RaidCDs"
		E.db["unitframe"]["units"]["party"]["buffs"]["countFont"] = "Continuum Medium"
		E.db["unitframe"]["units"]["party"]["buffs"]["yOffset"] = 24
	
	-- Units: Arena
		E.db["unitframe"]["units"]["arena"]["power"]["width"] = "inset"

	-- Units: TargetTarget
		-- General:
			E.db["unitframe"]["units"]["targettarget"]["threatStyle"] = "GLOW"
			E.db["unitframe"]["units"]["targettarget"]["disableTargetGlow"] = false
			E.db["unitframe"]["units"]["targettarget"]["portrait"]["camDistanceScale"] = 1
			E.db["unitframe"]["units"]["targettarget"]["width"] = 150
			E.db["unitframe"]["units"]["targettarget"]["height"] = 40
		-- Health:
			E.db["unitframe"]["units"]["targettarget"]["health"]["attachTextTo"] = "InfoPanel"
			E.db["unitframe"]["units"]["targettarget"]["health"]["xOffset"] = 0
			E.db["unitframe"]["units"]["targettarget"]["health"]["position"] = "LEFT"
		-- Power:
			E.db["unitframe"]["units"]["targettarget"]["power"]["attachTextTo"] = "InfoPanel"
			E.db["unitframe"]["units"]["targettarget"]["power"]["position"] = "RIGHT"
			E.db["unitframe"]["units"]["targettarget"]["power"]["height"] = 6
			E.db["unitframe"]["units"]["targettarget"]["power"]["xOffset"] = 0
		-- Infopanel:
			E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["enable"] = true
			E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["height"] = 18
			E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["transparent"] = true
		-- CustomTexts
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Health"]["attachTextTo"] = "Health"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Health"]["enable"] = true
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Health"]["text_format"] = "[health:current-max-percent]"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Health"]["yOffset"] = 0
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Health"]["font"] = "Continuum Medium"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Health"]["justifyH"] = "LEFT"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Health"]["fontOutline"] = "OUTLINE"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Health"]["xOffset"] = 0
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Health"]["size"] = 12
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Name"]["attachTextTo"] = "InfoPanel"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Name"]["enable"] = true
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Name"]["text_format"] = "[name:short]"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Name"]["yOffset"] = 0
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Name"]["font"] = "Continuum Medium"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Name"]["justifyH"] = "LEFT"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Name"]["fontOutline"] = "OUTLINE"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Name"]["xOffset"] = 18
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Name"]["size"] = 12
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Group"]["attachTextTo"] = "InfoPanel"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Group"]["enable"] = true
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Group"]["text_format"] = "[group]"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Group"]["yOffset"] = 0
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Group"]["font"] = "Continuum Medium"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Group"]["justifyH"] = "CENTER"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Group"]["fontOutline"] = "OUTLINE"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Group"]["xOffset"] = 0
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Group"]["size"] = 12
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Status"]["attachTextTo"] = "Health"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Status"]["enable"] = true
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Status"]["text_format"] = "[statustimer]"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Status"]["yOffset"] = -10
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Status"]["font"] = "Continuum Medium"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Status"]["justifyH"] = "CENTER"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Status"]["fontOutline"] = "OUTLINE"
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Status"]["xOffset"] = 0
			E.db["unitframe"]["units"]["targettarget"]["customTexts"]["KyaUI_Status"]["size"] = 12
			E.db["unitframe"]["units"]["targettarget"]["name"]["text_format"] = ""
		-- Debuffs:	
			E.db["unitframe"]["units"]["targettarget"]["debuffs"]["anchorPoint"] = "TOPLEFT"
			E.db["unitframe"]["units"]["targettarget"]["debuffs"]["priority"] = "Blacklist,Personal,Boss,RaidDebuffs,Dispellable,Whitelist"
			E.db["unitframe"]["units"]["targettarget"]["debuffs"]["yOffset"] = 1
		-- Buffs: 	
			E.db["unitframe"]["units"]["targettarget"]["buffs"]["anchorPoint"] = "TOPLEFT"
			E.db["unitframe"]["units"]["targettarget"]["buffs"]["sizeOverride"] = 26
			E.db["unitframe"]["units"]["targettarget"]["buffs"]["perrow"] = 4
			E.db["unitframe"]["units"]["targettarget"]["buffs"]["enable"] = true
			E.db["unitframe"]["units"]["targettarget"]["buffs"]["priority"] = "Blacklist,Personal,PlayerBuffs,CastByUnit,Dispellable,RaidBuffsElvUI"
			E.db["unitframe"]["units"]["targettarget"]["buffs"]["countFont"] = "Continuum Medium"
			E.db["unitframe"]["units"]["targettarget"]["buffs"]["yOffset"] = 1
		-- Mover:
			E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,111,137"	
	-- Units: Assist
		E.db["unitframe"]["units"]["assist"]["enable"] = false
	
	-- Units: Player
		-- General:
			E.db["unitframe"]["units"]["player"]["threatStyle"] = "INFOPANELBORDER"
			E.db["unitframe"]["units"]["player"]["smartAuraPosition"] = "DEBUFFS_ON_BUFFS"
			E.db["unitframe"]["units"]["player"]["disableMouseoverGlow"] = true
			E.db["unitframe"]["units"]["player"]["disableTargetGlow"] = true
			E.db["unitframe"]["units"]["player"]["disableFocusGlow"] = true
			E.db["unitframe"]["units"]["player"]["width"] = 195
			E.db["unitframe"]["units"]["player"]["height"] = 60
		-- Portrait:		
			E.db["unitframe"]["units"]["player"]["portrait"]["enabled"] = false
			E.db["unitframe"]["units"]["player"]["portrait"]["camDistanceScale"] = 1
		-- Health:
			E.db["unitframe"]["units"]["player"]["health"]["xOffset"] = 0
			E.db["unitframe"]["units"]["player"]["health"]["text_format"] = ""
			E.db["unitframe"]["units"]["player"]["health"]["colorOverride"] = "default"		
		-- Power:
			E.db["unitframe"]["units"]["player"]["power"]["attachTextTo"] = "InfoPanel"
			E.db["unitframe"]["units"]["player"]["power"]["powerPrediction"] = true
			E.db["unitframe"]["units"]["player"]["power"]["height"] = 8
			E.db["unitframe"]["units"]["player"]["power"]["strataAndLevel"]["frameLevel"] = 2
			E.db["unitframe"]["units"]["player"]["power"]["position"] = "LEFT"
			E.db["unitframe"]["units"]["player"]["power"]["detachedWidth"] = 285
			E.db["unitframe"]["units"]["player"]["power"]["hideonnpc"] = true
			E.db["unitframe"]["units"]["player"]["power"]["text_format"] = ""
			E.db["unitframe"]["units"]["player"]["power"]["xOffset"] = 0
		-- CustomTexts:		
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Health"]["enable"] = true
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Health"]["attachTextTo"] = "Health"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Health"]["text_format"] = "[health:current-max-percent]"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Health"]["yOffset"] = 0
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Health"]["font"] = "Continuum Medium"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Health"]["justifyH"] = "LEFT"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Health"]["fontOutline"] = "OUTLINE"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Health"]["xOffset"] = 0
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Health"]["size"] = 12
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Name"]["enable"] = true
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Name"]["attachTextTo"] = "InfoPanel"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Name"]["text_format"] = "[name:short]"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Name"]["yOffset"] = 0
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Name"]["font"] = "Continuum Medium"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Name"]["justifyH"] = "LEFT"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Name"]["fontOutline"] = "OUTLINE"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Name"]["xOffset"] = 18
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Name"]["size"] = 12
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Group"]["enable"] = true
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Group"]["attachTextTo"] = "InfoPanel"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Group"]["text_format"] = "[group]"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Group"]["yOffset"] = 0
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Group"]["font"] = "Continuum Medium"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Group"]["justifyH"] = "CENTER"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Group"]["fontOutline"] = "OUTLINE"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Group"]["xOffset"] = 0
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Group"]["size"] = 12
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Status"]["enable"] = true
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Status"]["attachTextTo"] = "Health"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Status"]["text_format"] = "[statustimer]"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Status"]["yOffset"] = -10
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Status"]["font"] = "Continuum Medium"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Status"]["justifyH"] = "CENTER"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Status"]["fontOutline"] = "OUTLINE"
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Status"]["xOffset"] = 0
			E.db["unitframe"]["units"]["player"]["customTexts"]["KyaUI_Status"]["size"] = 12
		-- CastBar:
			E.db["unitframe"]["units"]["player"]["castbar"]["insideInfoPanel"] = false
			E.db["unitframe"]["units"]["player"]["castbar"]["iconAttached"] = false
			E.db["unitframe"]["units"]["player"]["castbar"]["overlayOnFrame"] = "InfoPanel"
			E.db["unitframe"]["units"]["player"]["castbar"]["iconYOffset"] = 5
			E.db["unitframe"]["units"]["player"]["castbar"]["tickColor"]["a"] = 0.80000001192093
			E.db["unitframe"]["units"]["player"]["castbar"]["iconXOffset"] = -2
			E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 200
			E.db["unitframe"]["units"]["player"]["castbar"]["strataAndLevel"]["frameLevel"] = 13
			E.db["unitframe"]["units"]["player"]["castbar"]["iconAttachedTo"] = "Castbar"
			E.db["unitframe"]["units"]["player"]["castbar"]["iconSize"] = 30
			E.db["unitframe"]["units"]["player"]["castbar"]["format"] = "REMAININGMAX"
			E.db["unitframe"]["units"]["player"]["castbar"]["height"] = 40
			E.db["unitframe"]["units"]["player"]["castbar"]["textColor"]["b"] = 1
			E.db["unitframe"]["units"]["player"]["castbar"]["textColor"]["g"] = 1
			E.db["unitframe"]["units"]["player"]["castbar"]["textColor"]["r"] = 1
		-- Information Panel:
			E.db["unitframe"]["units"]["player"]["infoPanel"]["enable"] = true
			E.db["unitframe"]["units"]["player"]["infoPanel"]["transparent"] = true
		-- AuraBar:
			E.db["unitframe"]["units"]["player"]["aurabar"]["spacing"] = 1
		-- Buffs:
			E.db["unitframe"]["units"]["player"]["buffs"]["anchorPoint"] = "TOPRIGHT"
			E.db["unitframe"]["units"]["player"]["buffs"]["sizeOverride"] = 26
			E.db["unitframe"]["units"]["player"]["buffs"]["attachTo"] = "FRAME"
			E.db["unitframe"]["units"]["player"]["buffs"]["perrow"] = 4
			E.db["unitframe"]["units"]["player"]["buffs"]["countFont"] = "Continuum Medium"
			E.db["unitframe"]["units"]["player"]["buffs"]["priority"] = "Blacklist,MER_RaidCDs"
			E.db["unitframe"]["units"]["player"]["buffs"]["countFontSize"] = 9
			E.db["unitframe"]["units"]["player"]["buffs"]["yOffset"] = 1
		-- Debuffs:	
			E.db["unitframe"]["units"]["player"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
			E.db["unitframe"]["units"]["player"]["debuffs"]["sizeOverride"] = 30
			E.db["unitframe"]["units"]["player"]["debuffs"]["attachTo"] = "BUFFS"
			E.db["unitframe"]["units"]["player"]["debuffs"]["clickThrough"] = true
			E.db["unitframe"]["units"]["player"]["debuffs"]["perrow"] = 5
			E.db["unitframe"]["units"]["player"]["debuffs"]["countFont"] = "Continuum Medium"
			E.db["unitframe"]["units"]["player"]["debuffs"]["countFontSize"] = 10
			E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = 1
		-- ClassBar:		
			E.db["unitframe"]["units"]["player"]["classbar"]["autoHide"] = true
			E.db["unitframe"]["units"]["player"]["classbar"]["height"] = 14
			E.db["unitframe"]["units"]["player"]["classbar"]["detachedWidth"] = 285
			E.db["unitframe"]["units"]["player"]["classbar"]["fill"] = "filled"
		-- Fader:
			E.db["unitframe"]["units"]["player"]["fader"]["hover"] = false
			E.db["unitframe"]["units"]["player"]["fader"]["combat"] = false
			E.db["unitframe"]["units"]["player"]["fader"]["power"] = false
			E.db["unitframe"]["units"]["player"]["fader"]["vehicle"] = false
			E.db["unitframe"]["units"]["player"]["fader"]["casting"] = false
			E.db["unitframe"]["units"]["player"]["fader"]["health"] = false
			E.db["unitframe"]["units"]["player"]["fader"]["playertarget"] = false
		-- Combat Icon:
			E.db["unitframe"]["units"]["player"]["CombatIcon"]["anchorPoint"] = "LEFT"
			E.db["unitframe"]["units"]["player"]["CombatIcon"]["texture"] = "COMBAT"
			E.db["unitframe"]["units"]["player"]["CombatIcon"]["size"] = 12
			E.db["unitframe"]["units"]["player"]["CombatIcon"]["yOffset"] = 10	
		-- PvP Icon:
			E.db["unitframe"]["units"]["player"]["pvpIcon"]["anchorPoint"] = "TOPRIGHT"
			E.db["unitframe"]["units"]["player"]["pvpIcon"]["scale"] = 0.5
			E.db["unitframe"]["units"]["player"]["pvpIcon"]["xOffset"] = 7
			E.db["unitframe"]["units"]["player"]["pvpIcon"]["enable"] = true
			E.db["unitframe"]["units"]["player"]["pvpIcon"]["yOffset"] = 7
		-- Rest Icon:
			E.db["unitframe"]["units"]["player"]["RestIcon"]["enable"] = false
		-- Raid Icon:
			E.db["unitframe"]["units"]["player"]["raidicon"]["yOffset"] = 15
		-- Mover
			E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,518,86"
	-- Units: Focus
		E.db["unitframe"]["units"]["focus"]["debuffs"]["attachTo"] = "BUFFS"
		E.db["unitframe"]["units"]["focus"]["debuffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["focus"]["debuffs"]["yOffset"] = 1
		E.db["unitframe"]["units"]["focus"]["buffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["focus"]["buffs"]["sizeOverride"] = 26
		E.db["unitframe"]["units"]["focus"]["buffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["focus"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["focus"]["buffs"]["perrow"] = 4
		E.db["unitframe"]["units"]["focus"]["buffs"]["yOffset"] = 1
		E.db["unitframe"]["units"]["focus"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["focus"]["cutaway"]["health"]["enabled"] = true
		E.db["unitframe"]["units"]["focus"]["power"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["focus"]["power"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["focus"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["focus"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Health"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Health"]["enable"] = true
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Health"]["text_format"] = "[health:current-max-percent]"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Health"]["font"] = "Continuum Medium"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Health"]["justifyH"] = "LEFT"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Health"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Health"]["size"] = 12
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Name"]["enable"] = true
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Name"]["text_format"] = "[name:short]"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Name"]["font"] = "Continuum Medium"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Name"]["justifyH"] = "LEFT"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Name"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Name"]["xOffset"] = 18
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Name"]["size"] = 12
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Group"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Group"]["enable"] = true
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Group"]["text_format"] = "[group]"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Group"]["yOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Group"]["font"] = "Continuum Medium"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Group"]["justifyH"] = "CENTER"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Group"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Group"]["xOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Group"]["size"] = 12
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Status"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Status"]["enable"] = true
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Status"]["text_format"] = "[statustimer]"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Status"]["yOffset"] = -10
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Status"]["font"] = "Continuum Medium"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Status"]["justifyH"] = "CENTER"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Status"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Status"]["xOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["customTexts"]["KyaUI_Status"]["size"] = 12
		E.db["unitframe"]["units"]["focus"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["focus"]["width"] = 150
		E.db["unitframe"]["units"]["focus"]["infoPanel"]["height"] = 18
		E.db["unitframe"]["units"]["focus"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["focus"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["focus"]["castbar"]["overlayOnFrame"] = "InfoPanel"
		E.db["unitframe"]["units"]["focus"]["castbar"]["insideInfoPanel"] = false
		E.db["unitframe"]["units"]["focus"]["castbar"]["iconSize"] = 20
		E.db["unitframe"]["units"]["focus"]["castbar"]["width"] = 150
		E.db["unitframe"]["units"]["focus"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["focus"]["health"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["focus"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["focus"]["health"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["focus"]["height"] = 40
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOM,ElvUIParent,BOTTOM,-112,137"

	-- Units: Target	
		-- General:
			E.db["unitframe"]["units"]["target"]["threatStyle"] = "INFOPANELBORDER"
			E.db["unitframe"]["units"]["target"]["smartAuraPosition"] = "DEBUFFS_ON_BUFFS"
			E.db["unitframe"]["units"]["target"]["orientation"] = "LEFT"
			E.db["unitframe"]["units"]["target"]["disableMouseoverGlow"] = true
			E.db["unitframe"]["units"]["target"]["disableTargetGlow"] = true
			E.db["unitframe"]["units"]["target"]["disableFocusGlow"] = true
			E.db["unitframe"]["units"]["target"]["width"] = 195
			E.db["unitframe"]["units"]["target"]["height"] = 60
		-- Portrait:		
			E.db["unitframe"]["units"]["target"]["portrait"]["enabled"] = false
			E.db["unitframe"]["units"]["target"]["portrait"]["camDistanceScale"] = 1
		-- Health:
			E.db["unitframe"]["units"]["target"]["health"]["xOffset"] = 0
			E.db["unitframe"]["units"]["target"]["health"]["text_format"] = ""
			E.db["unitframe"]["units"]["target"]["health"]["colorOverride"] = "default"		
		-- Power:
			E.db["unitframe"]["units"]["target"]["power"]["attachTextTo"] = "InfoPanel"
			E.db["unitframe"]["units"]["target"]["power"]["powerPrediction"] = true
			E.db["unitframe"]["units"]["target"]["power"]["height"] = 8
			E.db["unitframe"]["units"]["target"]["power"]["strataAndLevel"]["frameLevel"] = 2
			E.db["unitframe"]["units"]["target"]["power"]["position"] = "LEFT"
			E.db["unitframe"]["units"]["target"]["power"]["detachedWidth"] = 285
			E.db["unitframe"]["units"]["target"]["power"]["hideonnpc"] = true
			E.db["unitframe"]["units"]["target"]["power"]["text_format"] = ""
			E.db["unitframe"]["units"]["target"]["power"]["xOffset"] = 0
		-- CustomTexts:		
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Health"]["enable"] = true
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Health"]["attachTextTo"] = "Health"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Health"]["text_format"] = "[health:current-max-percent]"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Health"]["yOffset"] = 0
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Health"]["font"] = "Continuum Medium"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Health"]["justifyH"] = "LEFT"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Health"]["fontOutline"] = "OUTLINE"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Health"]["xOffset"] = 0
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Health"]["size"] = 12
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Name"]["enable"] = true
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Name"]["attachTextTo"] = "InfoPanel"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Name"]["text_format"] = "[name:short]"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Name"]["yOffset"] = 0
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Name"]["font"] = "Continuum Medium"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Name"]["justifyH"] = "LEFT"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Name"]["fontOutline"] = "OUTLINE"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Name"]["xOffset"] = 18
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Name"]["size"] = 12
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Group"]["enable"] = true
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Group"]["attachTextTo"] = "InfoPanel"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Group"]["text_format"] = "[group]"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Group"]["yOffset"] = 0
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Group"]["font"] = "Continuum Medium"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Group"]["justifyH"] = "CENTER"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Group"]["fontOutline"] = "OUTLINE"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Group"]["xOffset"] = 0
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Group"]["size"] = 12
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Status"]["enable"] = true
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Status"]["attachTextTo"] = "Health"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Status"]["text_format"] = "[statustimer]"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Status"]["yOffset"] = -10
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Status"]["font"] = "Continuum Medium"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Status"]["justifyH"] = "CENTER"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Status"]["fontOutline"] = "OUTLINE"
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Status"]["xOffset"] = 0
			E.db["unitframe"]["units"]["target"]["customTexts"]["KyaUI_Status"]["size"] = 12
		-- CastBar:
			E.db["unitframe"]["units"]["target"]["castbar"]["insideInfoPanel"] = false
			E.db["unitframe"]["units"]["target"]["castbar"]["iconAttached"] = false
			E.db["unitframe"]["units"]["target"]["castbar"]["overlayOnFrame"] = "InfoPanel"
			E.db["unitframe"]["units"]["target"]["castbar"]["iconYOffset"] = 5
			E.db["unitframe"]["units"]["target"]["castbar"]["tickColor"]["a"] = 0.80000001192093
			E.db["unitframe"]["units"]["target"]["castbar"]["iconXOffset"] = -2
			E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 200
			E.db["unitframe"]["units"]["target"]["castbar"]["strataAndLevel"]["frameLevel"] = 13
			E.db["unitframe"]["units"]["target"]["castbar"]["iconAttachedTo"] = "Castbar"
			E.db["unitframe"]["units"]["target"]["castbar"]["iconSize"] = 30
			E.db["unitframe"]["units"]["target"]["castbar"]["format"] = "REMAININGMAX"
			E.db["unitframe"]["units"]["target"]["castbar"]["height"] = 40
			E.db["unitframe"]["units"]["target"]["castbar"]["textColor"]["b"] = 1
			E.db["unitframe"]["units"]["target"]["castbar"]["textColor"]["g"] = 1
			E.db["unitframe"]["units"]["target"]["castbar"]["textColor"]["r"] = 1
		-- Information Panel:
			E.db["unitframe"]["units"]["target"]["infoPanel"]["enable"] = true
			E.db["unitframe"]["units"]["target"]["infoPanel"]["transparent"] = true
		-- AuraBar:
			E.db["unitframe"]["units"]["target"]["aurabar"]["spacing"] = 1
		-- Buffs:
			E.db["unitframe"]["units"]["target"]["buffs"]["anchorPoint"] = "TOPLEFT"
			E.db["unitframe"]["units"]["target"]["buffs"]["sizeOverride"] = 26
			E.db["unitframe"]["units"]["target"]["buffs"]["perrow"] = 4
			E.db["unitframe"]["units"]["target"]["buffs"]["clickThrough"] = true
			E.db["unitframe"]["units"]["target"]["buffs"]["countFont"] = "Continuum Medium"
			E.db["unitframe"]["units"]["target"]["buffs"]["priority"] = "Blacklist,MER_RaidCDs"
			E.db["unitframe"]["units"]["target"]["buffs"]["countFontSize"] = 9
			E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 1
		-- Debuffs:	
			E.db["unitframe"]["units"]["target"]["debuffs"]["countFontSize"] = 10
			E.db["unitframe"]["units"]["target"]["debuffs"]["countFont"] = "Continuum Medium"
			E.db["unitframe"]["units"]["target"]["debuffs"]["yOffset"] = 1
			E.db["unitframe"]["units"]["target"]["debuffs"]["anchorPoint"] = "TOPLEFT"
			E.db["unitframe"]["units"]["target"]["debuffs"]["clickThrough"] = true
			E.db["unitframe"]["units"]["target"]["debuffs"]["maxDuration"] = 0
			E.db["unitframe"]["units"]["target"]["debuffs"]["priority"] = "Blacklist,Personal,nonPersonal"
			E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 30
			E.db["unitframe"]["units"]["target"]["debuffs"]["perrow"] = 5
		-- Fader:
			E.db["unitframe"]["units"]["target"]["fader"]["hover"] = false
			E.db["unitframe"]["units"]["target"]["fader"]["combat"] = false
			E.db["unitframe"]["units"]["target"]["fader"]["power"] = false
			E.db["unitframe"]["units"]["target"]["fader"]["vehicle"] = false
			E.db["unitframe"]["units"]["target"]["fader"]["casting"] = false
			E.db["unitframe"]["units"]["target"]["fader"]["health"] = false
			E.db["unitframe"]["units"]["target"]["fader"]["playertarget"] = false
		-- Combat Icon:
			E.db["unitframe"]["units"]["target"]["CombatIcon"]["anchorPoint"] = "LEFT"
			E.db["unitframe"]["units"]["target"]["CombatIcon"]["texture"] = "COMBAT"
			E.db["unitframe"]["units"]["target"]["CombatIcon"]["size"] = 12
			E.db["unitframe"]["units"]["target"]["CombatIcon"]["yOffset"] = 10	
		-- PvP Icon:
			E.db["unitframe"]["units"]["target"]["pvpIcon"]["anchorPoint"] = "TOPRIGHT"
			E.db["unitframe"]["units"]["target"]["pvpIcon"]["scale"] = 0.5
			E.db["unitframe"]["units"]["target"]["pvpIcon"]["xOffset"] = 7
			E.db["unitframe"]["units"]["target"]["pvpIcon"]["enable"] = true
			E.db["unitframe"]["units"]["target"]["pvpIcon"]["yOffset"] = 7
		-- Raid Icon:
			E.db["unitframe"]["units"]["target"]["raidicon"]["yOffset"] = 15
		-- Mover
			E.db["movers"]["ElvUF_TargetMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-519,86"
	
	-- Units: Raid
		E.db["unitframe"]["units"]["raid"]["horizontalSpacing"] = 1
		E.db["unitframe"]["units"]["raid"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["raid"]["debuffs"]["sizeOverride"] = 15
		E.db["unitframe"]["units"]["raid"]["debuffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["raid"]["debuffs"]["maxDuration"] = 0
		E.db["unitframe"]["units"]["raid"]["debuffs"]["priority"] = "Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
		E.db["unitframe"]["units"]["raid"]["debuffs"]["countFont"] = "Merathilis Expressway"
		E.db["unitframe"]["units"]["raid"]["debuffs"]["yOffset"] = -8
		E.db["unitframe"]["units"]["raid"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["font"] = "Continuum Medium"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontSize"] = 11
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["yOffset"] = 15
		E.db["unitframe"]["units"]["raid"]["numGroups"] = 8
		E.db["unitframe"]["units"]["raid"]["resurrectIcon"]["attachToObject"] = "Health"
		E.db["unitframe"]["units"]["raid"]["buffIndicator"]["size"] = 10
		E.db["unitframe"]["units"]["raid"]["classbar"]["enable"] = false
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = 1
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["size"] = 12
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["damager"] = false
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["health"]["orientation"] = "VERTICAL"
		E.db["unitframe"]["units"]["raid"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["raid"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["readycheckIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["readycheckIcon"]["size"] = 20
		E.db["unitframe"]["units"]["raid"]["readycheckIcon"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["raid"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Status"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Status"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Status"]["text_format"] = "[statustimer]"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Status"]["yOffset"] = -12
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Status"]["font"] = "Homespun"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Status"]["justifyH"] = "CENTER"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Status"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Status"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Status"]["size"] = 11
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Health"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Health"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Health"]["text_format"] = "[healthcolor][health:deficit]"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Health"]["font"] = "Continuum Medium"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Health"]["justifyH"] = "CENTER"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Health"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Health"]["size"] = 11
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Group"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Group"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Group"]["text_format"] = "[group]"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Group"]["yOffset"] = 25
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Group"]["font"] = "Continuum Medium"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Group"]["justifyH"] = "CENTER"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Group"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Group"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Group"]["size"] = 12
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Name"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Name"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Name"]["text_format"] = "[name:veryshort]"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Name"]["yOffset"] = 12
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Name"]["font"] = "Continuum Medium"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Name"]["justifyH"] = "CENTER"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Name"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Name"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["customTexts"]["KyaUI_Name"]["size"] = 14
		E.db["unitframe"]["units"]["raid"]["healPrediction"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["colorOverride"] = "default"
		E.db["unitframe"]["units"]["raid"]["width"] = 50
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["height"] = 13
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["raid"]["cutaway"]["health"]["enabled"] = true
		E.db["unitframe"]["units"]["raid"]["cutaway"]["power"]["enabled"] = true
		E.db["unitframe"]["units"]["raid"]["name"]["xOffset"] = 2
		E.db["unitframe"]["units"]["raid"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["raid"]["name"]["position"] = "BOTTOMLEFT"
		E.db["unitframe"]["units"]["raid"]["buffs"]["anchorPoint"] = "CENTER"
		E.db["unitframe"]["units"]["raid"]["buffs"]["sizeOverride"] = 20
		E.db["unitframe"]["units"]["raid"]["buffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["raid"]["buffs"]["priority"] = "MER_RaidCDs"
		E.db["unitframe"]["units"]["raid"]["buffs"]["countFont"] = "Merathilis Expressway"
		E.db["unitframe"]["units"]["raid"]["buffs"]["perrow"] = 1
		E.db["unitframe"]["units"]["raid"]["height"] = 48
		E.db["unitframe"]["units"]["raid"]["verticalSpacing"] = 1
		E.db["unitframe"]["units"]["raid"]["visibility"] = "[@raid6,exists]show;hide"
		E.db["unitframe"]["units"]["raid"]["raidicon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["raidicon"]["size"] = 15

	-- Units: Raid40
		E.db["unitframe"]["units"]["raid40"]["horizontalSpacing"] = 1
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["countFontSize"] = 9
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["countFont"] = "Merathilis Expressway"
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["yOffset"] = -9
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["maxDuration"] = 0
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["perrow"] = 2
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["priority"] = "Blacklist,Boss,RaidDebuffs,nonPersonal,CastByUnit,CCDebuffs,CastByNPC,Dispellable"
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["xOffset"] = -4
		E.db["unitframe"]["units"]["raid40"]["debuffs"]["sizeOverride"] = 21
		E.db["unitframe"]["units"]["raid40"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["font"] = "Continuum Medium"
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["yOffset"] = 4
		E.db["unitframe"]["units"]["raid40"]["growthDirection"] = "RIGHT_UP"
		E.db["unitframe"]["units"]["raid40"]["colorOverride"] = "default"
		E.db["unitframe"]["units"]["raid40"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["raid40"]["health"]["yOffset"] = 1
		E.db["unitframe"]["units"]["raid40"]["buffIndicator"]["size"] = 10
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["attachTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["size"] = 9
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["cutaway"]["health"]["enabled"] = true
		E.db["unitframe"]["units"]["raid40"]["groupBy"] = "ROLE"
		E.db["unitframe"]["units"]["raid40"]["readycheckIcon"]["size"] = 20
		E.db["unitframe"]["units"]["raid40"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["power"]["height"] = 3
		E.db["unitframe"]["units"]["raid40"]["power"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["raid40"]["healPrediction"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["width"] = 69
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["height"] = 13
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["raid40"]["buffs"]["anchorPoint"] = "CENTER"
		E.db["unitframe"]["units"]["raid40"]["buffs"]["sizeOverride"] = 17
		E.db["unitframe"]["units"]["raid40"]["buffs"]["clickThrough"] = true
		E.db["unitframe"]["units"]["raid40"]["buffs"]["countFontSize"] = 9
		E.db["unitframe"]["units"]["raid40"]["buffs"]["priority"] = "MER_RaidCDs"
		E.db["unitframe"]["units"]["raid40"]["buffs"]["countFont"] = "Merathilis Expressway"
		E.db["unitframe"]["units"]["raid40"]["buffs"]["perrow"] = 1
		E.db["unitframe"]["units"]["raid40"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid40"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["raid40"]["classHover"] = true
		E.db["unitframe"]["units"]["raid40"]["height"] = 35
		E.db["unitframe"]["units"]["raid40"]["verticalSpacing"] = 1
		E.db["unitframe"]["units"]["raid40"]["visibility"] = "[@raid21,noexists] hide;show"
		E.db["unitframe"]["units"]["raid40"]["raidicon"]["attachTo"] = "LEFT"
		E.db["unitframe"]["units"]["raid40"]["raidicon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["raidicon"]["xOffset"] = 9
		E.db["unitframe"]["units"]["raid40"]["raidicon"]["size"] = 13

	-- Units: Boss
		E.db["unitframe"]["units"]["boss"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["boss"]["debuffs"]["countFont"] = "Merathilis Expressway"
		E.db["unitframe"]["units"]["boss"]["debuffs"]["maxDuration"] = 300
		E.db["unitframe"]["units"]["boss"]["debuffs"]["perrow"] = 6
		E.db["unitframe"]["units"]["boss"]["debuffs"]["sizeOverride"] = 27
		E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = -16
		E.db["unitframe"]["units"]["boss"]["growthDirection"] = "UP"
		E.db["unitframe"]["units"]["boss"]["spacing"] = 24
		E.db["unitframe"]["units"]["boss"]["threatStyle"] = "HEALTHBORDER"
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconXOffset"] = 2
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconPosition"] = "RIGHT"
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconAttached"] = false
		E.db["unitframe"]["units"]["boss"]["castbar"]["width"] = 246
		E.db["unitframe"]["units"]["boss"]["castbar"]["timeToHold"] = 0.5
		E.db["unitframe"]["units"]["boss"]["width"] = 246
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["height"] = 17
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["boss"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["boss"]["name"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["boss"]["name"]["xOffset"] = 6
		E.db["unitframe"]["units"]["boss"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["boss"]["name"]["yOffset"] = 16
		E.db["unitframe"]["units"]["boss"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["health"]["yOffset"] = 13
		E.db["unitframe"]["units"]["boss"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["boss"]["health"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["boss"]["power"]["attachTextTo"] = "Power"
		E.db["unitframe"]["units"]["boss"]["power"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["boss"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["power"]["text_format"] = "[powercolor][power:percent]"
		E.db["unitframe"]["units"]["boss"]["power"]["height"] = 9
		E.db["unitframe"]["units"]["boss"]["height"] = 60
		E.db["unitframe"]["units"]["boss"]["buffs"]["maxDuration"] = 300
		E.db["unitframe"]["units"]["boss"]["buffs"]["countFont"] = "Merathilis Expressway"
		E.db["unitframe"]["units"]["boss"]["buffs"]["xOffset"] = -2
		E.db["unitframe"]["units"]["boss"]["buffs"]["sizeOverride"] = 27
		E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 16

	-- Colors
		E.db["unitframe"]["colors"]["healthclass"] = true
		E.db["unitframe"]["colors"]["healthMultiplier"] = 0.4
		E.db["unitframe"]["colors"]["colorhealthbyvalue"] = false
		E.db["unitframe"]["colors"]["invertPower"] = true
		E.db["unitframe"]["colors"]["castClassColor"] = true
		E.db["unitframe"]["colors"]["health_backdrop_dead"]["r"] = 0.14901960784314
		E.db["unitframe"]["colors"]["health_backdrop_dead"]["g"] = 0.003921568627451
		E.db["unitframe"]["colors"]["health_backdrop_dead"]["b"] = 0.003921568627451
		E.db["unitframe"]["colors"]["castColor"]["b"] = 0.1
		E.db["unitframe"]["colors"]["castColor"]["g"] = 0.1
		E.db["unitframe"]["colors"]["castColor"]["r"] = 0.1
		E.db["unitframe"]["colors"]["transparentCastbar"] = true
		E.db["unitframe"]["colors"]["frameGlow"]["targetGlow"]["enable"] = false
		E.db["unitframe"]["colors"]["frameGlow"]["mainGlow"]["class"] = true
		E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["a"] = 0.5
		E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["r"] = 0
		E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["g"] = 0
		E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["color"]["b"] = 0
		E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["class"] = true
		E.db["unitframe"]["colors"]["frameGlow"]["mouseoverGlow"]["texture"] = "ElvUI Norm"
		E.db["unitframe"]["colors"]["auraBarBuff"]["r"] = 0.95686066150665
		E.db["unitframe"]["colors"]["auraBarBuff"]["g"] = 0.54901838302612
		E.db["unitframe"]["colors"]["auraBarBuff"]["b"] = 0.72941017150879
		E.db["unitframe"]["colors"]["transparentAurabars"] = true
		E.db["unitframe"]["colors"]["forcehealthreaction"] = false

	-- Cooldown
		E.db["unitframe"]["cooldown"]["hhmmColor"]["r"] = 0.43137254901961
		E.db["unitframe"]["cooldown"]["hhmmColor"]["g"] = 0.43137254901961
		E.db["unitframe"]["cooldown"]["hhmmColor"]["b"] = 0.43137254901961
		E.db["unitframe"]["cooldown"]["mmssColor"]["r"] = 0.56078431372549
		E.db["unitframe"]["cooldown"]["mmssColor"]["g"] = 0.56078431372549
		E.db["unitframe"]["cooldown"]["mmssColor"]["b"] = 0.56078431372549
		E.db["unitframe"]["cooldown"]["secondsColor"]["b"] = 0
		E.db["unitframe"]["cooldown"]["daysColor"]["g"] = 0.4
		E.db["unitframe"]["cooldown"]["daysColor"]["r"] = 0.4
		E.db["unitframe"]["cooldown"]["checkSeconds"] = true
		E.db["unitframe"]["cooldown"]["fonts"]["enable"] = true
		E.db["unitframe"]["cooldown"]["fonts"]["font"] = "Continuum Medium"
		E.db["unitframe"]["cooldown"]["fonts"]["fontSize"] = 16
		E.db["unitframe"]["cooldown"]["hoursColor"]["r"] = 0.4

	-- General
		E.db["unitframe"]["smoothbars"] = true
		E.db["unitframe"]["font"] = "Continuum Medium"
		E.db["unitframe"]["smartRaidFilter"] = false
		E.db["unitframe"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["thinBorders"] = true

	-- Movers
		E.db["movers"]["BuffsMover"] = "TOPRIGHT,MMHolder,TOPLEFT,-7,-1"
		E.db["movers"]["ElvUF_FocusTargetMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-513,277"
		E.db["movers"]["TargetPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,231,215"
		E.db["movers"]["ElvUF_RaidpetMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,737"
		E.db["movers"]["ElvUF_PetCastbarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,296,285"
		E.db["movers"]["ArenaHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-515,-389"
		E.db["movers"]["ElvUF_AssistMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-248"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,243"
		E.db["movers"]["ElvUF_RaidMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,513,-361"
		E.db["movers"]["TotemBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,370"
		E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,241"
		E.db["movers"]["ElvUF_Raid40Mover"] = "TOPLEFT,ElvUIParent,TOPLEFT,12,-204"
		E.db["movers"]["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,220"
		E.db["movers"]["ElvUF_BodyGuardMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,444"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,97"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,309"
		E.db["movers"]["ElvNP_PlayerMover"] = "TOP,UIParent,CENTER,0,-150"
		E.db["movers"]["ElvUF_TankMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-186"
		E.db["movers"]["ElvUF_PartyMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,512,-361"
		E.db["movers"]["AltPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,268"

	--[[
		Role Profiles
	]]
	-- Based on Role
	if Role == L["Protection"] then
	elseif Role == L["Healer"] then
	elseif Role == L["DD w/o Pet"] then
	elseif Role == L["DD w/ Pet"] then
	end
	
	E:UpdateAll(true)
	PluginInstallStepComplete.message = KYA.Title.." "..L["Unitframes Set"].. " für "..Role.." gesetzt."
	PluginInstallStepComplete:Show()
end
function KYA:SetupNameplates() -- Used in KYA:SetupLayout()
	E.db["nameplates"]["cutaway"]["health"]["enabled"] = true
	E.db["nameplates"]["threat"]["useThreatColor"] = false
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["countFontSize"] = 8
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["countFont"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["iconPosition"] = "LEFT"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["fontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["iconOffsetY"] = -1
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["iconSize"] = 21
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["iconOffsetX"] = -2
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["countFontSize"] = 8
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["countFont"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["yOffset"] = 13
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["format"] = "[name:abbrev:long]"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["yOffset"] = -9
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["power"]["text"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["power"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["format"] = "[perhp<%]"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["level"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["level"]["yOffset"] = -9
	E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["title"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["TARGET"]["classpower"]["enable"] = true
	E.db["nameplates"]["units"]["TARGET"]["classpower"]["width"] = 144
	E.db["nameplates"]["units"]["TARGET"]["classpower"]["yOffset"] = 23
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["countFont"] = "Merathilis Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["font"] = "Merathilis Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["iconPosition"] = "LEFT"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["fontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["iconOffsetY"] = -1
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["iconSize"] = 21
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["iconOffsetX"] = -2
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["timeToHold"] = 0.8
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["questIcon"]["xOffset"] = 8
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["questIcon"]["fontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["questIcon"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["eliteIcon"]["xOffset"] = 1
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["eliteIcon"]["enable"] = true
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["font"] = "Merathilis Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["countFont"] = "Merathilis Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["yOffset"] = 13
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["text"]["font"] = "Merathilis Expressway"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["text"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["format"] = "[name:abbrev:long]"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["yOffset"] = -9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["format"] = "[perhp<%]"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["format"] = "[difficultycolor][level]"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["fontSize"] = 10
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["yOffset"] = -9
	E.db["nameplates"]["units"]["FRIENDLY_NPC"]["title"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["countFontSize"] = 8
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["spacing"] = 3
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["countFont"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["yOffset"] = 33
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["iconPosition"] = "LEFT"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["fontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["iconOffsetY"] = -1
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["iconSize"] = 21
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["iconOffsetX"] = -2
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["timeToHold"] = 0.8
	E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["xOffset"] = 8
	E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["fontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["questIcon"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["xOffset"] = 1
	E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["enable"] = true
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["countFont"] = "Merathilis Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["font"] = "Merathilis Expressway"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["priority"] = "Blacklist,RaidBuffsElvUI,PlayerBuffs,TurtleBuffs,CastByUnit"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["yOffset"] = 13
	E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["format"] = "[namecolor][name:abbrev:long]"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["yOffset"] = -9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["format"] = "[perhp<%]"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["format"] = "[difficultycolor][level]"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["yOffset"] = -9
	E.db["nameplates"]["units"]["ENEMY_NPC"]["title"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["countFontSize"] = 8
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["countFont"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["iconPosition"] = "LEFT"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["fontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["iconOffsetY"] = -1
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["iconSize"] = 21
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["iconOffsetX"] = -2
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["countFontSize"] = 8
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["countFont"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["font"] = "Merathilis Expressway"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["yOffset"] = 2
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["format"] = "[name:abbrev:long]"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["yOffset"] = -9
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["format"] = "[perhp<%]"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["level"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["level"]["fontSize"] = 10
	E.db["nameplates"]["units"]["ENEMY_PLAYER"]["title"]["font"] = "Expressway"
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["countFontSize"] = 8
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["countFont"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["numAuras"] = 8
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["fontSize"] = 10
	E.db["nameplates"]["units"]["PLAYER"]["debuffs"]["size"] = 24
	E.db["nameplates"]["units"]["PLAYER"]["power"]["text"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["PLAYER"]["power"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["PLAYER"]["level"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["PLAYER"]["level"]["fontSize"] = 10
	E.db["nameplates"]["units"]["PLAYER"]["health"]["text"]["fontSize"] = 9
	E.db["nameplates"]["units"]["PLAYER"]["health"]["text"]["format"] = "[perhp<%]"
	E.db["nameplates"]["units"]["PLAYER"]["health"]["text"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["PLAYER"]["name"]["fontSize"] = 10
	E.db["nameplates"]["units"]["PLAYER"]["name"]["format"] = "[name:abbrev:long]"
	E.db["nameplates"]["units"]["PLAYER"]["name"]["font"] = "Merathilis Gotham Narrow Black"
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["iconPosition"] = "LEFT"
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["fontSize"] = 9
	E.db["nameplates"]["units"]["PLAYER"]["castbar"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["countFontSize"] = 8
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["fontSize"] = 10
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["font"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["countFont"] = "Merathilis Gotham Narrow Black Black"
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["size"] = 20
	E.db["nameplates"]["units"]["PLAYER"]["buffs"]["yOffset"] = 2
	E.db["nameplates"]["clampToScreen"] = true
	E.db["nameplates"]["smoothbars"] = true
	E.db["nameplates"]["colors"]["glowColor"]["b"] = 0.98039215686275
	E.db["nameplates"]["colors"]["glowColor"]["g"] = 0.74901960784314
	E.db["nameplates"]["colors"]["glowColor"]["r"] = 0
	E.db["nameplates"]["fontOutline"] = "MONOCHROMEOUTLINE"
	E.db["nameplates"]["font"] = "Continuum Medium"
	E.db["nameplates"]["fontSize"] = 12
	E.db["nameplates"]["cooldown"]["hhmmColor"]["r"] = 0.43137254901961
	E.db["nameplates"]["cooldown"]["hhmmColor"]["g"] = 0.43137254901961
	E.db["nameplates"]["cooldown"]["hhmmColor"]["b"] = 0.43137254901961
	E.db["nameplates"]["cooldown"]["secondsColor"]["b"] = 0
	E.db["nameplates"]["cooldown"]["daysColor"]["g"] = 0.4
	E.db["nameplates"]["cooldown"]["daysColor"]["r"] = 0.4
	E.db["nameplates"]["cooldown"]["mmssColor"]["r"] = 0.56078431372549
	E.db["nameplates"]["cooldown"]["mmssColor"]["g"] = 0.56078431372549
	E.db["nameplates"]["cooldown"]["mmssColor"]["b"] = 0.56078431372549
	E.db["nameplates"]["cooldown"]["fonts"]["enable"] = true
	E.db["nameplates"]["cooldown"]["fonts"]["font"] = "Merathilis Expressway"
	E.db["nameplates"]["cooldown"]["hoursColor"]["r"] = 0.4
	
	if KYA.NP then
		E.db["nameplates"]["enabled"] = false
	else		
		E.db["nameplates"]["enabled"] = true
	end
end
function KYA:SetupTooltips()
	E.db["tooltip"]["showElvUIUsers"] = true
	E.db["tooltip"]["healthBar"]["height"] = 12
	E.db["tooltip"]["healthBar"]["font"] = "Continuum Medium"
	E.db["tooltip"]["cursorAnchorY"] = 15
	E.db["tooltip"]["font"] = "Continuum Medium"
	E.db["tooltip"]["cursorAnchor"] = true
	E.db["tooltip"]["alwaysShowRealm"] = true
	E.db["tooltip"]["cursorAnchorType"] = "ANCHOR_CURSOR_LEFT"
	E.db["tooltip"]["cursorAnchorX"] = -3
	E.db["tooltip"]["itemCount"] = "BOTH"
end
function KYA:SetupChat() -- Used in KYA:SetupLayout()
	E.db["chat"]["fontSize"] = 12
	E.db["chat"]["tabFontOutline"] = "OUTLINE"
	E.db["chat"]["tabFont"] = "Continuum Medium"
	E.db["chat"]["tabFontSize"] = 10
	E.db["chat"]["fade"] = false
	E.db["chat"]["fontOutline"] = "OUTLINE"
	E.db["chat"]["panelBackdrop"] = "HIDEBOTH"
	E.db["chat"]["customTimeColor"]["b"] = 0.48235294117647
	E.db["chat"]["customTimeColor"]["g"] = 0.50196078431373
	E.db["chat"]["customTimeColor"]["r"] = 0.49803921568627
	E.db["chat"]["panelColor"]["a"] = 0
	E.db["chat"]["panelColor"]["b"] = 0
	E.db["chat"]["panelColor"]["g"] = 0
	E.db["chat"]["panelColor"]["r"] = 0
	E.db["chat"]["copyChatLines"] = true
	E.db["chat"]["font"] = "Continuum Medium"
	E.db["chat"]["panelHeight"] = 200
	E.db["chat"]["timeStampFormat"] = "%H:%M:%S "
	E.db["chat"]["fadeTabsNoBackdrop"] = false
	E.db["chat"]["emotionIcons"] = false
	E.db["chat"]["hideChatToggles"] = true
	E.db["chat"]["panelWidth"] = 400
end
function KYA:SetupActionBars() -- Used in KYA:SetupLayout()	
	-- General
	E.db["actionbar"]["movementModifier"] = "ALT"
	E.db["actionbar"]["macrotext"] = true
	E.db["actionbar"]["desaturateOnCooldown"] = true
	E.db["actionbar"]["fontOutline"] = "OUTLINE"
	E.db["actionbar"]["globalFadeAlpha"] = 0.7
	E.db["actionbar"]["extraActionButton"]["scale"] = 0.75
	E.db["actionbar"]["font"] = "Bui Prototype"
	E.db["actionbar"]["transparent"] = true
	E.db["actionbar"]["useDrawSwipeOnCharges"] = true

	-- Primary ActionBar First
		E.db["actionbar"]["bar1"]["enabled"] = true
		E.db["actionbar"]["bar1"]["mouseover"] = false
		E.db["actionbar"]["bar1"]["clickThrough"] = false
		E.db["actionbar"]["bar1"]["buttons"] = 12
		E.db["actionbar"]["bar1"]["buttonsPerRow"] = 12
		E.db["actionbar"]["bar1"]["buttonsize"] = 40
		E.db["actionbar"]["bar1"]["buttonspacing"] = 1
		E.db["actionbar"]["bar1"]["point"] = 'BOTTOMLEFT'
		E.db["actionbar"]["bar1"]["backdrop"] = true
		E.db["actionbar"]["bar1"]["backdropSpacing"] = 1
		E.db["actionbar"]["bar1"]["heightMult"] = 1
		E.db["actionbar"]["bar1"]["widthMult"] = 1
		E.db["actionbar"]["bar1"]["alpha"] = 1
		E.db["actionbar"]["bar1"]["showGrid"] = true
		E.db["actionbar"]["bar1"]["inheritGlobalFade"] = false
		E.db["actionbar"]["bar1"]["visibility"] = "[petbattle] hide; show"
		E.db["movers"]["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,63"

	-- Primary ActionBar Second
		E.db["actionbar"]["bar2"]["enabled"] = true
		E.db["actionbar"]["bar2"]["mouseover"] = false
		E.db["actionbar"]["bar2"]["clickThrough"] = false
		E.db["actionbar"]["bar2"]["buttons"] = 12
		E.db["actionbar"]["bar2"]["buttonsPerRow"] = 12
		E.db["actionbar"]["bar2"]["buttonsize"] = 40
		E.db["actionbar"]["bar2"]["buttonspacing"] = 1
		E.db["actionbar"]["bar2"]["point"] = 'BOTTOMLEFT'
		E.db["actionbar"]["bar2"]["backdrop"] = true
		E.db["actionbar"]["bar2"]["backdropSpacing"] = 1
		E.db["actionbar"]["bar2"]["heightMult"] = 1
		E.db["actionbar"]["bar2"]["widthMult"] = 1
		E.db["actionbar"]["bar2"]["alpha"] = 1
		E.db["actionbar"]["bar2"]["showGrid"] = true
		E.db["actionbar"]["bar2"]["inheritGlobalFade"] = false
		E.db["actionbar"]["bar2"]["visibility"] = "[petbattle] hide; show"
		E.db["movers"]["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,0,20"

	-- Secondary ActionBar Left
		E.db["actionbar"]["bar3"]["enabled"] = true
		E.db["actionbar"]["bar3"]["mouseover"] = false
		E.db["actionbar"]["bar3"]["clickThrough"] = false
		E.db["actionbar"]["bar3"]["buttons"] = 12
		E.db["actionbar"]["bar3"]["buttonsPerRow"] = 6
		E.db["actionbar"]["bar3"]["buttonsize"] = 31
		E.db["actionbar"]["bar3"]["buttonspacing"] = 1
		E.db["actionbar"]["bar3"]["point"] = 'BOTTOMLEFT'
		E.db["actionbar"]["bar3"]["backdrop"] = true
		E.db["actionbar"]["bar3"]["backdropSpacing"] = 1
		E.db["actionbar"]["bar3"]["heightMult"] = 1
		E.db["actionbar"]["bar3"]["widthMult"] = 1
		E.db["actionbar"]["bar3"]["alpha"] = 1
		E.db["actionbar"]["bar3"]["showGrid"] = true
		E.db["actionbar"]["bar3"]["inheritGlobalFade"] = false
		E.db["actionbar"]["bar3"]["visibility"] = "[petbattle] hide; show"
		E.db["movers"]["ElvAB_3"] = "BOTTOMRIGHT,ElvAB_2,BOTTOMLEFT,1,0"

	-- Secondary ActionBar Right
		E.db["actionbar"]["bar5"]["enabled"] = true
		E.db["actionbar"]["bar5"]["mouseover"] = false
		E.db["actionbar"]["bar5"]["clickThrough"] = false
		E.db["actionbar"]["bar5"]["buttons"] = 12
		E.db["actionbar"]["bar5"]["buttonsPerRow"] = 6
		E.db["actionbar"]["bar5"]["buttonsize"] = 31
		E.db["actionbar"]["bar5"]["buttonspacing"] = 1
		E.db["actionbar"]["bar5"]["point"] = 'BOTTOMLEFT'
		E.db["actionbar"]["bar5"]["backdrop"] = true
		E.db["actionbar"]["bar5"]["backdropSpacing"] = 1
		E.db["actionbar"]["bar5"]["heightMult"] = 1
		E.db["actionbar"]["bar5"]["widthMult"] = 1
		E.db["actionbar"]["bar5"]["alpha"] = 1
		E.db["actionbar"]["bar5"]["showGrid"] = true
		E.db["actionbar"]["bar5"]["inheritGlobalFade"] = false
		E.db["actionbar"]["bar5"]["visibility"] = "[petbattle] hide; show"
		E.db["movers"]["ElvAB_5"] = "BOTTOMLEFT,ElvAB_2,BOTTOMRIGHT,-1,0"

	-- Extra ActionBar CombatOnly
		E.db["actionbar"]["bar6"]["enabled"] = true
		E.db["actionbar"]["bar6"]["mouseover"] = false
		E.db["actionbar"]["bar6"]["clickThrough"] = false
		E.db["actionbar"]["bar6"]["buttons"] = 12
		E.db["actionbar"]["bar6"]["buttonsPerRow"] = 12
		E.db["actionbar"]["bar6"]["buttonsize"] = 28
		E.db["actionbar"]["bar6"]["buttonspacing"] = 3
		E.db["actionbar"]["bar6"]["point"] = 'BOTTOMLEFT'
		E.db["actionbar"]["bar6"]["backdrop"] = true
		E.db["actionbar"]["bar6"]["backdropSpacing"] = 1
		E.db["actionbar"]["bar6"]["heightMult"] = 1
		E.db["actionbar"]["bar6"]["widthMult"] = 1
		E.db["actionbar"]["bar6"]["alpha"] = 1
		E.db["actionbar"]["bar6"]["showGrid"] = true
		E.db["actionbar"]["bar6"]["inheritGlobalFade"] = false
		E.db["movers"]["ElvAB_6"] = "BOTTOM,ElvAB_1,TOP,0,-1"

	-- Useless ActionBar
		E.db["actionbar"]["bar4"]["enabled"] = false
		E.db["actionbar"]["bar4"]["buttonsize"] = 24
		E.db["actionbar"]["bar4"]["buttonspacing"] = 4
		E.db["actionbar"]["bar4"]["visibility"] = "[petbattle] hide; show"
		E.db["actionbar"]["bar4"]["mouseover"] = true
		E.db["movers"]["ElvAB_4"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,371"

	-- Cooldown
		E.db["actionbar"]["cooldown"]["hhmmColor"]["b"] = 0.43137254901961
		E.db["actionbar"]["cooldown"]["hhmmColor"]["g"] = 0.43137254901961
		E.db["actionbar"]["cooldown"]["hhmmColor"]["r"] = 0.43137254901961
		E.db["actionbar"]["cooldown"]["secondsColor"]["b"] = 0
		E.db["actionbar"]["cooldown"]["daysColor"]["g"] = 0.4
		E.db["actionbar"]["cooldown"]["daysColor"]["r"] = 0.4
		E.db["actionbar"]["cooldown"]["mmssColor"]["b"] = 0.56078431372549
		E.db["actionbar"]["cooldown"]["mmssColor"]["g"] = 0.56078431372549
		E.db["actionbar"]["cooldown"]["mmssColor"]["r"] = 0.56078431372549
		E.db["actionbar"]["cooldown"]["fonts"]["enable"] = true
		E.db["actionbar"]["cooldown"]["fonts"]["font"] = "Merathilis Expressway"
		E.db["actionbar"]["cooldown"]["fonts"]["fontSize"] = 20
		E.db["actionbar"]["cooldown"]["hoursColor"]["r"] = 0.4
	
	-- StanceBar
		E.db["actionbar"]["stanceBar"]["inheritGlobalFade"] = true
		E.db["actionbar"]["stanceBar"]["point"] = "BOTTOMLEFT"
		E.db["actionbar"]["stanceBar"]["buttonspacing"] = 3
		E.db["actionbar"]["stanceBar"]["buttonsPerRow"] = 6
		E.db["actionbar"]["stanceBar"]["buttonsize"] = 22
		E.db["actionbar"]["stanceBar"]["backdrop"] = true
		E.db["movers"]["ShiftAB"] = "TOPLEFT,ElvUIParent,TOPLEFT,226,-4"

	-- PetBar
		E.db["actionbar"]["barPet"]["inheritGlobalFade"] = true
		E.db["actionbar"]["barPet"]["point"] = "BOTTOMLEFT"
		E.db["actionbar"]["barPet"]["buttons"] = 9
		E.db["actionbar"]["barPet"]["buttonspacing"] = 3
		E.db["actionbar"]["barPet"]["buttonsPerRow"] = 9
		E.db["actionbar"]["barPet"]["backdropSpacing"] = 4
		E.db["actionbar"]["barPet"]["buttonsize"] = 24
		E.db["movers"]["PetAB"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,150,245"
	
	E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,230"
	E.db["movers"]["ZoneAbility"] = "BOTTOM,ElvUIParent,BOTTOM,0,230"
	E.db["movers"]["MicrobarMover"] = "TOP,ElvUIParent,TOP,0,4"

	E:UpdateAll(true)
	--Show message about layout being set
	PluginInstallStepComplete.message = "Layout Set"
	PluginInstallStepComplete:Show()
end
function KYA:SetupAuras() -- Used in KYA:SetupLayout()
	E.db["auras"]["cooldown"]["secondsIndicator"]["b"] = 0
	E.db["auras"]["cooldown"]["minutesIndicator"]["r"] = 0.24705882352941
	E.db["auras"]["cooldown"]["minutesIndicator"]["g"] = 0.77647058823529
	E.db["auras"]["cooldown"]["minutesIndicator"]["b"] = 0.91764705882353
	E.db["auras"]["cooldown"]["hhmmColor"]["r"] = 0.43137254901961
	E.db["auras"]["cooldown"]["hhmmColor"]["g"] = 0.43137254901961
	E.db["auras"]["cooldown"]["hhmmColor"]["b"] = 0.43137254901961
	E.db["auras"]["cooldown"]["expireIndicator"]["g"] = 0
	E.db["auras"]["cooldown"]["expireIndicator"]["b"] = 0
	E.db["auras"]["cooldown"]["override"] = true
	E.db["auras"]["cooldown"]["useIndicatorColor"] = true
	E.db["auras"]["cooldown"]["hoursIndicator"]["r"] = 0.4
	E.db["auras"]["cooldown"]["mmssColor"]["r"] = 0.56078431372549
	E.db["auras"]["cooldown"]["mmssColor"]["g"] = 0.56078431372549
	E.db["auras"]["cooldown"]["mmssColor"]["b"] = 0.56078431372549
	E.db["auras"]["cooldown"]["daysIndicator"]["g"] = 0.4
	E.db["auras"]["cooldown"]["daysIndicator"]["r"] = 0.4
	E.db["auras"]["debuffs"]["countFontSize"] = 12
	E.db["auras"]["debuffs"]["horizontalSpacing"] = 5
	E.db["auras"]["debuffs"]["durationFontSize"] = 12
	E.db["auras"]["debuffs"]["size"] = 40
	E.db["auras"]["font"] = "Continuum Medium"
	E.db["auras"]["fontOutline"] = "OUTLINE"
	E.db["auras"]["fadeThreshold"] = 10
	E.db["auras"]["buffs"]["horizontalSpacing"] = 10
	E.db["auras"]["buffs"]["durationFontSize"] = 12
	E.db["auras"]["buffs"]["size"] = 40
	E.db["auras"]["buffs"]["verticalSpacing"] = 12
	E.db["auras"]["buffs"]["countFontSize"] = 12
	E.db["auras"]["buffs"]["wrapAfter"] = 10
	E.db["auras"]["timeYOffset"] = 34
end
function KYA:SetupBags() -- Used in KYA:SetupLayout()
	E.db["bags"]["countFontSize"] = 12
	E.db["bags"]["itemLevelFont"] = "Continuum Medium"
	E.db["bags"]["itemLevelFontSize"] = 12
	E.db["bags"]["itemLevelCustomColorEnable"] = true
	E.db["bags"]["sortInverted"] = false
	E.db["bags"]["bagSize"] = 42
	E.db["bags"]["junkIcon"] = true
	E.db["bags"]["junkDesaturate"] = true
	E.db["bags"]["transparent"] = true
	E.db["bags"]["vendorGrays"]["enable"] = true
	E.db["bags"]["bagWidth"] = 474
	E.db["bags"]["countFontOutline"] = "OUTLINE"
	E.db["bags"]["bankSize"] = 42
	E.db["bags"]["countFont"] = "Continuum Medium"
	E.db["bags"]["bankWidth"] = 474
	E.db["bags"]["moneyFormat"] = "CONDENSED"
	E.db["bags"]["scrapIcon"] = true
	E.db["bags"]["showBindType"] = true
	E.db["bags"]["cooldown"]["override"] = true
	E.db["bags"]["cooldown"]["hhmmColor"]["r"] = 0.43137254901961
	E.db["bags"]["cooldown"]["hhmmColor"]["g"] = 0.43137254901961
	E.db["bags"]["cooldown"]["hhmmColor"]["b"] = 0.43137254901961
	E.db["bags"]["cooldown"]["secondsColor"]["b"] = 0
	E.db["bags"]["cooldown"]["daysColor"]["g"] = 0.4
	E.db["bags"]["cooldown"]["daysColor"]["r"] = 0.4
	E.db["bags"]["cooldown"]["fonts"]["enable"] = true
	E.db["bags"]["cooldown"]["fonts"]["font"] = "Merathilis Expressway"
	E.db["bags"]["cooldown"]["fonts"]["fontSize"] = 20
	E.db["bags"]["cooldown"]["mmssColor"]["r"] = 0.56078431372549
	E.db["bags"]["cooldown"]["mmssColor"]["g"] = 0.56078431372549
	E.db["bags"]["cooldown"]["mmssColor"]["b"] = 0.56078431372549
	E.db["bags"]["cooldown"]["hoursColor"]["r"] = 0.4
	E.db["bags"]["itemLevelFontOutline"] = "OUTLINE"
	
	if KYA.BAG then
		E.db["bags"]["enabled"] = false
		E.db["bags"]["vendorGrays"]["enable"] = true
	else	
		E.db["bags"]["enabled"] = true
	end
end
function KYA:SetupAnchors() -- Used in KYA:SetupLayout()
	if not E.db.movers then E.db.movers = {} end

	-- MerathilisUI Anchorpoints
	if KYA.MUI then
		E.db["movers"]["mUI_RaidMarkerBarAnchor"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-277,178"
		E.db["movers"]["MER_RaidCDMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-4"
		E.db["movers"]["MER_AutoButtonAnchor3Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-459,189"
		E.db["movers"]["MER_SpecializationBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,288,374"
		E.db["movers"]["MER_MicroBarMover"] = "TOP,ElvUIParent,TOP,0,-19"
		E.db["movers"]["MER_LocPanel_Mover"] = "TOP,ElvUIParent,TOP,0,0"
		E.db["movers"]["MER_RaidMarkerBarAnchor"] = "BOTTOM,ElvUIParent,BOTTOM,0,181"
		E.db["movers"]["MER_RaidManager"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,412,24"
		E.db["movers"]["MER_OrderhallMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,2-2"
		E.db["movers"]["MER_AutoButtonAnchor2Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-458,227"
		E.db["movers"]["MER_EquipmentSetsBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,269,215"
		E.db["movers"]["MER_NotificationMover"] = "TOP,ElvUIParent,TOP,0,-107"
		E.db["movers"]["MER_MinimapButtonsToggleButtonMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,269"
		E.db["movers"]["MER_RaidBuffReminderMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,144"
		E.db["movers"]["MER_AutoButtonAnchor1Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-456,269"
		E.db["movers"]["DTPanelMER_RightChatTopMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-16,375"
		E.db["movers"]["DTPanelMER_BottomPanelMover"] = "BOTTOM,ElvUIParent,BOTTOM,3,249"
	end
	
	-- BenikUI Anchorpoints
	if KYA.BUI then
		E.db["movers"]["BuiDashboardMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-8"
	end

	--if KYA.WT then
		--E.db["movers"]["Wind_ParagonReputationToastFrameMover"] = "TOP,ElvUIParent,TOP,0,-369"
		--E.db["movers"]["WTSwitchButtonBarAnchor"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-63,-293"
		--E.db["movers"]["WTCombatAlertFrameMover"] = "TOP,ElvUIParent,TOP,0,-228"
		--E.db["movers"]["WTMinimapButtonBarAnchor"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,245"
		--E.db["movers"]["Wind_ChatBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,248"
	--end

	-- Chat Anchorpoints
	E.db["movers"]["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,43"
	E.db["movers"]["TooltipMover"] = "BOTTOMRIGHT,RightChatToggleButton,BOTTOMRIGHT,0,0"
	E.db["movers"]["LeftChatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,43"

	-- General Layout Anchorpoints
	E.db["movers"]["LootFrameMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,250,-104"
	E.db["movers"]["SocialMenuMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-187"
	E.db["movers"]["DurabilityFrameMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,402,168"
	E.db["movers"]["VehicleSeatMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,30,-191"
	E.db["movers"]["LossControlMover"] = "TOP,ElvUIParent,TOP,0,-491"
	E.db["movers"]["MirrorTimer1Mover"] = "TOP,ElvUIParent,TOP,-1,-96"
	E.db["movers"]["ObjectiveFrameMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-58,-291"
	E.db["movers"]["tokenHolderMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-123"
	E.db["movers"]["RequestStopButton"] = "TOP,ElvUIParent,TOP,0,-150"
	E.db["movers"]["TopCenterContainerMover"] = "TOP,ElvUIParent,TOP,0,-30"
	E.db["movers"]["GMMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,497,-4"
	E.db["movers"]["LocationMover"] = "TOP,ElvUIParent,TOP,0,-7"
	E.db["movers"]["MirrorTimer3Mover"] = "TOP,MirrorTimer2,BOTTOM,0,0"
	E.db["movers"]["TalkingHeadFrameMover"] = "TOP,ElvUIParent,TOP,0,-174"
	E.db["movers"]["MirrorTimer2Mover"] = "TOP,MirrorTimer1,BOTTOM,0,0"
	E.db["movers"]["DigSiteProgressBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,315"
	E.db["movers"]["alertFrameMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,839,-309"
	E.db["movers"]["PlayerNameplate"] = "BOTTOM,ElvUIParent,BOTTOM,0,359"
	E.db["movers"]["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-4"
	E.db["movers"]["BelowMinimapContainerMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-34,268"
	E.db["movers"]["BNETMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,285"
	E.db["movers"]["ElvUIBagMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-204,245"
	E.db["movers"]["ProfessionsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-3,-184"
	E.db["movers"]["LevelUpBossBannerMover"] = "TOP,ElvUIParent,TOP,0,-125"
	E.db["movers"]["VOICECHAT"] = "TOPLEFT,ElvUIParent,TOPLEFT,213,-262"
	E.db["movers"]["VehicleLeaveButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,220"
	E.db["movers"]["SquareMinimapButtonBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-5,-303"
	E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-516,-316"
	E.db["movers"]["WatchFrameMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-122,-292"
	E.db["movers"]["ElvUIBankMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,335"
	E.db["movers"]["AlertFrameMover"] = "TOP,ElvUIParent,TOP,0,-149"
	E.db["movers"]["DebuffsMover"] = "BOTTOMRIGHT,MMHolder,BOTTOMLEFT,-7,1"
	E.db["movers"]["TooltipMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-261,269"
	E.db["movers"]["MicrobarMover"] = "TOP,ElvUIParent,TOP,0,4"
	E.db["movers"]["ThreatBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,330"
	

	E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,148"
	E.db["movers"]["ZoneAbility"] = "BOTTOM,ElvUIParent,BOTTOM,0,148"


	

end
function KYA:SetupDataTexts() -- Used in KYA:SetupLayout()
	E.db["datatexts"]["goldCoins"] = true
	E.db["datatexts"]["wordWrap"] = true
	E.db["datatexts"]["font"] = "Continuum Medium"
	E.db["datatexts"]["fontOutline"] = "OUTLINE"
	E.db["datatexts"]["noCombatHover"] = true
	E.db["datatexts"]["goldFormat"] = "CONDENSED"

	
	E.db["datatexts"]["panels"]["RightChatDataPanel"]["enable"] = false
	E.db["datatexts"]["panels"]["RightChatDataPanel"]["panelTransparency"] = false
	E.db["datatexts"]["panels"]["LeftChatDataPanel"]["panelTransparency"] = false
	E.db["datatexts"]["panels"]["LeftChatDataPanel"]["right"] = "Quick Join"
	E.db["datatexts"]["panels"]["LeftChatDataPanel"]["enable"] = false
	E.db["datatexts"]["panels"]["LeftChatDataPanel"][3] = "Quick Join"
	
	if not E.db["datatexts"]["panels"]["KyaUI_RightDataTexts"] then 
		E.db["datatexts"]["panels"]["KyaUI_RightDataTexts"] = {}
		DT:BuildPanelFrame("KyaUI_RightDataTexts")
	end
	if not E.db["datatexts"]["panels"]["KyaUI_LeftDataTexts"] then 
		E.db["datatexts"]["panels"]["KyaUI_LeftDataTexts"] = {}
		DT:BuildPanelFrame("KyaUI_LeftDataTexts")
	end
	if not E.db["datatexts"]["panels"]["KyaUI_MiddleDataTexts"] then 
		E.db["datatexts"]["panels"]["KyaUI_MiddleDataTexts"] = {}
		DT:BuildPanelFrame("KyaUI_MiddleDataTexts") 
	end

	E.db["datatexts"]["panels"]["KyaUI_RightDataTexts"][1] = "System"
	E.db["datatexts"]["panels"]["KyaUI_RightDataTexts"][2] = "Date"
	E.db["datatexts"]["panels"]["KyaUI_RightDataTexts"][3] = "Gold"
	E.db["datatexts"]["panels"]["KyaUI_RightDataTexts"]["width"] = 400
	E.db["datatexts"]["panels"]["KyaUI_RightDataTexts"]["enable"] = true

	E.db["datatexts"]["panels"]["KyaUI_LeftDataTexts"][1] = "Coords"
	E.db["datatexts"]["panels"]["KyaUI_LeftDataTexts"][2] = "Durability"
	E.db["datatexts"]["panels"]["KyaUI_LeftDataTexts"][3] = "Mail"
	E.db["datatexts"]["panels"]["KyaUI_LeftDataTexts"]["width"] = 400
	E.db["datatexts"]["panels"]["KyaUI_LeftDataTexts"]["enable"] = true

	E.db["datatexts"]["panels"]["KyaUI_MiddleDataTexts"][1] = "Haste"
	E.db["datatexts"]["panels"]["KyaUI_MiddleDataTexts"][2] = "Crit"
	E.db["datatexts"]["panels"]["KyaUI_MiddleDataTexts"][3] = "Mastery"
	E.db["datatexts"]["panels"]["KyaUI_MiddleDataTexts"]["width"] = 400
	E.db["datatexts"]["panels"]["KyaUI_MiddleDataTexts"]["enable"] = true
	
	E.db["movers"]["DTPanelKyaUI_RightDataTextsMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,20"
	E.db["movers"]["DTPanelKyaUI_LeftDataTextsMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,20"
	E.db["movers"]["DTPanelKyaUI_MiddleDataTextsMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,0"

	if KYA.MUI then 
		E.db["datatexts"]["panels"]["MER_RightChatTop"][1] = "Missions"
		E.db["datatexts"]["panels"]["MER_RightChatTop"][2] = "Durability"
		E.db["datatexts"]["panels"]["MER_RightChatTop"][3] = "Gold"
		E.db["datatexts"]["panels"]["MER_RightChatTop"]["enable"] = false

		E.db["datatexts"]["panels"]["MER_BottomPanel"][1] = "Guild"
		E.db["datatexts"]["panels"]["MER_BottomPanel"][2] = "System"
		E.db["datatexts"]["panels"]["MER_BottomPanel"][3] = "Friends"
		E.db["datatexts"]["panels"]["MER_BottomPanel"]["enable"] = false
	end

	-- BenikUI Anchorpoints
	if KYA.BUI then
		
		E.db["benikui"]["datatexts"]["chat"]["enable"] = false
		E.db["benikui"]["datatexts"]["chat"]["transparent"] = true

		E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"][1] = "Durability"
		E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"][2] = "Missions (BenikUI)"
		E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"][3] = "BuiMail"

		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"][1] = "Haste"
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"][2] = "Crit Chance"
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"][3] = ""

		E.db["datatexts"]["panels"]["BuiRightChatDTPanel"][1] = "System"
		E.db["datatexts"]["panels"]["BuiRightChatDTPanel"][2] = "Bags"
		E.db["datatexts"]["panels"]["BuiRightChatDTPanel"][3] = "Gold"

		E.db["datatexts"]["panels"]["KyaUI_LeftDataTexts"][1] = "Durability" -- My Panels prefered, but with Beniks Texts
		E.db["datatexts"]["panels"]["KyaUI_LeftDataTexts"][2] = "Missions (BenikUI)" -- My Panels prefered, but with Beniks Texts
		E.db["datatexts"]["panels"]["KyaUI_LeftDataTexts"][3] = "BuiMail" -- My Panels prefered, but with Beniks Texts

		E.db["movers"]["BuiMiddleDtMover"] = "TOP,ElvAB_2,BOTTOM,0,0"
		E.db["movers"]["BuiLeftDtMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,0,20"
		E.db["movers"]["BuiRightDtMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,0,20"
	end

	PluginInstallStepComplete.message = "DataTexts Set"
	PluginInstallStepComplete:Show()

	E:StaggeredUpdateAll(nil, true)
end
function KYA:SetupGeneralLayout() -- Used in KYA:SetupLayout()

	-- General StuffE.db["general"]["totems"]["size"] = 50
		E.db["general"]["totems"]["growthDirection"] = "HORIZONTAL"
		E.db["general"]["totems"]["spacing"] = 8
		E.db["general"]["interruptAnnounce"] = "RAID"
		E.db["general"]["afk"] = false
		E.db["general"]["autoRepair"] = "PLAYER"
		E.db["general"]["minimap"]["locationFont"] = "Continuum Medium"
		E.db["general"]["minimap"]["locationFontSize"] = 10
		E.db["general"]["minimap"]["resetZoom"]["enable"] = true
		E.db["general"]["minimap"]["resetZoom"]["time"] = 5
		E.db["general"]["minimap"]["icons"]["difficulty"]["xOffset"] = 5
		E.db["general"]["minimap"]["icons"]["difficulty"]["yOffset"] = -5
		E.db["general"]["minimap"]["icons"]["lfgEye"]["xOffset"] = 0
		E.db["general"]["minimap"]["icons"]["lfgEye"]["scale"] = 1.1
		E.db["general"]["minimap"]["icons"]["mail"]["xOffset"] = 0
		E.db["general"]["minimap"]["icons"]["mail"]["yOffset"] = -5
		E.db["general"]["minimap"]["icons"]["mail"]["position"] = "BOTTOMLEFT"
		E.db["general"]["minimap"]["icons"]["classHall"]["scale"] = 0.6
		E.db["general"]["minimap"]["icons"]["classHall"]["position"] = "TOPRIGHT"
		E.db["general"]["minimap"]["size"] = 220
		E.db["general"]["decimalLength"] = 2
		E.db["general"]["talkingHeadFrameBackdrop"] = true
		E.db["general"]["resurrectSound"] = true
		E.db["general"]["backdropfadecolor"]["a"] = 0.55265957117081
		E.db["general"]["backdropfadecolor"]["b"] = 0
		E.db["general"]["backdropfadecolor"]["g"] = 0
		E.db["general"]["backdropfadecolor"]["r"] = 0
		E.db["general"]["objectiveFrameHeight"] = 400
		E.db["general"]["loginmessage"] = false
		E.db["general"]["itemLevel"]["itemLevelFont"] = "Continuum Medium"
		E.db["general"]["backdropcolor"]["b"] = 0.070588235294118
		E.db["general"]["backdropcolor"]["g"] = 0.070588235294118
		E.db["general"]["backdropcolor"]["r"] = 0.070588235294118
		E.db["general"]["vehicleSeatIndicatorSize"] = 76
		E.db["general"]["autoRoll"] = true
		E.db["general"]["font"] = "Continuum Medium"
		E.db["general"]["altPowerBar"]["textFormat"] = "NAMECURMAXPERC"
		E.db["general"]["altPowerBar"]["statusBarColorGradient"] = true
		E.db["general"]["altPowerBar"]["fontSize"] = 11
		E.db["general"]["altPowerBar"]["smoothbars"] = true
		E.db["general"]["altPowerBar"]["font"] = "Continuum Medium"
		E.db["general"]["valuecolor"]["r"] = 0.99999779462814
		E.db["general"]["valuecolor"]["g"] = 0.48627343773842
		E.db["general"]["valuecolor"]["b"] = 0.039215601980686
		E.db["general"]["autoTrackReputation"] = true
		E.db["general"]["talkingHeadFrameScale"] = 1
		E.db["general"]["bonusObjectivePosition"] = "AUTO"
		E.db["general"]["topPanel"] = true

		E.db["v11NamePlateReset"] = true
		E.db["layoutSetting"] = "healer"

	-- Tooltip
		E.db["tooltip"]["showElvUIUsers"] = true
		E.db["tooltip"]["healthBar"]["height"] = 12
		E.db["tooltip"]["healthBar"]["font"] = "Continuum Medium"
		E.db["tooltip"]["healthBar"]["fontSize"] = 10
		E.db["tooltip"]["healthBar"]["fontOutline"] = "OUTLINE"
		E.db["tooltip"]["cursorAnchorY"] = 15
		E.db["tooltip"]["font"] = "Continuum Medium"
		E.db["tooltip"]["cursorAnchor"] = true
		E.db["tooltip"]["alwaysShowRealm"] = true
		E.db["tooltip"]["cursorAnchorType"] = "ANCHOR_CURSOR_LEFT"
		E.db["tooltip"]["cursorAnchorX"] = -3
		E.db["tooltip"]["itemCount"] = "BOTH"
end

function KYA:SetupAddons()	
	if KYA.WT then
		print(KYA.WT)
		--E.db["WT"]["announcement"]["taunt"]["enable"] = false
		--E.db["WT"]["announcement"]["taunt"]["player"]["player"]["enable"] = false
		--E.db["WT"]["announcement"]["quest"]["paused"] = false
		--E.db["WT"]["combat"]["combatAlert"]["animation"] = false
		--E.db["WT"]["combat"]["combatAlert"]["enable"] = false
		--E.db["WT"]["combat"]["combatAlert"]["text"] = false
		--E.db["WT"]["combat"]["raidMarkers"]["enable"] = false
		
		--E.db["WT"]["item"]["extraItemsBar"]["enable"] = false
		--E.db["WT"]["social"]["chatBar"]["buttonHeight"] = 11
		--E.db["WT"]["social"]["chatBar"]["channels"]["RAID_WARNING"]["enable"] = true
		--E.db["WT"]["quest"]["switchButtons"]["announcement"] = false
	end
end
--This function will hold your layout settings
function KYA:SetupLayout(layout)
	KYA:SetupAnchors()
	KYA:SetupGeneralLayout()
	KYA:SetupBags()
	KYA:SetupAuras()
	KYA:SetupNameplates()
	KYA:SetupChat()
	KYA:SetupTooltips()
	KYA:SetupAddons()

	-- If BenikUI is loaded
	if KYA.BUI then 
		E.db["benikui"]["misc"]["afkMode"] = false
		E.db["benikui"]["misc"]["flightMode"]["enable"] = false
		E.db["benikui"]["misc"]["ilevel"]["enable"] = false
		E.db["benikui"]["misc"]["ilevel"]["font"] = "Expressway"
		E.db["benikui"]["misc"]["ilevel"]["fontsize"] = 10
		E.db["benikui"]["colors"]["gameMenuColor"] = 1
		E.db["benikui"]["colors"]["styleAlpha"] = 0.7
		E.db["benikui"]["colors"]["abAlpha"] = 0.7
		E.db["benikui"]["unitframes"]["infoPanel"]["texture"] = "MerathilisOnePixel"
		E.db["benikui"]["general"]["splashScreen"] = false
		E.db["benikui"]["general"]["hideStyle"] = true
		E.db["benikui"]["general"]["shadows"] = false
		E.db["benikui"]["general"]["loginMessage"] = false
		E.db["benikui"]["general"]["benikuiStyle"] = false
		E.db["benikui"]["actionbars"]["style"]["bar3"] = false
		E.db["benikui"]["actionbars"]["style"]["bar6"] = false
		E.db["benikui"]["actionbars"]["style"]["stancebar"] = false
		E.db["benikui"]["actionbars"]["style"]["bar2"] = false
		E.db["benikui"]["actionbars"]["style"]["bar1"] = false
		E.db["benikui"]["actionbars"]["style"]["petbar"] = false
		E.db["benikui"]["actionbars"]["style"]["bar5"] = false
		E.db["benikui"]["actionbars"]["style"]["bar4"] = false
		E.db["benikui"]["actionbars"]["toggleButtons"]["chooseAb"] = "BAR1"
		E.db["dashboards"]["tokens"]["enableTokens"] = false
		E.db["dashboards"]["professions"]["enableProfessions"] = false
		E.db["dashboards"]["system"]["enableSystem"] = false
	end
	-- If MerathilisUI is loaded
	if KYA.MUI then
		E.db["mui"]["misc"]["funstuff"] = false
		E.db["mui"]["misc"]["alerts"]["announce"] = false
		E.db["mui"]["general"]["AFK"] = false
		E.db["mui"]["general"]["splashScreen"] = false
		E.db["mui"]["general"]["style"] = false
		E.db["mui"]["general"]["shadowOverlay"] = false
		E.db["mui"]["panels"]["stylePanels"]["topRightPanel"] = false
		E.db["mui"]["panels"]["stylePanels"]["bottomRightPanel"] = false
		E.db["mui"]["panels"]["stylePanels"]["bottomLeftPanel"] = false
		E.db["mui"]["panels"]["stylePanels"]["topRightExtraPanel"] = false
		E.db["mui"]["panels"]["stylePanels"]["topLeftPanel"] = false
		E.db["mui"]["panels"]["bottomPanel"] = false
		E.db["mui"]["panels"]["topPanel"] = false
		E.db["mui"]["unitframes"]["gcd"]["enable"] = false
		E.db["mui"]["unitframes"]["gcd"]["color"]["b"] = 0.69411764705882
		E.db["mui"]["unitframes"]["gcd"]["color"]["g"] = 0.69411764705882
		E.db["mui"]["unitframes"]["gcd"]["color"]["r"] = 0.69411764705882
		E.db["mui"]["unitframes"]["swing"]["enable"] = false
		E.db["mui"]["cooldownFlash"]["maxAlpha"] = 0.7
		E.db["mui"]["cooldownFlash"]["iconSize"] = 50
		E.db["mui"]["cooldownFlash"]["showSpellName"] = true
		E.db["mui"]["cooldownFlash"]["enable"] = false
		E.db["mui"]["cooldownFlash"]["animScale"] = 1.6
		E.db["mui"]["raidCD"]["expiration"] = true
		E.db["mui"]["raidCD"]["text"]["fontSize"] = 12
		E.db["mui"]["raidCD"]["text"]["font"] = "Continuum Medium"
		E.db["mui"]["raidCD"]["show_inparty"] = true
		E.db["mui"]["actionbars"]["autoButtons"]["enable"] = false
		E.db["mui"]["actionbars"]["specBar"]["enable"] = false
		E.db["mui"]["actionbars"]["equipBar"]["enable"] = false
		E.db["mui"]["locPanel"]["colorType_Coords"] = "CLASS"
		E.db["mui"]["locPanel"]["font"] = "Merathilis Expressway"
		E.db["mui"]["locPanel"]["colorType"] = "DEFAULT"
		E.db["mui"]["locPanel"]["height"] = 20
		E.db["mui"]["locPanel"]["width"] = 330
		E.db["mui"]["cvars"]["general"]["alwaysCompareItems"] = true
		E.db["mui"]["cvars"]["general"]["autoLootDefault"] = true
		E.db["mui"]["cvars"]["combatText"]["targetCombatText"]["floatingCombatTextCombatLogPeriodicSpells"] = true
		E.db["mui"]["cvars"]["combatText"]["targetCombatText"]["floatingCombatTextCombatHealingAbsorbTarget"] = true
		E.db["mui"]["cvars"]["combatText"]["targetCombatText"]["floatingCombatTextCombatHealing"] = true
		E.db["mui"]["cvars"]["combatText"]["targetCombatText"]["floatingCombatTextCombatDamage"] = true
		E.db["mui"]["cvars"]["combatText"]["targetCombatText"]["floatingCombatTextSpellMechanics"] = true
		E.db["mui"]["cvars"]["combatText"]["targetCombatText"]["floatingCombatTextSpellMechanicsOther"] = true
		E.db["mui"]["cvars"]["combatText"]["playerCombatText"]["enableFloatingCombatText"] = true
		E.db["mui"]["media"]["zoneText"]["subzone"]["font"] = "Continuum Medium"
		E.db["mui"]["media"]["zoneText"]["zone"]["font"] = "Continuum Medium"
		E.db["mui"]["media"]["zoneText"]["zone"]["font"] = "Continuum Medium"
		E.db["mui"]["chat"]["chatFade"]["enable"] = false
		E.db["mui"]["chat"]["emotes"] = false
		E.db["mui"]["reminder"]["enable"] = false
		E.db["mui"]["raidmarkers"]["enable"] = false
		E.db["mui"]["raidmarkers"]["modifier"] = "ctrl-"
	end


	--[[
	--	This section at the bottom is just to update ElvUI and display a message
	--]]
	--Update ElvUI
	E:UpdateAll(true)
	--Show message about layout being set
	PluginInstallStepComplete.message = "Layout Set"
	PluginInstallStepComplete:Show()
end


--This function is executed when you press "Skip Process" or "Finished" in the installer.
	local function InstallComplete()
		if GetCVarBool("Sound_EnableMusic") then
			StopMusic()
		end
	
		--Set a variable tracking the version of the addon when layout was installed
		--E.db[KYAUI].install_version = Version
		E.private.install_complete = E.version
		E.db.kyaui.installed = true
	
		ReloadUI()
	end

KYA.installTable = {
	["Name"] = KYA.Title,
	["Title"] = KYA.Title.." - Installation",
	["tutorialImage"] = KYA.Logo,
	["tutorialImageSize"] = {256, 128},
	["tutorialImagePoint"] = {0, 30},
	--tutorialImage = "Interface\\AddOns\\KeYaraART\\media\\textures\\keyara_art_logo.tga", --If you have a logo you want to use, otherwise it uses the one from ElvUI
	Pages = {
		[1] = function()
			PluginInstallFrame.SubTitle:SetFormattedText("Welcome to the installation for %s.", KYA.Title)
			PluginInstallFrame.Desc1:SetText("This installation process will guide you through a few steps and apply settings to your current ElvUI profile. If you want to be able to go back to your original settings then create a new profile before going through this installation process.")
			PluginInstallFrame.Desc2:SetText("Please press the continue button if you wish to go through the installation process, otherwise click the 'Skip Process' button.")
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", InstallComplete)
			PluginInstallFrame.Option1:SetText("Skip Process")
		end,
		[2] = function()
			PluginInstallFrame.SubTitle:SetText(L["General"])
			PluginInstallFrame.Desc1:SetText(L["Setup General Layout"])
			PluginInstallFrame.Desc2:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() KYA:SetupLayout() end)
			PluginInstallFrame.Option1:SetText("Set General Layout")
		end,
		[3] = function()
			PluginInstallFrame.SubTitle:SetText("DataTexts")
			PluginInstallFrame.Desc1:SetText("Setup DataTexts")
			PluginInstallFrame.Desc2:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() KYA:SetupDataTexts() end)
			PluginInstallFrame.Option1:SetText("Set DataTexts")
		end,
		[4] = function()
			PluginInstallFrame.SubTitle:SetText("ActionBars")
			PluginInstallFrame.Desc1:SetText("Setup ActionBars")
			PluginInstallFrame.Desc2:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() KYA:SetupActionBars() end)
			PluginInstallFrame.Option1:SetText("Set ActionBars")
		end,
		[5] = function()
			PluginInstallFrame.SubTitle:SetText(L["UnitFrames"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process will reposition your Unitframes."])
			PluginInstallFrame.Desc2:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() KYA:SetupUnitframes(L["Protection"]) end)
			PluginInstallFrame.Option1:SetText(L["Protection"])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() KYA:SetupUnitframes(L["Heal"]) end)
			PluginInstallFrame.Option2:SetText(L["Heal"])
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript("OnClick", function() KYA:SetupUnitframes(L["DD w/o Pet"]) end)
			PluginInstallFrame.Option3:SetText(L["DD w/o Pet"])
			PluginInstallFrame.Option4:Show()
			PluginInstallFrame.Option4:SetScript("OnClick", function() KYA:SetupUnitframes(L["DD w/ Pet"]) end)
			PluginInstallFrame.Option4:SetText(L["DD w/ Pet"])
		end,
		[6] = function()
			PluginInstallFrame.SubTitle:SetText(L["DataBars"])
			PluginInstallFrame.Desc1:SetText(L["Setup DataBars"])
			PluginInstallFrame.Desc2:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() KYA:SetupDataBars() end)
			PluginInstallFrame.Option1:SetText(L["Setup DataBars"])
		end,
		[7] = function()
			PluginInstallFrame.SubTitle:SetText(L["Installation Complete"])
			PluginInstallFrame.Desc1:SetText("You have completed the installation process.")
			PluginInstallFrame.Desc2:SetText("Please click the button below in order to finalize the process and automatically reload your UI.")
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", InstallComplete)
			PluginInstallFrame.Option1:SetText("Finished")
		end,
	},
	StepTitles = {
		[1] = L["Welcome"],
		[2] = L["General"],
		[3] = "DataTexts",
		[4] = "ActionBars",
		[5] = L["Unitframes"],
		[6] = L["DataBars"],
		[7] = L["Installation Complete"],
	},
	StepTitlesColor = {1, 1, 1},
	StepTitlesColorSelected = {0, 179/255, 1},
	StepTitleWidth = 200,
	StepTitleButtonWidth = 180,
	StepTitleTextJustification = "RIGHT",
}
