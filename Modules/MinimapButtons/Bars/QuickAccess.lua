local KYA, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local MB = KYA:GetModule('MinimapButtons');

if not MB.Bars then return end

MB.Bars.QuickAccessBar = nil

function MB.Bars:CreateQuickAccessBar()
    if not MB.db then return end
    if not MB.db.bars.quickAccessBar then return end

    local barName = "QuickAccessBar";
    local parent = E.UIParent;
    local point = MB.db.bars.quickAccessBar.defaultPoint;
    
    MB.Bars.QuickAccessBar = MB.Bars:CreateBar(barName, parent)
    local bar = MB.Bars.QuickAccessBar
    if bar then
        bar:SetPoint(
            point.Point or "RIGHT",
            point.Anchor or parent,
            point.RelativePoint or "RIGHT",
            point.XOffSet or 0,
            point.YOffSet or 0);	
            
        E:CreateMover(bar, "KyaUI_"..barName.."Mover", "KyaUI_"..barName, nil, nil, nil, "ALL,MINIMAP,KYAUI", nil, "kyaui,quickAccessBar")
        return true;
    end
    return false;
end