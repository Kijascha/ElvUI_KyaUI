
local CURRENT_MINIMAPBUTTON_BAR_STATE

function LibDBBarController_GetCurrentMinimapButtonBarState()
	return CURRENT_MINIMAPBUTTON_BAR_STATE;
end

function LibDBBarController_OnLoad(self)

	--ManyBars
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("ADDON_LOADED");
end


function LibDBBarController_OnEvent(self, event, ...)
	local arg1, arg2 = ...;
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		LibDBBarController_UpdateAll();
	end
end


function LibDBBarController_UpdateAll(force)
    --[[
        TODO: Implement Update Stuff for both Bars
    ]]
end
