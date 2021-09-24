local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DB = KYA:GetModule('DataBars')
local DBO = E:GetModule('DataBars')
local LSM = E.Libs.LSM

local _G = _G
local unpack, select = unpack, select
local pairs, ipairs = pairs, ipairs

function DB:Initialize()
	DB.Initialized = true;
	DB.db = E.db.databars;

	if DBO.Initialized then
		DBO:SoulAshBar()
	
		DBO:UpdateAll()
	end
end

KYA:RegisterModule(DB:GetName())
