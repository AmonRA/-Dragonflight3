DRAGONFLIGHT()

DF:NewDefaults('hoverbind', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('hoverbind', 1, function()
    local hover = {}

    local keymap = {
        -- Main bar and bonus bars (action IDs 1-12, 73-84)
        ['DF_MainBarButton'] = 'ACTIONBUTTON',
        ['DF_BonusBar1Button'] = 'ACTIONBUTTON',
        ['DF_BonusBar2Button'] = 'ACTIONBUTTON',
        ['DF_BonusBar3Button'] = 'ACTIONBUTTON',
        ['DF_BonusBar4Button'] = 'ACTIONBUTTON',

        -- Multi bars
        ['DF_MultiBar1Button'] = 'MULTIACTIONBAR1BUTTON',  -- IDs 61-72
        ['DF_MultiBar2Button'] = 'MULTIACTIONBAR2BUTTON',  -- IDs 49-60
        ['DF_MultiBar3Button'] = 'MULTIACTIONBAR3BUTTON',  -- IDs 37-48
        ['DF_MultiBar4Button'] = 'MULTIACTIONBAR4BUTTON',  -- IDs 25-36
        ['DF_MultiBar5Button'] = 'MULTIACTIONBAR1BUTTON',  -- if multibar5 uses same bindings

        -- Pet bar (IDs 133-142)
        ['DF_PetBarButton'] = 'BONUSACTIONBUTTON',

        -- Stance bar (IDs 200-209)
        ['DF_StanceBarButton'] = 'SHAPESHIFTBUTTON',
    }

    local mousebuttonmap = {
        ['LeftButton']   = 'BUTTON1',
        ['RightButton']  = 'BUTTON2',
        ['MiddleButton'] = 'BUTTON3',
        ['Button4']      = 'BUTTON4',
        ['Button5']      = 'BUTTON5',
    }

    local mousewheelmap = {
        [1]  = 'MOUSEWHEELUP',
        [-1] = 'MOUSEWHEELDOWN',
    }

    local modifiers = {
        ['ALT']   = 'ALT-',
        ['CTRL']  = 'CTRL-',
        ['SHIFT'] = 'SHIFT-'
    }

    local blockedKeys = {
        'LeftButton',
        'RightButton',
    }

    hover.infoPanel = DF.ui.CreatePaperDollFrame('DF_HoverbindInfo', UIParent, 300, 150, 3)
    hover.infoPanel:SetPoint('TOP', UIParent, 'TOP', 0, -100)
    hover.infoPanel:Hide()

    local title = DF.ui.Font(hover.infoPanel, 12, 'Hoverbind Mode', {1, 0, 0}, 'CENTER', 'OUTLINE')
    title:SetPoint('TOP', hover.infoPanel, 'TOP', 0, -33)

    local line1 = DF.ui.Font(hover.infoPanel, 10, 'Hover over a button and press a key to bind it', {1, 1, 1}, 'CENTER')
    line1:SetPoint('TOP', title, 'BOTTOM', 0, -15)

    local line2 = DF.ui.Font(hover.infoPanel, 10, 'Press ESC on a button to remove bindings', {1, 1, 1}, 'CENTER')
    line2:SetPoint('TOP', line1, 'BOTTOM', 0, -8)

    local line3 = DF.ui.Font(hover.infoPanel, 10, 'Press ESC or click outside to exit', {1, 1, 1}, 'CENTER')
    line3:SetPoint('TOP', line2, 'BOTTOM', 0, -8)

    function hover:GetBinding(buttonName)
        local found, _, buttonType, buttonIndex = string.find(buttonName, '^(.-)(%d+)$')
        if found and keymap[buttonType] then
            return string.format('%s%d', keymap[buttonType], buttonIndex)
        end
        return nil
    end

    function hover:GetPrefix()
        return string.format('%s%s%s',
            (IsAltKeyDown() and modifiers.ALT or ''),
            (IsControlKeyDown() and modifiers.CTRL or ''),
            (IsShiftKeyDown() and modifiers.SHIFT or ''))
    end

    local function GetHoverbindHandler(map)
        return function()
            if modifiers[arg1] then return end

            local prefix = hover:GetPrefix()

            if not prefix or prefix == '' then
                for _, blockedKey in ipairs(blockedKeys) do
                    if arg1 == blockedKey then return end
                end
            end

            local frame = GetMouseFocus()
            local hovername = (frame and frame.button and frame.button.GetName) and frame.button:GetName() or ''
            local binding = hover:GetBinding(hovername)
            if arg1 == 'ESCAPE' and not binding then hover:Hide() return end
            if binding then
                if arg1 == 'ESCAPE' then
                    local key = GetBindingKey(binding)
                    if key then
                        SetBinding(key)
                        SaveBindings(GetCurrentBindingSet())
                    end
                else
                    local key = map and map[arg1] or arg1
                    if SetBinding(prefix..key, binding) then
                        SaveBindings(GetCurrentBindingSet())
                    end
                end
            end
        end
    end

    function hover:CreateHoverbindFrames()
        if not DF.setups.actionbars or not DF.setups.actionbars.bars then return end

        local frames = {}
        for barName, bar in pairs(DF.setups.actionbars.bars) do
            if bar.buttons then
                for i = 1, table.getn(bar.buttons) do
                    local button = bar.buttons[i]
                    local frame = CreateFrame('Frame', button:GetName()..'HoverbindFrame', button)
                    frame:SetAllPoints(button)
                    frame:EnableKeyboard(true)
                    frame:EnableMouse(true)
                    frame:EnableMouseWheel(true)
                    frame:Hide()
                    frame.button = button

                    frame:SetScript('OnKeyUp', GetHoverbindHandler())
                    frame:SetScript('OnMouseUp', GetHoverbindHandler(mousebuttonmap))
                    frame:SetScript('OnMouseWheel', GetHoverbindHandler(mousewheelmap))

                    frame:SetScript('OnEnter', function()
                        if button.highlight then button.highlight:Show() end
                        local binding = hover:GetBinding(button:GetName())
                        if binding then
                            local key1, key2 = GetBindingKey(binding)
                            if key1 or key2 then
                                GameTooltip:SetOwner(button, 'ANCHOR_RIGHT')
                                local text = ''
                                if key1 then
                                    text = 'Primary: '..GetBindingText(key1, 'KEY_')
                                end
                                if key2 then
                                    if text ~= '' then text = text..'\n' end
                                    text = text..'Secondary: '..GetBindingText(key2, 'KEY_')
                                end
                                GameTooltip:SetText(text)
                                GameTooltip:Show()
                            end
                        end
                    end)

                    frame:SetScript('OnLeave', function()
                        if button.highlight then button.highlight:Hide() end
                        GameTooltip:Hide()
                    end)

                    table.insert(frames, frame)
                end
            end
        end
        return frames
    end

    function hover:ShowHoverbindFrames()
        if not self.frames then return end
        for _, frame in ipairs(self.frames) do
            frame:Show()
        end
    end

    function hover:HideHoverbindFrames()
        if not self.frames then return end
        for _, frame in ipairs(self.frames) do
            frame:Hide()
        end
    end

    function hover:Show()
        if not self.mainFrame then return end
        self.mainFrame:Show()
    end

    function hover:Hide()
        if not self.mainFrame then return end
        self.mainFrame:Hide()
    end

    hover.mainFrame = CreateFrame('Frame', 'DF_HoverbindFrame', UIParent)
    hover.mainFrame:Hide()
    hover.mainFrame:RegisterEvent('PLAYER_REGEN_DISABLED')
    hover.mainFrame:EnableMouse(true)
    hover.overlay = CreateFrame('Button', 'DF_HoverbindOverlay', hover.mainFrame)
    hover.overlay:SetFrameStrata('BACKGROUND')
    hover.overlay:SetAllPoints(UIParent)
    hover.overlay.tex = hover.overlay:CreateTexture(nil, 'BACKGROUND')
    hover.overlay.tex:SetAllPoints(hover.overlay)
    hover.overlay.tex:SetTexture(0, 0, 0, .5)

    hover.overlay:SetScript('OnClick', function()
        hover:Hide()
    end)

    hover.mainFrame:SetScript('OnMouseUp', function()
        hover:Hide()
    end)

    hover.mainFrame:SetScript('OnShow', function()
        if not hover.frames then
            hover.frames = hover:CreateHoverbindFrames()
        end
        hover.overlay:Show()
        hover:ShowHoverbindFrames()
        if hover.infoPanel then hover.infoPanel:Show() end
    end)

    hover.mainFrame:SetScript('OnHide', function()
        hover:HideHoverbindFrames()
        hover.overlay:Hide()
        if hover.infoPanel then hover.infoPanel:Hide() end
    end)

    hover.mainFrame:SetScript('OnEvent', function()
        hover:Hide()
    end)

    DF.setups.hover = hover
end)
