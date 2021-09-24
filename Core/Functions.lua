local KYA, E, L, V, P, G = unpack(select(2, ...))

local LSM = E.Libs.LSM
-- Cache global variables
-- Lua functions
local _G = _G
local assert, ipairs, pairs, print, select, tonumber, type, unpack = assert, ipairs, pairs, print, select, tonumber, type, unpack
local getmetatable = getmetatable
local find, format, gsub, match, split, strfind = string.find, string.format, string.gsub, string.match, string.split, strfind
local strmatch, strsplit = strmatch, strsplit
local tconcat, tinsert, tremove, twipe = table.concat, table.insert, table.remove, table.wipe

-- WoW-API
local GetAddOnMetadata = GetAddOnMetadata
local GetBuildInfo = GetBuildInfo

-- Some Global Stuff
KYA.Title = format("|cffe3e3e3%s|||cffc74040%s|r %s", "KeYara","ART","UI")
KYA.Version = GetAddOnMetadata("ElvUI_KeYaraART_UI", "Version")
KYA.ElvUIV = tonumber(E.version)
KYA.ElvUIX = tonumber(GetAddOnMetadata("ElvUI_KeYaraART_UI", "X-ElvVersion"))
KYA.WoWPatch, KYA.WoWBuild, KYA.WoWPatchReleaseDate, KYA.TocVersion = GetBuildInfo()
KYA.WoWBuild = select(2, GetBuildInfo()) KYA.WoWBuild = tonumber(KYA.WoWBuild)

function KYA:CheckVersion(self)
	if not KYAData["Version"] or (KYAData["Version"] and KYAData["Version"] ~= MER.Version) then
		KYAData["Version"] = KYA.Version
	end
end

function KYA:SetupProfileCallbacks()
	E.data.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	E.data.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	E.data.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
end
function KYA:UpdateRegisteredDBs()
	if (not KYA["RegisteredDBs"]) then
		return
	end

	local dbs = KYA["RegisteredDBs"]

	for tbl, path in pairs(dbs) do
		self:UpdateRegisteredDB(tbl, path)
	end
end

function KYA:OnProfileChanged()
	KYA:Hook(E, "UpdateEnd", "UpdateAll")
end
-- Class Color stuff
KYA.ClassColors = {}
local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
for class, value in pairs(colors) do
	KYA.ClassColors[class] = {}
	KYA.ClassColors[class].r = value.r
	KYA.ClassColors[class].g = value.g
	KYA.ClassColors[class].b = value.b
	KYA.ClassColors[class].colorStr = value.colorStr
end
KYA.r, KYA.g, KYA.b = KYA.ClassColors[E.myclass].r, KYA.ClassColors[E.myclass].g, KYA.ClassColors[E.myclass].b

function KYA:CreateText(f, layer, size, outline, text, classcolor, anchor, x, y)
	local text = f:CreateFontString(nil, layer)
	text:FontTemplate(nil, size or 10, outline or "OUTLINE")
	text:SetWordWrap(false)

	if text then
		text:SetText(text)
	else
		text:SetText("")
	end

	if classcolor and type(classcolor) == "boolean" then
		text:SetTextColor(KYA.r, KYA.g, KYA.b)
	elseif classcolor == "system" then
		text:SetTextColor(1, .8, 0)
	elseif classcolor == "white" then
		text:SetTextColor(1, 1, 1)
	end

	if (anchor and x and y) then
		text:SetPoint(anchor, x, y)
	else
		text:SetPoint("CENTER", 1, 0)
	end

	return text
end

function KYA:UpdateAll()
	self:UpdateRegisteredDBs()
	for _, module in ipairs(self:GetRegisteredModules()) do
		local mod = KYA:GetModule(module)
		if (mod and mod.ForUpdateAll) then
			mod:ForUpdateAll()
		end
	end
	KYA:Unhook(E, "UpdateEnd")
end

function KYA:UpdateRegisteredDB(tbl, path)
	local path_parts = {strsplit(".", path)}
	local _db = E.db.kyaui
	for _, path_part in ipairs(path_parts) do
		_db = _db[path_part]
	end
	tbl.db = _db
end

function KYA:RegisterDB(tbl, path)
	if (not KYA["RegisteredDBs"]) then
		KYA["RegisteredDBs"] = {}
	end
	self:UpdateRegisteredDB(tbl, path)
	KYA["RegisteredDBs"][tbl] = path
end
function KYA:DebugPrintObject(Object)
	for key,value in pairs(Object) do
		print("found member " .. key);
	end
end

function KYA:UpdateTextures()
	self:DebugPrintObject(self)
	--Textures
	--self.databars.blankTex = LSM:Fetch('background', 'ElvUI Blank')
	E.private.kyaui.databars.databarsTexture = LSM:Fetch('statusbar', E.private.databars.databarsTexture)
end
