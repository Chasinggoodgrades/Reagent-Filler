ReagentFiller = LibStub("AceAddon-3.0"):NewAddon("ReagentFiller", "AceEvent-3.0", "AceConsole-3.0")
addonVersion = GetAddOnMetadata("ReagentFiller", "Version")
local AceCfig = LibStub("AceConfig-3.0")
local AceDial = LibStub("AceConfigDialog-3.0")
local CloseWindows = _G.CloseWindows
local windowOpen = false
local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("ReagentFiller", {
    type = "data source",
    text = "ReagentFiller",
    icon = "Interface\\Icons\\INV_Misc_Bag_08",
    OnClick = function(self, button)
        if button == "LeftButton" then
            if windowOpen then
                CloseWindows()
                windowOpen = false
            else
                windowOpen = true

                ReagentFiller:RefreshOptions()
                InterfaceOptionsFrame_OpenToCategory(ReagentFiller.optionsFrame)
                InterfaceOptionsFrame_OpenToCategory(ReagentFiller.optionsFrame)
            end
        end
    end,
})
local icon = LibStub("LibDBIcon-1.0")

function ReagentFiller:OnInitialize()

    -- On Player Login
    self:RegisterEvent("PLAYER_LOGIN", "OnPlayerLogin")

    -- DB -> Default_Settings
	self.db = LibStub("AceDB-3.0"):New("ReagentFillerDB", self.DEFAULT_SETTINGS, true)

    -- Options Table
	AceCfig:RegisterOptionsTable("ReagentFiller_Options", self.options)
	self.optionsFrame = AceDial:AddToBlizOptions("ReagentFiller_Options", "ReagentFiller")

    -- Minimap icon
    icon:Register("ReagentFiller", LDB, self.db.char.minimapIcon)
    LDB.OnTooltipShow = function(tooltip)
        tooltip:AddLine("|cFFFFD700ReagentFiller|r          |cFFFFFFFFv" .. addonVersion .. "|r")
        tooltip:AddLine(" ")
        tooltip:AddLine("Click to open options")
    end
    -- Slash Commands
	self:RegisterChatCommand("rf", "SlashCommand")
	self:RegisterChatCommand("reagentfiller", "SlashCommand")

end

function ReagentFiller:OnEnable()
    self:RegisterEvent("MERCHANT_SHOW", "OnMerchantShow")
    self:RegisterEvent("ADDON_LOADED", "OnAddonLoaded")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnZoneChangedNewArea")
end

function ReagentFiller:OnZoneChangedNewArea()
    if self.db.char.lowReagentAlerts then
        if self:InAMajorCity() then
            if self:CheckIfLowOnEnabledReagents() then
                self:CreateLowReagentPopup()
            end
        end
    end
end

function ReagentFiller:OnPlayerLogin()
    self:UnregisterEvent("PLAYER_LOGIN")
    self:Enable()

    C_Timer.After(4, function()
        self:CreateOptionsTable()
    end)
end


function ReagentFiller:OnAddonLoaded()
    self:Print("Addon loaded.")
    self:UnregisterEvent("ADDON_LOADED")
    self:CreateOptionsTable()
end

function ReagentFiller:SlashCommand(input, editbox)
	if input == "enable" then
		self:Enable()
	elseif input == "disable" then
		self:Disable()
	else
        self:RefreshOptions()
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	end
end

function ReagentFiller:OnMerchantShow()
    for sectionName, sectionSettings in pairs(self.db.char.reagents) do
        -- Exclude the "Hunter" section from the initial loop
        if sectionName ~= "Hunter" and type(sectionSettings) == "table" then
            self:BuyReagentsFromMerchant(sectionSettings)
        end
    end

    -- Additional logic for Hunter to handle quiver filling
    local hunterSettings = self.db.char.reagents["Hunter"]
    if hunterSettings then
        local quiverCapacity, quiverFreeSlots, quiverArrowCount = self:GetQuiverCapacityAndOccupiedSlotsFromBag()
        local arrowCount = self:SetArrowCount()
        local buyCount = (quiverCapacity * arrowCount) - quiverArrowCount

        for _, itemData in pairs(hunterSettings) do
            if itemData.fillQuiver then
                local ammoID = itemData.fillQuiverID
                local loopTimes = buyCount / arrowCount

                if loopTimes < 1 then
                    self:BuyItemFromMerchant(ammoID, buyCount)
                else
                    if buyCount > 0 then
                        for i = 1, loopTimes do
                            if(buyCount > arrowCount) then
                                buyCount = buyCount - arrowCount
                                self:BuyItemFromMerchant(ammoID, arrowCount)
                            else
                                self:BuyItemFromMerchant(ammoID, buyCount)
                            end
                        end
                    end
                end
            end
        end
    end
end


