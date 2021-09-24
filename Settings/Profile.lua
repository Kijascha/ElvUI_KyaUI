local KYA, E, L, V, P, G = unpack(select(2, ...))

-- Setup Profile Table
P.kyaui = {}
local KP = P.kyaui


KP.core = {
	installed = nil,
}
KP.general = {
	enabled = true,
}
KP.filterExtension = {
	enabled = true,
}

KP.microBar = {
	enabled = true,
	size = 32,
	scale = 1,
	hideInCombat = false,
	buttonSpacing = 1,
	borderSpacing = 1,
	direction = 'HORIZONTAL',
	template = 'Transparent',
	text = {
		position = 'TOP',
	},
}

KP.minimapButtons = {
	enabled = true,
	buttonSize = 32,
	scale = 1,
	snapTo = '',
	buttonSpacing = 1,
	borderSpacing = 1,
	direction = 'HORIZONTAL',
	template = 'Transparent',
	toggleBarsButton = {
		buttonSize = 32,
	},
	bars = {
		defaultSize = 32,
		defaultScale = 1,	
		defaultTemplate = 'Transparent',
		defaultPoint = { 
			Point = "CENTER",
			Anchor = E.UIParent,
			RelativePoint = "CENTER",
			XOffSet = 0,
			YOffSet = 0,
		},
		quickAccessBar = {
			enabled = false,
			direction = 'HORIZONTAL',		
			template = 'Transparent',
			buttonSize = 32,
			buttonSpacing = 1,
			borderSpacing = 1,
			slots = 5,
			buttons = {},
			defaultPoint = { 
				Point = "RIGHT",
				Anchor = E.UIParent,
				RelativePoint = "RIGHT",
				XOffSet = 0,
				YOffSet = 0,
			}
		},
		buttonGrid = {
			buttonSpacing = 1,
			borderSpacing = 1,
			borderWidth = 1,
			direction = 'HORIZONTAL',		
			template = 'Transparent',
			scale = 1,
			buttonSize = 32,
			gridLayout = {
				columns = 4,
				rows = 4,
			},
			buttons = {},
			defaultPoint = { 
				Point = "RIGHT",
				Anchor = E.UIParent,
				RelativePoint = "RIGHT",
				XOffSet = 0,
				YOffSet = 0,
			}
		}
	}
}
KP.databars = {}

for _, databar in pairs({ 'experience', 'reputation', 'honor', 'azerite'}) do
	KP.databars[databar] = {
		enable = true,
		texture = 'ElvUI Norm',
		textYoffset = 8,
	}
end


P.databars.colors.soulash = { r = .901, g = .8, b = .601, a = 1 }

for _, databar in pairs({ 'experience', 'reputation', 'honor', 'azerite','soulash'}) do
	P.databars[databar] = {
		enable = true,
		width = 222,
		height = 10,
		textFormat = 'NONE',
		fontSize = 11,
		font = 'PT Sans Narrow',
		fontOutline = 'NONE',
		mouseover = false,
		clickThrough = false,
		hideInCombat = false,
		orientation = 'AUTOMATIC',
		reverseFill = false,
		showBubbles = false,
	}
end

P.databars.soulash.width = 348
P.databars.soulash.fontSize = 12
P.kyaui = KP;