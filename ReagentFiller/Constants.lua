--[[
    
ReagentFiller
Copyright 2024 Aches (xarilawow@gmail.com)
All right reserved.

Creation of a Reagent Filler ReagentFiller that will fill the reagents for the player.

]]
local icon = LibStub("LibDBIcon-1.0")
ReagentFiller.DEFAULT_SETTINGS = {
    char = {
        lowReagentAlerts = true,
        minimapIcon = {
            hide = false,
        },
        reagents = {
            ["-Miscellaneous-"] = {
                ["World Buffs"] = {
                    [212160] = { -- Item ID for Chronoboon Displacer
                        enabled = false,
                        quantityToBuy = 5,
                    },
                },
                ["Misc Vendors"] = {
                    [8529] = { -- Item ID for Noggenfogger Elixir
                        enabled = false,
                        quantityToBuy = 5,
                    },
                },
                ["Tailoring Threads"] = {
                    [2321] = { -- Item ID for Fine Thread
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [2320] = { -- Item ID for Coarse Thread
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [4291] = { -- Item ID for Silken Thread
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [8343] = { -- Item ID for Heavy Silken Thread
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [14341] = { -- Item ID for Rune Thread
                        enabled = false,
                        quantityToBuy = 20,
                    },
                },
                ["Alchemy Vials"] = {
                    [8925] = { -- Item ID for Crystal Vial
                        enabled = false,
                        quantityToBuy = 5,
                    },
                    [3371] = { -- Item ID for Empty Vial
                        enabled = false,
                        quantityToBuy = 5,
                    },
                    [3372] = { -- Item ID for Laded Vial
                        enabled = false,
                        quantityToBuy = 5,
                    },
                    [18256] = { -- Item ID for Imbued Vial
                        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
                        enabled = false,
                        quantityToBuy = 5,
                    },
                },
            },
            ["Mage"] = {
                ["Runes & Powder"] = {
                    [17031] = { -- Item ID for Rune of Teleportation
                        enabled = false,
                        quantityToBuy = 5,
                    },
                    [17032] = { -- Item ID for Rune of Portals
                        enabled = false,
                        quantityToBuy = 5,
                    },
                    [17020] = { -- Item ID for Arcane Powder
                        enabled = false,
                        quantityToBuy = 20,
                    },
                },
                ["SoD Exclusive Items"] = {
                    [211779] = { -- Item ID for Comprehension Charm
                        enabled = false,
                        quantityToBuy = 5,
                    },
                },
            },
            ["Priest"] = {
                ["Candles"] = {
                    [17029] = { -- Item ID for Sacred Candle
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [17028] = { -- Item ID for Holy Candle
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [44615] = { -- Item ID for Devout Candle
                        version = WOW_PROJECT_WRATH_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                },
            },
            ["Druid"] = {
                ["Rebirth"] = {
                    [17034] = { -- Item ID for Maple Seed
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [17035] = { -- Item ID for Stranglethorn Seed
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [17036] = { -- Item ID for Ashwood Seed
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [17037] = { -- Item ID for Hornbeam Seed
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [17038] = { -- Item ID for Ironwood Seed
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [22147] = { -- Item ID for Flintweed Seed
                        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [44614] = { -- Item ID for Starleaf Seed
                        version = WOW_PROJECT_WRATH_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                },

                ["Gift of the Wild"] = {
                    [17021] = { -- Item ID for Wild Berries
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [17026] = { -- Item ID for Wild Thornroot
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [22148] = { -- Item ID for Wild Quillvine
                        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [44615] = { -- Item ID for Wild Spineleaf
                        version = WOW_PROJECT_WRATH_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                },
                ["SoD Exclusive Items"] = {
                    [213407] = { -- Item ID for Catnip
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [211779] = { -- Item ID for Comprehension Charm
                        enabled = false,
                        quantityToBuy = 5,
                    }
                },
            },
            
            ["Paladin"] = {
                ["Symbols"] = {
                    [17033] = { -- Item ID for Symbol of Divinity
                        enabled = false,
                        quantityToBuy = 5,
                    },
                    [21177] = { -- Item ID for Symbol of Kings
                        batchSize = 20,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                },
            },
            ["Shaman"] = {
                ["Reagents"] = {
                    [17030] = { -- Item ID for Ankh
                        enabled = false,
                        quantityToBuy = 5,
                    },
                },
            },
            ["Warlock"] = {
                ["Reagents"] = {
                    [5565] = { -- Item ID for Infernal Stone
                        enabled = false,
                        quantityToBuy = 5,
                    },
                    [16583] = { -- Item ID for Demonic Figurine
                        enabled = false,
                        quantityToBuy = 5,
                    },
                },
            },
            ["Rogue"] = {
                ["Poisons"] = {
                    [2928] = { -- Item ID for Dust of Decay
                        version = WOW_PROJECT_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
					[5140] = { -- Item ID for Flash Powder
						version = WOW_PROJECT_CLASSIC,
						enabled = false,
						quantityToBuy = 20,
					},
                    [8924] = { -- Item ID for Dust of Deterioration
                        version = WOW_PROJECT_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [8923] = { -- Item ID for Essence of Agony
                        version = WOW_PROJECT_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [2930] = { -- Item ID for Essence of Pain
                        version = WOW_PROJECT_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [5173] = { -- Item ID for Deathweed
                        version = WOW_PROJECT_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [43231] = { -- Item ID for Instant Poison IX (79)
                        version = WOW_PROJECT_WRATH_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [3775] = { -- Item ID for Crippling Poison
                        version = WOW_PROJECT_WRATH_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [43233] = { -- Item ID for Deadly Poison IX (80)
                        version = WOW_PROJECT_WRATH_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [43235] = { -- Item ID for Wound Poison VII (78)
                        version = WOW_PROJECT_WRATH_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [43237] = { -- Item ID for Anesthetic Poison II
                        version = WOW_PROJECT_WRATH_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                },
                ["Vials"] = {
                    [8925] = { -- Item ID for Crystal Vial
                        batchSize = 5,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [3371] = { -- Item ID for Empty Vial
                        batchSize = 5,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [3372] = { -- Item ID for Leaded Vial
                        batchSize = 5,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [18256] = { -- Item ID for Imbued Vial
                        version = WOW_PROJECT_THE_BURNING_CRUSADE_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                    [40411] = { -- Item ID for Enchanted Vial
                        version = WOW_PROJECT_WRATH_CLASSIC,
                        enabled = false,
                        quantityToBuy = 20,
                    },
                },
            },
            ["Hunter"] = {
                ["Arrows"] = {
                    fillQuiver = false,
                    fillQuiverID = 0,
                    [2512] = { -- Item ID for Rough Arrow
                        batchSize = 200,
                        enabled = false,
                    },
                    [2515] = { -- Item ID for Sharp Arrow
                        batchSize = 200,
                        enabled = false,
                    },
                    [3030] = { -- Item ID for Razor Arrow
                        batchSize = 200,
                        enabled = false,
                    },
                    [11285] = { -- Item ID for Jagged Arrow
                        batchSize = 200,
                        enabled = false,
                    },
                    [19316] = { -- Item ID for Ice Threaded Arrow
                        batchSize = 200,
                        enabled = false,
                    },
                    [231806] = { -- Item ID for Searing Arrows (SOD)
                        batchSize = 200,
                        enabled = false,
                    },

                    ------ TBC BEGIN
                    [28053] = { -- Item ID for Wicked Arrow
                        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
                        batchSize = 200,
                        enabled = false,
                    },
                    [24417] = { -- Item ID for Scout's Arrow
                        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
                        batchSize = 200,
                        enabled = false,
                    },
                    [30611] = { -- Item ID for Halaani Razorshaft Arrow
                        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
                        batchSize = 200,
                        enabled = false,
                    },

                    [28056] = { -- Item ID for Blackflight Arrow
                        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
                        batchSize = 200,
                        enabled = false,
                    },
                    [31949] = { -- Item ID for Warden's Arrow
                        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
                        batchSize = 200,
                        enabled = false,
                    },
                    [34581] = { -- Item ID Mysterious Arrow
                        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
                        batchSize = 200,
                        enabled = false,
                    },
                    [31737] = { -- Item ID for Timeless Arrow
                        version = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
                        batchSize = 200,
                        enabled = false,
                    },
                    ------ WOTLK BEGIN
                    [41586] = { -- Item ID for Terrorshaft Arrow
                        version = WOW_PROJECT_WRATH_CLASSIC,
                        batchSize = 200,
                        enabled = false,
                    },
                },
                ["Bullets"] = {
                    fillQuiver = false,
                    fillQuiverID = 0,
                    [2516] = { -- Item ID for Light Shot
                        batchSize = 200,
                        enabled = false,
                    },
                    [2519] = { -- Item ID for Heavy Shot
                        batchSize = 200,
                        enabled = false,
                    },
                    [3033] = { -- Item ID for Solid Shot
                        batchSize = 200,
                        enabled = false,
                    },
                    [11284] = { -- Item ID for Accurate Slugs
                        batchSize = 200,
                        enabled = false,
                    },
                    [19317] = { -- Item ID for Ice Threaded Bullet
                        batchSize = 200,
                        enabled = false,
                    },
                    [28060] = { -- Item ID for Impact Shot
                        version = WOW_PROJECT_WRATH_CLASSIC,
                        batchSize = 200,
                        enabled = false,
                    },
                    [28061] = { -- Item ID for Ironbite Shell
                        version = WOW_PROJECT_WRATH_CLASSIC,
                        batchSize = 200,
                        enabled = false,
                    },
                    [31735] = { -- Item ID for Timeless Shell
                        version = WOW_PROJECT_WRATH_CLASSIC,
                        batchSize = 200,
                        enabled = false,
                    },
                    [41584] = { -- Item ID for Frostbite Bullets
                        version = WOW_PROJECT_WRATH_CLASSIC,
                        batchSize = 200,
                        enabled = false,
                    },
                },
            },
            ["--Custom--"] = {

            },
        }
    }
}
ReagentFiller.options = {
    type = "group",
    name = "|cFFFFD700ReagentFiller|r |cFFFFFFFFv" .. (addonVersion or "Unknown") .. "|r",
    handler = ReagentFiller,
    args = {
        general = {
            type = "group",
            name = "General Settings (|cFFFFFFFFCharacter Specific|r)",
            inline = true,
            order = 1,
            args = {
                lowReagentAlerts = {
                    type = "toggle",
                    name = "Low Reagent Alerts",
                    desc = "Receive a warning when your enabled/auto-buying reagents fall below 50% while in a major city.",
                    get = function(info) return ReagentFiller.db.char.lowReagentAlerts end,
                    set = function(info, value) ReagentFiller.db.char.lowReagentAlerts = value end,
                    order = 1,
                },
                hideMiniMapIcon = {
                    type = "toggle",
                    name = "Hide Minimap Icon",
                    desc = "Hides the minimap icon for ReagentFiller.",
                    get = function(info) return ReagentFiller.db.char.minimapIcon.hide end,
                    set = function(info, value)
                        ReagentFiller.db.char.minimapIcon.hide = value
                        if value then
                            icon:Hide("ReagentFiller")
                        else
                            icon:Show("ReagentFiller")
                        end
                    end,
                    order = 2,
                },
            },
        },
    },
}


