local KYA, E, L, V, P, G = unpack(select(2, ...));
local MB = KYA:GetModule('MinimapButtons')

local gsub = gsub
local wipe = wipe
local next = next
local pairs = pairs
local format = format
local strmatch = strmatch
local tonumber = tonumber
local tostring = tostring

local DirectionValues = {
    "HORIZONTAL",
    "VERTICAL",
}
local SnapToValues = {
    "NONE",
    "MINIMAP",
    "MICROBAR",
}

local function MinimapButtonsOptions()
    E.Options.args.kyaui.args.minimapButtons = {
    order = 6,
    type = "group",
    name = "Minimap Buttons",
    args = {
        minimapButtonsHeader = {
            order = 1,
            type = "header",
            name = KYA:cOption("Minimap Buttons"),
        },
        enabled = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            desc = "Toggle Minimap Buttons.",    
            get = function(info)
                if not MB.db then return end
                return MB.db[info[#info]]
            end,
            set = function(info, value)
                if not MB.db then return end
                MB.db[info[#info]] = value
                MB:Toggle()
            end,                    
        },
        generalSettings ={ 
            order = 3,
            name = "General Settings",
            disabled = function(info)
                if MB.db.enabled then
                    return false
                end
                return true
            end,
            type = "group",
            args = {               
                buttonSize = {
                    order = 1,
                    type = 'range',
                    name = 'Button Size',
                    min = 10, step = 1, max = 64,
                    disabled = function(info)
                        if MB.db.enabled then
                            return false
                        end
                        return true
                    end,
                    get = function(info)
                        if not MB.db then return end
                        return MB.db[info[#info]]
                    end,
                    set = function(info, value)
                        if not MB.db then return end
                        MB.db[info[#info]] = value
                        MB:UpdateMinimapButtons()
                    end,        
                },
                scale = {
                    order = 2,
                    type = 'range',
                    name = 'Scale Bar',
                    min = 0, step = .01, max = 1,
                    disabled = function(info)
                        if MB.db.enabled then
                            return false
                        end
                        return true
                    end,
                    get = function(info)
                        if not MB.db then return end
                        return MB.db[info[#info]]
                    end,
                    set = function(info, value)
                        if not MB.db then return end
                        MB.db[info[#info]] = value
                        MB:UpdateMinimapButtons()
                    end,         
                },
                buttonSpacing = {
                    order = 3,
                    type = 'range',
                    name = 'Button Spacing',
                    min = 0, step = 1, max = 10,
                    disabled = function(info)
                        if MB.db.enabled then
                            return false
                        end
                        return true
                    end,
                    get = function(info)
                        if not MB.db then return end
                        return MB.db[info[#info]]
                    end,
                    set = function(info, value)
                        if not MB.db then return end
                        MB.db[info[#info]] = value
                        MB:UpdateMinimapButtons()
                    end,         
                },
                borderSpacing = {
                    order = 4,
                    type = 'range',
                    name = 'Border Spacing',
                    min = 0, step = 1, max = 10,
                    disabled = function(info)
                        if MB.db.enabled then
                            return false
                        end
                        return true
                    end,
                    get = function(info)
                        if not MB.db then return end
                        return MB.db[info[#info]]
                    end,
                    set = function(info, value)
                        if not MB.db then return end
                        MB.db[info[#info]] = value
                        MB:UpdateMinimapButtons()
                    end,         
                },
                snapTo = {
                    order = 5,
                    type = 'select',
                    name = 'Snap To',
                    style = 'radio',
                    --display = 'inline',
                    values = SnapToValues,
                    disabled = function(info)
                        if MB.db.enabled then
                            return false
                        end
                        return true
                    end,
                    get = function(info)
                        if not MB.db then return end
                        return MB.db[info[#info]]
                    end,
                    set = function(info, value)
                        if not MB.db then return end
                        MB.db[info[#info]] = value
                        MB:UpdateMinimapButtons()
                    end,         
                },
                direction = {
                    order = 6,
                    type = 'select',
                    name = 'Direction',
                    style = 'dropdown',
                    values = DirectionValues,
                    disabled = function(info)
                        if MB.db.enabled then
                            return false
                        end
                        return true
                    end,
                    get = function(info)
                        if not MB.db then return end
                        return MB.db[info[#info]]
                    end,
                    set = function(info, value)
                        if not MB.db then return end
                        MB.db[info[#info]] = value
                        MB:UpdateMinimapButtons()
                    end,         
                },
            },
        }
    },
}
end

tinsert(KYA.Config, MinimapButtonsOptions)