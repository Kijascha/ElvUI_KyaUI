LibDBSlotMixin = {}

function LibDBSlotMixin:OnInitialized()
    print(self:GetName().. " fired from Init")
end
function LibDBSlotMixin:OnLoad()
    print(self:GetName().. " fired from OnLoad")

end
function LibDBSlotMixin:OnEvent(event, ...)
    print(event.. " fired from OnLoad")
end
function LibDBSlotMixin:OnEnter()
end
function LibDBSlotMixin:OnLeave()
end
function LibDBSlotMixin:OnReceiveDrag(obj)
    print(self:GetName())
    if obj then
        print(type(obj))
    end
end

function LibDBSlotMixin:CleanSlot()
    self.Button = nil;
end