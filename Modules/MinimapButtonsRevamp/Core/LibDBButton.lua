LibDBButtonMixin = {}

function LibDBButtonMixin:OnLoad()
    self:SetSize(36,36);
    self:RegisterForClicks("LeftButtonUp","RightButtonUp");
    self:EnableMouse(true);
    self:RegisterForDrag("LeftButton");
end

function LibDBButtonMixin:OnMouseDown()
    self:StartMoving()
end
function LibDBButtonMixin:OnMouseUp()
    self:StopMovingOrSizing();
end