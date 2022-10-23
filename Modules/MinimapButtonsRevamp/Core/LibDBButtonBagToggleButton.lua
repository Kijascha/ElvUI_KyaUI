LibDBButtonBagToggleButtonMixin = {}

function LibDBButtonBagToggleButtonMixin:Init()
    print(self:GetName().. " fired from Init")
end
function LibDBButtonBagToggleButtonMixin:OnLoad()
    print(self:GetName().. " fired from OnLoad")

end
function LibDBButtonBagToggleButtonMixin:OnEvent(event, ...)
    print(event.. " fired from OnLoad")
end

function LibDBButtonBagToggleButtonMixin:OnEnter()
end
function LibDBButtonBagToggleButtonMixin:OnLeave()
end
function LibDBButtonBagToggleButtonMixin:OnDragStart()
    print(self:GetName().." - OnDragStart")
end

function LibDBButtonBagToggleButtonMixin:OnDragStop()
    print(self:GetName().." - OnDragStop")
end