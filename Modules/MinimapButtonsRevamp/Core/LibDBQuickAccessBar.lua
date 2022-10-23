LibDBQuickAcccessBarSlotEventsFrameMixin = {};

function LibDBQuickAcccessBarSlotEventsFrameMixin:OnLoad()
	self.frames = {};
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
    self:RegisterEvent("ADDON_LOADED");
end

function LibDBQuickAcccessBarSlotEventsFrameMixin:OnEvent(event, ...)
	-- pass event down to the buttons
	for k, frame in pairs(self.frames) do
		frame:OnEvent(event, ...);
	end
end

function LibDBQuickAcccessBarSlotEventsFrameMixin:RegisterFrame(frame)
	tinsert(self.frames, frame);
end