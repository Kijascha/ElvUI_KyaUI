local KYA, E, L, V, P, G = unpack(select(2, ...));
if not KYA.AS then return end
local AS = unpack(AddOnSkins);

local foreach = table.foreach

local function EmbedDetails(window, width, height, point, relativeFrame, relativePoint, ofsx, ofsy)
	if not window then return end
	--print('Hooked function EmbedDetailsWindow: '..window.baseName)
		
	foreach(window.DetailsInstances, function(k,v)
		if window.DetailsInstances[k] ~= nil then
			local point, relativeTo, relativePoint, xOfs, yOfs = window.DetailsInstances[k].baseframe:GetPoint()
			local name = window.DetailsInstances[k].baseframe:GetName()

			window.DetailsInstances[k].baseframe:Point('BOTTOMLEFT', _G.RightChatDataPanel, 'TOPLEFT', 1, 34)
			
			window.DetailsInstances[k].menu_anchor_down[1] = 15
			window.DetailsInstances[k].menu_anchor_down[2] = -3

			_G.RightChatDataPanel:HookScript('OnSizeChanged',function(self) 			
				window.DetailsInstances[k].baseframe:ClearAllPoints()
				window.DetailsInstances[k].baseframe:Point('BOTTOMLEFT', _G.RightChatDataPanel, 'TOPLEFT', 1, 34)
			end)			
		end
	end)
end

function KYA:LoadAddOnSkinsProfile()
	AS.data:SetProfile("KyaUI")

	local font = "PT Sans Narrow"

	AS.db['WeakAuraAuraBar'] = true

	if KYA:IsAddOnEnabled('Recount') then
		AS.db['EmbedSystem'] = true
		AS.db['EmbedSystemDual'] = false
		AS.db['EmbedBackdrop'] = false
		AS.db['TransparentEmbed'] = true
	end

	if KYA:IsAddOnEnabled('Skada') then
		AS.db['EmbedSystem'] = false
		AS.db['EmbedSystemDual'] = true
		AS.db['EmbedBackdrop'] = false
		AS.db['TransparentEmbed'] = true
	end

	if KYA:IsAddOnEnabled('Details') then
		AS.db['EmbedBackdrop'] = false
		AS.db['EmbedSystem'] = false
		AS.db['EmbedSystemDual'] = true
		AS.db['TransparentEmbed'] = true

		if AS:CheckOption('EmbedSystemDual') then
			if AS:CheckOption('EmbedLeft') == 'Details' then
				hooksecurefunc(AS, 'EmbedDetailsWindow',EmbedDetails)
			end
		end
	end

	if KYA:IsAddOnEnabled('DBM-Core') then
		AS.db['DBMSkinHalf'] = true
		AS.db['DBMFont'] = font
		AS.db['DBMFontSize'] = 12
		AS.db['DBMRadarTrans'] = true
	end
end