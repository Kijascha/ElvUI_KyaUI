local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local LSM = KYA.Libs.LSM
local M = [[Interface\AddOns\ElvUI_KyaUI\Media\]]

function KYA:TextureString(texString, dataString)
	return '|T'..texString..(dataString or '')..'|t'
end

LSM:Register('statusbar','KyaOnePixel',M..[[Textures\BuiOnePixel.tga]])

LSM:Register('font','Gotham Heavy',M..[[Fonts\KMT-Gotham Heavy.ttf]])
LSM:Register('font','Gotham Medium',M..[[Fonts\KMT-Gotham Medium.ttf]])
LSM:Register('font','Gotham Narrow Medium',M..[[Fonts\KMT-Gotham Narrow Medium.ttf]])
LSM:Register('font','Gotham UC Heavy',M..[[Fonts\KMT-Gotham UC Heavy.ttf]])
LSM:Register('font','Gotham UC Medium',M..[[Fonts\KMT-Gotham UC Medium.ttf]])
LSM:Register('font','Gotham UC Narrow Medium',M..[[Fonts\KMT-Gotham UC Narrow Medium.ttf]])