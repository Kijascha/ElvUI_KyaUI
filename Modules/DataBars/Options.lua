local KYA, E, L, V, P, G = unpack(select(2, ...))
local DB = KYA:GetModule('DataBars')
local DBO = E:GetModule('DataBars')

local gsub = gsub
local wipe = wipe
local next = next
local pairs = pairs
local format = format
local strmatch = strmatch
local tonumber = tonumber
local tostring = tostring
local C = {}
C.Values = {
	FontFlags = {
		NONE = L["NONE"],
		OUTLINE = 'Outline',
		THICKOUTLINE = 'Thick',
		MONOCHROME = '|cffaaaaaaMono|r',
		MONOCHROMEOUTLINE = '|cffaaaaaaMono|r Outline',
		MONOCHROMETHICKOUTLINE = '|cffaaaaaaMono|r Thick',
	},
	FontSize = { min = 8, max = 64, step = 1 },
	Strata = { BACKGROUND = 'BACKGROUND', LOW = 'LOW', MEDIUM = 'MEDIUM', HIGH = 'HIGH', DIALOG = 'DIALOG', TOOLTIP = 'TOOLTIP' },
	GrowthDirection = {
		DOWN_RIGHT = format(L["%s and then %s"], L["Down"], L["Right"]),
		DOWN_LEFT = format(L["%s and then %s"], L["Down"], L["Left"]),
		UP_RIGHT = format(L["%s and then %s"], L["Up"], L["Right"]),
		UP_LEFT = format(L["%s and then %s"], L["Up"], L["Left"]),
		RIGHT_DOWN = format(L["%s and then %s"], L["Right"], L["Down"]),
		RIGHT_UP = format(L["%s and then %s"], L["Right"], L["Up"]),
		LEFT_DOWN = format(L["%s and then %s"], L["Left"], L["Down"]),
		LEFT_UP = format(L["%s and then %s"], L["Left"], L["Up"]),
	},
	AllPoints = { TOPLEFT = 'TOPLEFT', LEFT = 'LEFT', BOTTOMLEFT = 'BOTTOMLEFT', RIGHT = 'RIGHT', TOPRIGHT = 'TOPRIGHT', BOTTOMRIGHT = 'BOTTOMRIGHT', CENTER = 'CENTER', TOP = 'TOP', BOTTOM = 'BOTTOM' }
}
function AddSoulAshBarOptions()
    local ACH = E.Libs.ACH;
    table.foreach(C,print)
    local SharedOptions = {
        enable = ACH:Toggle(L["Enable"], nil, 1),
        textFormat = E.Libs.ACH:Select(L["Text Format"], nil, 2, { 
            NONE = L["NONE"], 
            CUR = L["Current"], 
            --CURPERWEEK = L["Weekly: Current"],
            REM = L["Remaining"], 
            --CURPERWEEK = L["Weekly: Remaining"],
            PERCENT = L["Percent"], 
            --PERCENTPERWEEK = L["Weekly: Percent"],
            CURMAX = L["Current - Max"], 
            --CURMAXPERWEEK = L["Weekly: Current - Max"],
            CURPERC = L["Current - Percent"],
            --CURPERCPERWEEK = L["Weekly: Current - Percent"], 
            CURREM = L["Current - Remaining"], 
            --CURREMPERWEEK = L["Weekly: Current - Remaining"], 
            CURPERCREM = L["Current - Percent (Remaining)"],
            --CURPERCREMPERWEEK = L["Weekly: Current - Percent (Remaining)"],  
        }),
        mouseover = E.Libs.ACH:Toggle(L["Mouseover"], nil, 3),
        clickThrough = E.Libs.ACH:Toggle(L["Click Through"], nil, 4),
        showBubbles = E.Libs.ACH:Toggle(L["Show Bubbles"], nil, 5),
        sizeGroup = E.Libs.ACH:Group(L["Size"], nil, -3),
        conditionGroup = E.Libs.ACH:MultiSelect(L["Conditions"], nil, -2),
        fontGroup = E.Libs.ACH:Group(L["Fonts"], nil, -1),
    }

    SharedOptions.sizeGroup.inline = true
    SharedOptions.sizeGroup.args.width = E.Libs.ACH:Range(L["Width"], nil, 1, { min = 5, max = ceil(GetScreenWidth() or 800), step = 1 })
    SharedOptions.sizeGroup.args.height = E.Libs.ACH:Range(L["Height"], nil, 2, { min = 5, max = ceil(GetScreenWidth() or 800), step = 1 })
    SharedOptions.sizeGroup.args.orientation = E.Libs.ACH:Select(L["Statusbar Fill Orientation"], L["Direction the bar moves on gains/losses"], 3, { AUTOMATIC = L["Automatic"], HORIZONTAL = L["Horizontal"], VERTICAL = L["Vertical"] })
    SharedOptions.sizeGroup.args.reverseFill = E.Libs.ACH:Toggle(L["Reverse Fill Direction"], nil, 4)

    SharedOptions.fontGroup.inline = true
    SharedOptions.fontGroup.args.font = E.Libs.ACH:SharedMediaFont(L["Font"], nil, 1)
    SharedOptions.fontGroup.args.fontSize = E.Libs.ACH:Range(L["Font Size"], nil, 2, C.Values.FontSize)
    SharedOptions.fontGroup.args.fontOutline = E.Libs.ACH:Select(L["Font Outline"], nil, 3, C.Values.FontFlags)

    E.Options.args.databars.args.colorGroup.args.soulash = ACH:Color("Soulash", nil, 5, true, nil, nil, function(info, r, g, b, a) local t = E.db.databars.colors[info[#info]] t.r, t.g, t.b, t.a = r, g, b, a DBO:SoulAshBar_Update() end)

    E.Options.args.databars.args.soulash = E.Libs.ACH:Group("Soulash", nil, 6, nil, function(info) return DBO.db.soulash[info[#info]] end, function(info, value) DBO.db.soulash[info[#info]] = value DBO:SoulAshBar_Update() DBO:UpdateAll() end)
    E.Options.args.databars.args.soulash.args = CopyTable(SharedOptions)
    E.Options.args.databars.args.soulash.args.enable.set = function(info, value) DBO.db.soulash[info[#info]] = value DBO:SoulAshBar_Toggle() DBO:UpdateAll() end
    E.Options.args.databars.args.soulash.args.textFormat.set = function(info, value) DBO.db.soulash[info[#info]] = value DBO:SoulAshBar_Update() end
    E.Options.args.databars.args.soulash.args.conditionGroup.get = function(_, key) return DBO.db.soulash[key] end
    E.Options.args.databars.args.soulash.args.conditionGroup.set = function(_, key, value) DBO.db.soulash[key] = value DBO:SoulAshBar_Update() DBO:UpdateAll() end
    E.Options.args.databars.args.soulash.args.conditionGroup.values = {
        hideInVehicle = L["Hide In Vehicle"],
        hideInCombat = L["Hide In Combat"],
        hideAtMaxLevel = L["Hide At Max Level"],
    }

end
tinsert(KYA.Config, AddSoulAshBarOptions)