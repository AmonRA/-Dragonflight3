DRAGONFLIGHT()

DF:NewDefaults('itemcompare', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'tooltip', 'Compare'},
    },
    enableItemCompare = {value = true, metadata = {element = 'checkbox', category = 'Compare', indexInCategory = 1, description = 'Show equipped item tooltip when hovering items with Shift'}},
})

DF:NewModule('itemcompare', 1, function()
    local itemcompare = {}

    local slotTable = {
        ['Two-Hand'] = 'MainHandSlot',
        ['Shirt'] = 'ShirtSlot',
        ['Chest'] = 'ChestSlot',
        ['Back'] = 'BackSlot',
        ['Feet'] = 'FeetSlot',
        ['Finger'] = 'Finger0Slot',
        ['Hands'] = 'HandsSlot',
        ['Head'] = 'HeadSlot',
        ['Held In Off-hand'] = 'SecondaryHandSlot',
        ['Legs'] = 'LegsSlot',
        ['Neck'] = 'NeckSlot',
        ['Ranged'] = 'RangedSlot',
        ['Relic'] = 'RangedSlot',
        ['Robe'] = 'ChestSlot',
        ['Shield'] = 'SecondaryHandSlot',
        ['Shoulder'] = 'ShoulderSlot',
        ['Tabard'] = 'TabardSlot',
        ['Trinket'] = 'Trinket0Slot',
        ['Waist'] = 'WaistSlot',
        ['Main Hand'] = 'MainHandSlot',
        ['One-Hand'] = 'MainHandSlot',
        ['Off Hand'] = 'SecondaryHandSlot',
        ['Wrist'] = 'WristSlot',
        ['Wand'] = 'RangedSlot',
        ['Gun'] = 'RangedSlot',
        ['Projectile'] = 'AmmoSlot',
        ['Crossbow'] = 'RangedSlot',
        ['Thrown'] = 'RangedSlot',
    }

    function itemcompare:AddHeader(tooltip)
        local name = tooltip:GetName()
        for i = tooltip:NumLines(), 1, -1 do
            local left = getglobal(name .. 'TextLeft' .. i)
            local right = getglobal(name .. 'TextRight' .. i)
            local leftBelow = getglobal(name .. 'TextLeft' .. (i + 1))
            local rightBelow = getglobal(name .. 'TextRight' .. (i + 1))

            if left and left:IsShown() then
                local text = left:GetText()
                local r, g, b = left:GetTextColor()
                if text and text ~= '' then
                    if tooltip:NumLines() < i + 1 then
                        tooltip:AddLine(text, r, g, b, true)
                    else
                        leftBelow:SetText(text)
                        leftBelow:SetTextColor(r, g, b)
                        leftBelow:Show()
                        left:Hide()
                    end
                end
            end

            if right and right:IsShown() then
                local text = right:GetText()
                local r, g, b = right:GetTextColor()
                if text and text ~= '' then
                    rightBelow:SetText(text)
                    rightBelow:SetTextColor(r, g, b)
                    rightBelow:Show()
                    right:Hide()
                end
            end
        end

        getglobal(name .. 'TextLeft1'):SetTextColor(.5, .5, .5, 1)
        getglobal(name .. 'TextLeft1'):SetText('Currently Equipped')
        getglobal(name .. 'TextLeft1'):Show()
        tooltip:Show()
    end

    function itemcompare:ShowComparison()
        if not IsShiftKeyDown() then
            ShoppingTooltip1:Hide()
            return
        end

        for i = 1, GameTooltip:NumLines() do
            local line = getglobal('GameTooltipTextLeft' .. i)
            if line then
                local text = line:GetText()
                if text and slotTable[text] then
                    local slotID = GetInventorySlotInfo(slotTable[text])
                    local x = GetCursorPosition()
                    x = x / UIParent:GetEffectiveScale()
                    local anchorLeft = x < (GetScreenWidth() / 2)

                    ShoppingTooltip1:SetOwner(GameTooltip, 'ANCHOR_NONE')
                    ShoppingTooltip1:ClearAllPoints()
                    if anchorLeft then
                        ShoppingTooltip1:SetPoint('BOTTOMLEFT', GameTooltip, 'BOTTOMRIGHT', 0, 0)
                    else
                        ShoppingTooltip1:SetPoint('BOTTOMRIGHT', GameTooltip, 'BOTTOMLEFT', 0, 0)
                    end
                    ShoppingTooltip1:SetInventoryItem('player', slotID)
                    ShoppingTooltip1:Show()
                    itemcompare:AddHeader(ShoppingTooltip1)
                    return
                end
            end
        end
        ShoppingTooltip1:Hide()
    end

    local updateTimerId = DF.timers.every(0.1, function()
        itemcompare:ShowComparison()
    end)

    function itemcompare:SetupHooks()
        DF.hooks.HookSecureFunc(GameTooltip, 'Show', function()
            itemcompare:ShowComparison()
            DF.timers.resume(updateTimerId)
        end)

        DF.hooks.HookSecureFunc(GameTooltip, 'Hide', function()
            DF.timers.pause(updateTimerId)
            ShoppingTooltip1:Hide()
        end)
    end

    function itemcompare:RemoveHooks()
        DF.hooks.Unhook(GameTooltip, 'Show')
        DF.hooks.Unhook(GameTooltip, 'Hide')
        DF.timers.pause(updateTimerId)
    end

    local callbacks = {}

    callbacks.enableItemCompare = function(value)
        if value then
            itemcompare:SetupHooks()
        else
            itemcompare:RemoveHooks()
        end
    end

    DF:NewCallbacks('itemcompare', callbacks)
end)
