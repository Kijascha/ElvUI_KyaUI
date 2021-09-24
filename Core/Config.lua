local KYA, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local format, select, unpack = format, select, unpack
local tinsert = table.insert
-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS: StaticPopup_Show

if E.db.kyaui == nil then E.db.kyaui = {} end

local function AddOptions()
	print(KYA.Title)
	E.Options.name = E.Options.name.." + "..KYA.Title..format(": |cFF00c0fa%.1f|r", KYA.Version) -- TO DO: Change Colors of my Name

	local ACD = LibStub("AceConfigDialog-3.0-ElvUI")

	local function CreateButton(number, text, ...)
		local path = {}
		local num = select("#", ...)
		for i = 1, num do
			local name = select(i, ...)
			tinsert(path, #(path)+1, name)
		end
		local config = {
			order = number,
			type = 'execute',
			name = text,
			customWidth = 140,
			func = function() ACD:SelectGroup("ElvUI", "kyaui", unpack(path)) end,
		}
		return config
	end

	-- Main options
	E.Options.args.kyaui = {
		order = 100,
		type = "group",
		name = KYA.Title,
		desc = L["Plugin for |cffff7d0aElvUI|r by\nKeYara."],
		childGroups = "tab",
		get = function(info) return E.db.kyaui.general[ info[#info] ] end,
		set = function(info, value) E.db.kyaui.general[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = KYA.Title..KYA:cOption(KYA.Version)..L[" by KeYara (|cFF00c0faEU-Ulduar|r)"],
			},
			install = {
				order = 2,
				type = "execute",
				name = L["Install"],
				desc = L["Run the installation process."],
				customWidth = 140,
				func = function() E:GetModule("PluginInstaller"):Queue(KYA.installTable); E:ToggleOptionsUI(); end,
			},
			general = {
				order = 3,
				type = "group",
				name = L["General"],
				args = {
					generalHeader = {
						order = 1,
						type = "header",
						name = KYA:cOption(L["General"]),
					},
					LoginMsg = {
						order = 2,
						type = "toggle",
						name = L["Login Message"],
						desc = L["Enable/Disable the Login Message in Chat"],
					},
				},
			},
		},
	}
end
tinsert(KYA.Config, AddOptions)
