local AceGUI = LibStub("AceGUI-3.0")

function ReagentFiller:CreateOptionsTable()
    for className, itemTypes in pairs(self.db.char.reagents) do
        local categoryArgs = {
            type = "group",
            name = className,
            order = 1,
            inline = false,
            args = {},
        }

        if className == "--Custom--" then
            self:AddCustomItems(categoryArgs, className, itemTypes)
            self:AddCustomSubcategories(categoryArgs)
        elseif className == "Hunter" then
            self:CreateHunterOptions(categoryArgs, itemTypes)
        else
            for t_itemType, itemData in pairs(itemTypes) do
                local subCategoryArgs = self:CreateSubCategoryOptions(t_itemType, itemData)
                categoryArgs.args[t_itemType] = subCategoryArgs
            end
        end

        self.options.args[className] = categoryArgs
    end
end

function ReagentFiller:CreateSubCategoryOptions(t_itemType, t_itemData)
    local subCategoryArgs = {
        type = "group",
        name = t_itemType,
        order = 1,
        inline = false,
        args = {}
    }

    for itemID, itemData in pairs(t_itemData) do
        local itemName = self:GetItemInfo(itemID) or "?"
        local _, _, _, _, lvl = self:GetItemInfo(itemID)
        local nameWithLevel = itemName .. (lvl and lvl ~= 0 and " (Level " .. lvl .. ")" or "")

        if(itemData.version == nil or itemData.version == WOW_PROJECT_ID) then
            local args = {
                type = "group",
                name = nameWithLevel,
                order = 1,
                inline = true,
                args = {}
            }
            args.args.enabled = {
                type = "toggle",
                name = "Enabled",
                order = 1,
                get = function(info) return itemData.enabled end,
                set = function(info, value) 
                    itemData.enabled = value 
                end,
            }
            args.args.quantityToBuy = {
                type = "range",
                name = "Set Buy Limit",
                order = 2,
                min = 0,
                max = itemData.maxQuantity or 100,
                step = itemData.batchSize or 1,
                get = function(info) return itemData.quantityToBuy end,
                set = function(info, value) 
                    itemData.quantityToBuy = value 
                end,
            }

            subCategoryArgs.args[itemName] = args
        end
    end

    return subCategoryArgs
end

function ReagentFiller:AddCustomItems(categoryArgs, categoryName, categoryTable)
    -- Define the "Create New Subcategory" section
    local newSubCategoryName
    categoryArgs.args.addSubcategory = {
        type = "group",
        name = "Create Your Own Subcategory",
        inline = true,
        order = 0,
        args = {
            subCategoryName = {
                type = "input",
                name = "Subcategory Name (e.g. Food)",
                desc = "Enter the name of the new subcategory then press Enter.",
                order = 1,
                set = function(info, value)
                    newSubCategoryName = value
                    if categoryTable[newSubCategoryName] then
                        self:Print("Subcategory already exists: " .. newSubCategoryName)
                        return
                    end
                    if newSubCategoryName == "" then
                        self:Print("Subcategory name cannot be empty.")
                        return
                    end
                    self:Print("Added new subcategory named: " .. newSubCategoryName)
                    self.db.char.reagents["--Custom--"][newSubCategoryName] = {}
                    self:RefreshOptions()
                end,
            },
        },
    }

    -- Define the "Edit Category" section
    categoryArgs.args.editCategory = {
        type = "group",
        name = "Edit Category",
        inline = true,
        order = 1,
        args = {
            subCategoryDropdown = {
                type = "select",
                name = "Select Subcategory",
                desc = "Select a subcategory to edit",
                order = 0,
                width = 1.25,
                values = function()
                    local dropdownValues = {}
                    for subCategoryName, _ in pairs(categoryTable) do
                        dropdownValues[subCategoryName] = subCategoryName
                    end
                    return dropdownValues
                end,
                set = function(info, value)
                    info.handler.selectedSubcategory = value
                end,
                get = function(info)
                    return info.handler.selectedSubcategory
                end,
            },
            itemName = {
                type = "input",
                name = "Add an Item by ID or Item Link",
                desc = "Enter the item's ID or shift click the item to link.",
                order = 1,
                width = 1.25,
                set = function(info, value)
                    local itemID = self:GetItemID(value)
                    if(info.handler.selectedSubcategory == nil) then
                        self:Print("Please select a subcategory first.")
                        return
                    end
                    if not itemID then
                        self:Print("Invalid item name, ID, or link.")
                        return
                    end
                    if categoryTable[info.handler.selectedSubcategory][itemID] then
                        self:Print("Item already exists: " .. itemID)
                        return
                    end
                    self.db.char.reagents["--Custom--"][info.handler.selectedSubcategory][itemID] = {
                        batchSize = 1,
                        enabled = false,
                        quantityToBuy = 0,
                    }
                    self:RefreshOptions()
                end,
            },
            removeSubcategory = {
                type = "execute",
                name = "Remove Subcategory",
                desc = "Remove the selected subcategory",
                order = 2,
                width = "normal",
                func = function(info)
                    local subCategoryName = info.handler.selectedSubcategory
                    if subCategoryName then
                        if categoryName == "--Custom--" then
                            ReagentFiller.db.char.reagents["--Custom--"][subCategoryName] = nil
                        else
                            categoryTable[subCategoryName] = nil
                        end
                        info.handler.selectedSubcategory = nil
                    end
                    self:RefreshOptions()
                end,
            },
        },
    }
end

function ReagentFiller:AddCustomSubcategories(categoryArgs)
    local customCategoryTable = self.db.char.reagents["--Custom--"]
    if not customCategoryTable then
        return
    end

    for subCategory, subCategoryTable in pairs(customCategoryTable) do
        local subCategoryArgs = {
            type = "group",
            name = subCategory,
            order = 2,
            inline = false,
            args = {}
        }

        for itemID, itemData in pairs(subCategoryTable) do
            local itemName = self:GetItemInfo(itemID) or "?"
            local _, _, _, _, lvl = self:GetItemInfo(itemID)
            local nameWithLevel = itemName .. (lvl and lvl ~= 0 and " (Level " .. lvl .. ")" or "")

            local args = {
                type = "group",
                name = nameWithLevel,
                order = 1,
                inline = true,
                args = {}
            }

            args.args.enabled = {
                type = "toggle",
                name = "Enabled",
                order = 1,
                get = function(info) return itemData.enabled end,
                set = function(info, value) 
                    itemData.enabled = value 
                end,
            }

            args.args.quantityToBuy = {
                type = "range",
                name = "Set Buy Limit",
                order = 2,
                min = 0,
                max = itemData.maxQuantity or 100,
                step = itemData.batchSize or 1,
                get = function(info) return itemData.quantityToBuy end,
                set = function(info, value) 
                    itemData.quantityToBuy = value 
                end,
            }
            --[[
            args.args.batchSize = {
                type = "range",
                name = "Size of Batch (vials are 5)",
                order = 3,
                min = 0,
                max =  200,
                step = 5,
                get = function(info) return itemData.batchSize end,
                set = function(info, value) 
                    itemData.batchSize = value 
                end,
            }
            ]]

            subCategoryArgs.args[itemName] = args
        end

        categoryArgs.args[subCategory] = subCategoryArgs
    end
end

function ReagentFiller:CreateHunterOptions(categoryArgs, categoryTable)
    local subCategories = {}
    local subCategoryArgs = {}

    for subCategory, subCategoryTable in pairs(categoryTable) do
        for itemID, itemData in pairs(subCategoryTable) do
            local itemName = self:GetItemInfo(itemID) or "?"

            if not subCategories[subCategory] then
                local args = {
                    type = "group",
                    name = "Hunter " .. subCategory,
                    order = 1,
                    inline = true,
                    args = {}
                }

                args.args.fillQuiver = {
                    type = "toggle",
                    name = "Fill Quiver",
                    order = 1,
                    get = function(info) return subCategoryTable.fillQuiver end,
                    set = function(info, value) 
                        subCategoryTable.fillQuiver = value
                    end,
                }

                args.args.selectedItem = {
                    type = "select",
                    name = "Item",
                    order = 2,
                    width = 1.25,
                    values = function()
                        local itemValues = {}
                        for id, data in pairs(subCategoryTable) do
                            if((id ~= "fillQuiver" and id ~= "fillQuiverID") and (data.version == nil or data.version == WOW_PROJECT_ID)) then
                                itemValues[id] =  self:GetItemNameWithLevel(id)
                            end
                        end
                        return itemValues
                    end,
                    get = function() return subCategoryTable.fillQuiverID end,
                    set = function(info, value)
                        subCategoryTable.fillQuiverID = value
                    end,
                    hidden = function() return not subCategoryTable.fillQuiver end
                }

                subCategoryArgs[subCategory] = args
                subCategories[subCategory] = true
            end

            subCategoryArgs[subCategory].args[itemName] = args
        end
    end

    for subCategory, args in pairs(subCategoryArgs) do
        categoryArgs.args[subCategory] = args
    end

    return categoryArgs
end

function ReagentFiller:CreateLowReagentPopup()
    -- Frame itself
    local frame = AceGUI:Create("Frame")
    frame:SetTitle("Low Reagent Alert")
    frame:SetWidth(200)
    frame:SetHeight(60)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, -100)
    frame:SetStatusText("LOW REAGENTS")
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    frame:SetLayout("List")

    -- OK Button
    local button = AceGUI:Create("Button")
    button:SetText("OK")
    button:SetWidth(170)
    button:SetCallback("OnClick", function() AceGUI:Release(frame) end)
    frame:AddChild(button)

    frame:SetLayout("List")
    frame:Show()
end


