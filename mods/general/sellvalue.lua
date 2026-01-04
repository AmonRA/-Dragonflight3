---@diagnostic disable: duplicate-set-field
DRAGONFLIGHT()

DF:NewDefaults('sellvalue', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'general', subtab = 'tweaks', 'Selling'},
    },
    enableSellValue = {value = true, metadata = {element = 'checkbox', category = 'Selling', indexInCategory = 1, description = 'Show vendor sell/buy prices on item tooltips'}},
})

DF:NewModule('sellvalue', 1, function()
    local sellvalue = {}
    local currentItemLink = nil
    local currentItemCount = nil
    local currentContainer = nil
    local currentSlot = nil
    local linesAdded = false
    local wasShiftDown = false

    function sellvalue:AddVendorPrices(frame, id, count)
        if DF.tables['sellData'][id] then
            local _, _, sell, buy = string.find(DF.tables['sellData'][id], '(.*),(.*)')
            sell = tonumber(sell)
            buy = tonumber(buy)

            if not MerchantFrame:IsShown() then
                if sell > 0 then SetTooltipMoney(frame, sell * count) end
            end

            if IsShiftKeyDown() then
                frame:AddLine(' ')
                if count > 1 then
                    frame:AddDoubleLine('Sell:', DF.common.CreateGoldString(sell) .. '|cff555555  //  ' .. DF.common.CreateGoldString(sell * count), 1, 1, 1)
                else
                    frame:AddDoubleLine('Sell:', DF.common.CreateGoldString(sell * count), 1, 1, 1)
                end
                if count > 1 then
                    frame:AddDoubleLine('Buy:', DF.common.CreateGoldString(buy) .. '|cff555555  //  ' .. DF.common.CreateGoldString(buy * count), 1, 1, 1)
                else
                    frame:AddDoubleLine('Buy:', DF.common.CreateGoldString(buy), 1, 1, 1)
                end
            end
            frame:Show()
        end
    end

    function sellvalue:SetupHooks()
        DF.hooks.HookSecureFunc(GameTooltip, 'SetBagItem', function(_, container, slot)
            currentItemLink = GetContainerItemLink(container, slot)
            _, currentItemCount = GetContainerItemInfo(container, slot)
            currentContainer = container
            currentSlot = slot
        end, true)

        DF.hooks.HookSecureFunc(GameTooltip, 'SetInventoryItem', function(_, unit, slot)
            currentItemLink = GetInventoryItemLink(unit, slot)
            currentItemCount = nil
        end, true)

        DF.hooks.HookSecureFunc(GameTooltip, 'SetMerchantItem', function(_, merchantIndex)
            currentItemLink = GetMerchantItemLink(merchantIndex)
            currentItemCount = nil
        end, true)

        DF.hooks.HookSecureFunc(GameTooltip, 'SetLootItem', function(_, slot)
            currentItemLink = GetLootSlotLink(slot)
            currentItemCount = nil
        end, true)

        DF.hooks.HookSecureFunc(GameTooltip, 'SetAuctionItem', function(_, atype, index)
            _, _, currentItemCount = GetAuctionItemInfo(atype, index)
            currentItemLink = GetAuctionItemLink(atype, index)
        end, true)

        DF.hooks.HookSecureFunc('SetItemRef', function(link, _, _)
            local item, _, id = string.find(link, 'item:(%d+):.*')
            if not IsAltKeyDown() and not IsShiftKeyDown() and not IsControlKeyDown() and item then
                sellvalue:AddVendorPrices(ItemRefTooltip, tonumber(id), 1)
            end
        end, true)
    end

    function sellvalue:RemoveHooks()
        DF.hooks.Unhook(GameTooltip, 'SetBagItem')
        DF.hooks.Unhook(GameTooltip, 'SetInventoryItem')
        DF.hooks.Unhook(GameTooltip, 'SetMerchantItem')
        DF.hooks.Unhook(GameTooltip, 'SetLootItem')
        DF.hooks.Unhook(GameTooltip, 'SetAuctionItem')
        DF.hooks.Unhook('SetItemRef')
        DF.timers.pause(updateTimerId)
    end

    function sellvalue:ProcessTooltip()
        if not currentItemLink then return end
        local _, _, itemID = string.find(currentItemLink, 'item:(%d+):%d+:%d+:%d+')
        local count = tonumber(currentItemCount) or 1
        sellvalue:AddVendorPrices(GameTooltip, tonumber(itemID), math.max(count, 1))
    end

    function sellvalue:OnShiftUpdate()
        local isShiftDown = IsShiftKeyDown()
        if currentItemLink and isShiftDown and not linesAdded then
            sellvalue:ProcessTooltip()
            linesAdded = true
        elseif currentItemLink and wasShiftDown and not isShiftDown and linesAdded and GameTooltip:IsShown() then
            if currentContainer and currentSlot then
                GameTooltip:ClearLines()
                GameTooltip:SetBagItem(currentContainer, currentSlot)
                local _, _, itemID = string.find(currentItemLink, 'item:(%d+):%d+:%d+:%d+')
                local count = tonumber(currentItemCount) or 1
                if DF.tables['sellData'][tonumber(itemID)] then
                    local _, _, sell = string.find(DF.tables['sellData'][tonumber(itemID)], '(.*),.*')
                    sell = tonumber(sell)
                    if not MerchantFrame:IsShown() and sell > 0 then
                        SetTooltipMoney(GameTooltip, sell * count)
                    end
                end
                GameTooltip:Show()
            end
            linesAdded = false
        end
        wasShiftDown = isShiftDown
    end

    local updateTimerId = DF.timers.every(0.1, function()
        sellvalue:OnShiftUpdate()
    end)

    local tooltipFrame = CreateFrame('Frame', 'DF_SellValueTooltip', GameTooltip)
    tooltipFrame:SetScript('OnShow', function()
        linesAdded = false
        DF.timers.resume(updateTimerId)
        if not IsShiftKeyDown() then
            sellvalue:ProcessTooltip()
        end
    end)

    tooltipFrame:SetScript('OnHide', function()
        DF.timers.pause(updateTimerId)
        linesAdded = false
        currentItemLink = nil
        currentItemCount = nil
        currentContainer = nil
        currentSlot = nil
    end)

    local callbacks = {}

    callbacks.enableSellValue = function(value)
        if value then
            sellvalue:SetupHooks()
        else
            sellvalue:RemoveHooks()
        end
    end

    DF:NewCallbacks('sellvalue', callbacks)
end)
