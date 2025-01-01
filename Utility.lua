local CloseWindows = _G.CloseWindows

--- WoW API Functions ---

function ReagentFiller:GetItemInfo(itemID)
    return GetItemInfo(itemID)       -- Deprecated but works in classic currently, expect to change.
end

function ReagentFiller:GetItemCount(itemID)
    return GetItemCount(itemID)      -- Deprecated but works in classic currently, expect to change.
end

--- END API Functions ---

function ReagentFiller:GetItemID(itemLink)
    if itemLink then
        local itemID = tonumber(itemLink:match("item:(%d+)"))
        if itemID then
            return itemID
        end
    end
    if tonumber(itemLink) then
        return tonumber(itemLink)
    end
    return nil
end

function ReagentFiller:GetItemNameWithLevel(itemID)
    local itemName = self:GetItemInfo(itemID) or "?"
    local _, _, _, _, lvl = self:GetItemInfo(itemID)
    local nameWithLevel = itemName .. (lvl and lvl ~= 0 and " (Level " .. lvl .. ")" or "")

    return nameWithLevel
end

function ReagentFiller:CheckIfClassCategory(className)
    if className == nil then return end
    if(className == "--Custom--") or (className == "-Miscellaneous-") then
        return false
    else
        return true
    end
end
function ReagentFiller:InAMajorCity()
    local majorCities = {
        -- Localization needed
        ["Stormwind City"] = true,
        ["Ironforge"] = true,
        ["Darnassus"] = true,
        ["Exodar"] = true,
        ["Orgrimmar"] = true,
        ["Thunder Bluff"] = true,
        ["Undercity"] = true,
        ["Silvermoon City"] = true,
        ["Shattrath City"] = true,
        ["Dalaran"] = true,
    }
    return majorCities[GetRealZoneText()]
end

function ReagentFiller:SetArrowCount()
    if(WOW_PROJECT_WRATH_CLASSIC == WOW_PROJECT_ID) then
        return 1000;
    else
        return 200;
    end
end

function ReagentFiller:GetQuiverCapacityAndOccupiedSlotsFromBag()
    local quiverCapacity = 0
    local quiverFreeSlots = 0
    local quiverArrowCount = 0
    local tempQuiverArrowCount = 0
    local tempItemIDArray = {}

    for bag = 0, NUM_BAG_SLOTS do
        local bagName = C_Container.GetBagName(bag)
        if bagName then
            local _, _, _, _, _, itemType = self:GetItemInfo(bagName)
            if itemType == "Quiver" then
                local numSlots = C_Container.GetContainerNumSlots(bag)
                quiverCapacity = quiverCapacity + numSlots

                for slot = 1, numSlots do
                    local tempItemID = C_Container.GetContainerItemID(bag, slot) or 0
                    tempQuiverArrowCount = self:GetItemCount(tempItemID)

                    local container = C_Container.GetContainerItemInfo(bag, slot)
                    if container == nil then
                        quiverFreeSlots = quiverFreeSlots + 1
                    end
                    if((tempQuiverArrowCount > 0) and not tempItemIDArray[tempItemID]) then
                        tempItemIDArray[tempItemID] = true
                        quiverArrowCount = quiverArrowCount + tempQuiverArrowCount
                    end
                end
            end
        end
    end

    return quiverCapacity, quiverFreeSlots, quiverArrowCount
end

function ReagentFiller:GetSubsections()
    local itemTypes = {}
    for classType, itemType in pairs(self.db.char.reagents) do
        for itemcategory, itemID in pairs(itemType) do
            if type(itemID) == "table" then
                table.insert(itemTypes, itemID)
            end
        end
    end
    return itemTypes
end

function ReagentFiller:GetItemData(itemTypes)
    local items = {}
    for itemID, itemData in pairs(itemTypes) do
        if type(itemData) == "table" and itemData.enabled then
            table.insert(items, {itemID = itemID, itemData = itemData})
        end
    end
    return items
end

function ReagentFiller:CheckIfLowOnEnabledReagents()
    local itemID, itemData, quantityToBuy, itemCount
    local itemTypes = self:GetSubsections()
    for _, t_itemID in ipairs(itemTypes) do
        local items = self:GetItemData(t_itemID)
        for _, itemInfo in ipairs(items) do
            itemID = itemInfo.itemID
            itemData = itemInfo.itemData
            quantityToBuy = itemData.quantityToBuy or 0
            itemCount = self:GetItemCount(itemID)
            local threshold = quantityToBuy * 0.50  -- 50% threshold

            if itemCount <= threshold then
                self:Print("Less than 50% of enabled reagents.")
                return true
            end
        end
    end
    return false
end


function ReagentFiller:RefreshOptions()
    CloseWindows()
    self:CreateOptionsTable()
end

function ReagentFiller:BuyItemFromMerchant(itemID, quantity)
    local itemName = self:GetItemInfo(itemID)
    for i = 1, GetMerchantNumItems() do
        local name = GetMerchantItemInfo(i)
        if name and name == itemName then
            BuyMerchantItem(i, quantity)
            -- self:Print("Bought " .. quantity .. " " .. itemName) -- DEBUG
            break
        end
    end
end

function ReagentFiller:BuyReagentsFromMerchant(reagents)
    for className, itemTypes in pairs(reagents) do
        if type(itemTypes) == "table" then
            for itemID, itemData in pairs(itemTypes) do
                if type(itemData) == "table" and itemData.enabled then
                    local quantityToBuy = itemData.quantityToBuy or 0
                    local maxStack = select(8, GetItemInfo(itemID)) or 1 
                    local quantityToBuyAdjusted = math.max(0, quantityToBuy - self:GetItemCount(itemID))
   
                    while quantityToBuyAdjusted > 0 do
                        local batchQuantity = math.min(quantityToBuyAdjusted, maxStack)
                        self:BuyItemFromMerchant(itemID, batchQuantity)
                        quantityToBuyAdjusted = quantityToBuyAdjusted - batchQuantity
                    end
                end
            end
        end
    end
end
