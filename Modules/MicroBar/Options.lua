local KYA, E, L, V, P, G = unpack(select(2, ...));
local MB = KYA:GetModule('MicroBar')

local gsub = gsub
local wipe = wipe
local next = next
local pairs = pairs
local format = format
local strmatch = strmatch
local tonumber = tonumber
local tostring = tostring

local function MicroBarOptions()
    E.Options.args.kyaui.args.microBar = {
    order = 5,
    type = "group",
    name = "MicroBar",
    args = {
        microBarHeader = {
            order = 1,
            type = "header",
            name = KYA:cOption("MicroBar"),
        },
        enabled = {
            order = 2,
            type = "toggle",
            name = L["Enable"],
            desc = "Enable enhanced micro menu.",    
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
        hideInCombat = {
            order = 3,
            type = "toggle",
            name = L["HideInCombat"],
            disabled  = function() 
                if not MB.db then return end
                if not MB.db.enabled then return true end
                return false
            end,
            desc = "Enable enhanced micro menu.",    
            get = function(info)
                if not MB.db then return end
                return MB.db[info[#info]]
            end,
            set = function(info, value)
                if not MB.db then return end
                MB.db[info[#info]] = value
                MB:UpdateMicroBar()
            end,                    
        },
        sizegroup = {
            order = 4,
            type = "group",
            name = L["Size"],
            args = {
                size = {
                    order = 1,
                    type = "range",
                    name = L["Size"],
                    disabled  = function() 
                        if not MB.db then return end
                        if not MB.db.enabled then return true end
                        return false
                    end,
                    min = 10,
                    max = 50,
                    step = 1,
                    desc = L["Sets the Size of the buttons."],    
                    get = function(info)
                        if not MB.db then return end
                        return MB.db[info[#info]]
                    end,
                    set = function(info, value)
                        if not MB.db then return end
                        MB.db[info[#info]] = value
                        MB:UpdateMicroBar()
                    end,                    
                },
                scale = {
                    order = 2,
                    type = "range",
                    name = L["Scale"],
                    disabled  = function() 
                        if not MB.db then return end
                        if not MB.db.enabled then return true end
                        return false
                    end,
                    min = 0.5,
                    max = 1.5,
                    step = 0.01,
                    desc = "Scales the whole Bar from 0 to 1.5",    
                    get = function(info)
                        if not MB.db then return end
                        return MB.db[info[#info]]
                    end,
                    set = function(info, value)
                        if not MB.db then return end
                        MB.db[info[#info]] = value
                        MB:UpdateMicroBar()
                    end,                    
                },
            },
        },
    },
}
end

tinsert(KYA.Config, MicroBarOptions)