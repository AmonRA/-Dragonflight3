DRAGONFLIGHT()
-- first attempt at raid frmaes.. fckign sucks...

DF:NewDefaults('raid', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'unitframes', subtab = 'raid', 'Frame', 'HP Text', 'HP Bar', 'Total HP Bar', 'Gradient Colors', 'Range', 'Focus Frame'},
    },
    frameWidth = {value = 60, metadata = {element = 'slider', category = 'Frame', indexInCategory = 1, description = 'Frame width', min = 40, max = 150, stepSize = 1}},
    frameHeight = {value = 40, metadata = {element = 'slider', category = 'Frame', indexInCategory = 2, description = 'Frame height', min = 30, max = 100, stepSize = 1}},
    frameSpacing = {value = 4, metadata = {element = 'slider', category = 'Frame', indexInCategory = 3, description = 'Space between frames', min = 0, max = 10, stepSize = 1}},
    framePadding = {value = 10, metadata = {element = 'slider', category = 'Frame', indexInCategory = 4, description = 'Space between frames and border', min = 0, max = 20, stepSize = 1}},
    raidIconPosition = {value = 'left', metadata = {element = 'dropdown', category = 'Frame', indexInCategory = 5, description = 'Raid icon position', options = {'top', 'left', 'right', 'bottom'}}},
    showNames = {value = true, metadata = {element = 'checkbox', category = 'Frame', indexInCategory = 6, description = 'Show unit names'}},
    nameTextSize = {value = 10, metadata = {element = 'slider', category = 'Frame', indexInCategory = 7, description = 'Name text size', min = 6, max = 16, stepSize = 1}},
    showGroupHeaders = {value = true, metadata = {element = 'checkbox', category = 'Frame', indexInCategory = 8, description = 'Show group headers'}},
    headerTextSize = {value = 10, metadata = {element = 'slider', category = 'Frame', indexInCategory = 9, description = 'Header text size', min = 6, max = 16, stepSize = 1}},
    showManaBar = {value = true, metadata = {element = 'checkbox', category = 'Frame', indexInCategory = 10, description = 'Show mana bar'}},
    manaBarHeight = {value = 5, metadata = {element = 'slider', category = 'Frame', indexInCategory = 11, description = 'Mana bar height', min = 3, max = 15, stepSize = 1}},
    font = {value = 'font:PT-Sans-Narrow-Bold.ttf', metadata = {element = 'dropdown', category = 'Frame', indexInCategory = 12, description = 'Font family', options = media.fonts}},
    showTargetBorder = {value = true, metadata = {element = 'checkbox', category = 'Frame', indexInCategory = 13, description = 'Show target border'}},
    targetBorderColor = {value = {1, 1, 0}, metadata = {element = 'colorpicker', category = 'Frame', indexInCategory = 14, description = 'Target border color', dependency = {key = 'showTargetBorder', state = true}}},
    showAggroBorder = {value = true, metadata = {element = 'checkbox', category = 'Frame', indexInCategory = 15, description = 'Show aggro border'}},
    aggroBorderColor = {value = {1, 0, 0}, metadata = {element = 'colorpicker', category = 'Frame', indexInCategory = 16, description = 'Aggro border color', dependency = {key = 'showAggroBorder', state = true}}},
    containerBgColor = {value = {0, 0, 0}, metadata = {element = 'colorpicker', category = 'Frame', indexInCategory = 17, description = 'Container background color'}},
    containerBgAlpha = {value = 0.3, metadata = {element = 'slider', category = 'Frame', indexInCategory = 18, description = 'Container background alpha', min = 0, max = 1, stepSize = 0.05}},
    unitBgColor = {value = {0, 0, 0}, metadata = {element = 'colorpicker', category = 'Frame', indexInCategory = 19, description = 'Unit frame background color'}},
    unitBgAlpha = {value = 0.3, metadata = {element = 'slider', category = 'Frame', indexInCategory = 20, description = 'Unit frame background alpha', min = 0, max = 1, stepSize = 0.05}},
    statusBarTexture = {value = 'Dragonflight', metadata = {element = 'dropdown', category = 'Frame', indexInCategory = 21, description = 'Health and mana bar texture', options = {'Blizzard', 'Dragonflight', 'Dragonflight Reversed', 'Flat'}}},
    showControlFrame = {value = true, metadata = {element = 'checkbox', category = 'Frame', indexInCategory = 22, description = 'Show control frame'}},
    hpTextFormat = {value = 'missing', metadata = {element = 'dropdown', category = 'HP Text', indexInCategory = 1, description = 'HP text display format', options = {'current', 'cur/max', 'missing'}}},
    hpTextStyle = {value = 'abbreviated', metadata = {element = 'dropdown', category = 'HP Text', indexInCategory = 2, description = 'Number abbreviation style', options = {'normal', 'abbreviated'}}},
    hpTextSize = {value = 15, metadata = {element = 'slider', category = 'HP Text', indexInCategory = 3, description = 'HP text font size', min = 6, max = 16, stepSize = 1}},
    hpTextColorMode = {value = 'gradient', metadata = {element = 'dropdown', category = 'HP Text', indexInCategory = 4, description = 'HP text color mode', options = {'normal', 'gradient'}}},
    hpBarColorMode = {value = 'class', metadata = {element = 'dropdown', category = 'HP Bar', indexInCategory = 1, description = 'HP bar color mode', options = {'class', 'static', 'gradient'}}},
    hpBarStaticColor = {value = {0, 1, 0}, metadata = {element = 'colorpicker', category = 'HP Bar', indexInCategory = 2, description = 'HP bar static color', dependency = {key = 'hpBarColorMode', state = 'static'}}},
    hpBarUseFullColor = {value = false, metadata = {element = 'checkbox', category = 'HP Bar', indexInCategory = 3, description = 'Use special color at full HP'}},
    hpBarFullColor = {value = {0, 0, 0}, metadata = {element = 'colorpicker', category = 'HP Bar', indexInCategory = 4, description = 'Full HP color', dependency = {key = 'hpBarUseFullColor', state = true}}},
    totalHpBarColorMode = {value = 'gradient', metadata = {element = 'dropdown', category = 'Total HP Bar', indexInCategory = 1, description = 'Total HP bar color mode', options = {'static', 'gradient'}}},
    totalHpBarStaticColor = {value = {0, 1, 0}, metadata = {element = 'colorpicker', category = 'Total HP Bar', indexInCategory = 2, description = 'Total HP bar static color', dependency = {key = 'totalHpBarColorMode', state = 'static'}}},
    totalHpTextSize = {value = 10, metadata = {element = 'slider', category = 'Total HP Bar', indexInCategory = 3, description = 'Total HP text font size', min = 6, max = 16, stepSize = 1}},
    totalHpBarSpacing = {value = 15, metadata = {element = 'slider', category = 'Total HP Bar', indexInCategory = 4, description = 'Spacing from frames', min = 0, max = 30, stepSize = 1}},
    gradientLow = {value = {1, 0, 0}, metadata = {element = 'colorpicker', category = 'Gradient Colors', indexInCategory = 1, description = 'Low HP color'}},
    gradientMid = {value = {1, 1, 0}, metadata = {element = 'colorpicker', category = 'Gradient Colors', indexInCategory = 2, description = 'Mid HP color'}},
    gradientHigh = {value = {0, 1, 0}, metadata = {element = 'colorpicker', category = 'Gradient Colors', indexInCategory = 3, description = 'High HP color'}},
    range = {value = 10, metadata = {element = 'slider', category = 'Range', indexInCategory = 1, description = 'Range fade distance', min = 5, max = 50, stepSize = 1}},
    rangeFading = {value = 'gradient', metadata = {element = 'dropdown', category = 'Range', indexInCategory = 2, description = 'Out of range fading mode', options = {'off', 'instant', 'gradient'}}},
    minAlpha = {value = 0.1, metadata = {element = 'slider', category = 'Range', indexInCategory = 3, description = 'Minimum alpha for fade out', min = 0, max = 1, stepSize = 0.05}},
    specialUpdateRate = {value = 0.5, metadata = {element = 'slider', category = 'Focus Frame', indexInCategory = 1, description = 'Focus frame update rate (0.1s - 1s)', min = 0.1, max = 1, stepSize = 0.1}},

})

DF:NewModule('raid', 1, function()
    local interact = DF.setups.interact

    local setup = {
        frameWidth = 70,
        frameHeight = 45,
        frameSpacing = 4,
        framePadding = 10,
        cols = 8,
        rows = 5,
        raidIconPosition = 'top',
        specialUpdateRate = 0.5,
        events = {
            raid = {
                'RAID_ROSTER_UPDATE',
                'PLAYER_ENTERING_WORLD',
                'RAID_TARGET_UPDATE'
            },
            frame = {
                'RAID_ROSTER_UPDATE',
                'UNIT_HEALTH',
                'UNIT_MAXHEALTH',
                'UNIT_MANA',
                'UNIT_MAXMANA'
            },
        },
    }

    local testClasses = {'WARRIOR', 'MAGE', 'ROGUE', 'DRUID', 'HUNTER', 'SHAMAN', 'PRIEST', 'WARLOCK', 'PALADIN'}

    local statusBarTextures = {
        ['Blizzard'] = 'Interface\\TargetingFrame\\UI-StatusBar',
        ['Dragonflight'] = media['tex:unitframes:aurora_hpbar.blp'],
        ['Dragonflight Reversed'] = media['tex:unitframes:aurora_hpbar_reversed.blp'],
        ['Flat'] = 'Interface\\Buttons\\WHITE8X8'
    }

    local groupHeaderSpacing = 5

    if DF.profile.raid.showGroupElements == nil then
        DF.profile.raid.showGroupElements = true
    end
    if DF.profile.raid.showSpecialFrame == nil then
        DF.profile.raid.showSpecialFrame = false
    end

    local alphaUpdater = CreateFrame('Frame')
    alphaUpdater:Hide()

    local function CreateUnitFrame(parent, unit, index)
        local f = CreateFrame('Button', nil, parent)
        f:SetSize(setup.frameWidth, setup.frameHeight)
        f.unit = unit
        f.index = index

        f.bg = f:CreateTexture(nil, 'BACKGROUND')
        f.bg:SetAllPoints(f)
        f.bg:SetTexture('Interface\\Buttons\\WHITE8X8')
        f.bg:SetVertexColor(0, 0, 0, .3)

        f.hp = CreateFrame('StatusBar', nil, f)
        f.hp:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, 0)
        f.hp:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 5)
        f.hp:SetStatusBarTexture(statusBarTextures[DF.profile.raid.statusBarTexture])
        f.hp:SetStatusBarColor(0, 1, 0)

        f.mana = CreateFrame('StatusBar', nil, f)
        f.mana:SetPoint('BOTTOMLEFT', f, 'BOTTOMLEFT', 0, 0)
        f.mana:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 0, 0)
        f.mana:SetHeight(5)
        f.mana:SetStatusBarTexture(statusBarTextures[DF.profile.raid.statusBarTexture])
        local powerType = UnitPowerType(unit or 'player')
        local color = DF.tables.powercolors[powerType] or {0, 0, 1}
        f.mana:SetStatusBarColor(color[1], color[2], color[3])

        f.overlay = CreateFrame('Frame', nil, f)
        f.overlay:SetAllPoints(f)
        f.overlay:SetFrameLevel(f:GetFrameLevel() + 2)

        f.name = DF.ui.Font(f.overlay, 10, '', {1, 1, 1}, 'CENTER', 'OUTLINE')
        f.name:SetPoint('TOP', f.overlay, 'TOP', 0, -2)

        f.hpText = DF.ui.Font(f.overlay, 10, '', {1, 1, 1}, 'CENTER', 'OUTLINE')
        f.hpText:SetPoint('CENTER', f.overlay, 'CENTER')

        f.targetBorderLeft = CreateFrame('Frame', nil, f.overlay)
        f.targetBorderLeft:SetFrameLevel(f.overlay:GetFrameLevel() + 3)
        f.targetBorderLeft:Hide()

        f.targetBorderRight = CreateFrame('Frame', nil, f.overlay)
        f.targetBorderRight:SetFrameLevel(f.overlay:GetFrameLevel() + 3)
        f.targetBorderRight:Hide()

        f.aggroBorder = CreateFrame('Frame', nil, f.overlay)
        f.aggroBorder:SetAllPoints(f)
        f.aggroBorder:SetFrameLevel(f.overlay:GetFrameLevel() + 4)
        f.aggroBorder:Hide()

        f.raidIcon = f.overlay:CreateTexture(nil, 'OVERLAY')
        f.raidIcon:SetSize(16, 16)
        f.raidIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons')
        f.raidIcon:Hide()

        f:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
        f:SetScript('OnClick', function() interact:OnClick(this) end)

        return f
    end

    local anchor = CreateFrame('Frame', 'DF_RaidAnchor', UIParent)
    anchor:SetSize(530, 240)
    anchor:SetPoint('TOPLEFT', UIParent, 'LEFT', 10, 143)

    local raid = CreateFrame('Frame', 'DF_RaidFrame', anchor)
    raid:SetPoint('TOPLEFT', anchor, 'TOPLEFT', 0, 0)
    raid:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8X8',
        edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border',
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {left = 4, right = 4, top = 4, bottom = 4}
    })
    raid:SetBackdropColor(0, 0, 0, 0.3)
    raid:SetBackdropBorderColor(0.3, 0.3, 0.3, .6)
    raid.frames = {}
    raid.groupHeaders = {}
    -- debugframe(raid)

    for i = 1, 40 do
        local f = CreateUnitFrame(raid, 'raid'..i, i)
        f:SetScript('OnEvent', function()
            setup:RefreshUnit(this)
            setup:UpdateRaidSize()
        end)
        for _, event in setup.events.frame do
            f:RegisterEvent(event)
        end
        raid.frames[i] = f
    end

    for i = 1, 40 do
        local f = raid.frames[i]
        local c = DF.profile.raid.targetBorderColor
        f.targetBorderLeftTex = DF.ui.CreateSelectiveBorder(f.targetBorderLeft, {top=true, bottom=true, left=true}, 2, c[1], c[2], c[3], 1)
        f.targetBorderRightTex = DF.ui.CreateSelectiveBorder(f.targetBorderRight, {top=true, bottom=true, right=true}, 2, c[1], c[2], c[3], 1)
        local ac = DF.profile.raid.aggroBorderColor
        f.aggroBorderTex = DF.ui.CreateSelectiveBorder(f.aggroBorder, {top=true, bottom=true, left=true, right=true}, 2, ac[1], ac[2], ac[3], 1)
    end

    for col = 1, 8 do
        local header = DF.ui.Font(raid, 10, 'Group '..col, {1, 1, 1}, 'CENTER', 'OUTLINE')
        header:SetPoint('BOTTOM', raid, 'TOPLEFT', setup.framePadding + (col-1)*(setup.frameWidth+setup.frameSpacing) + setup.frameWidth/2, 2)
        header:Hide()
        raid.groupHeaders[col] = header
    end

    local specialFrame = CreateFrame('Frame', 'DF_FocusFrame', raid)
    specialFrame:SetWidth(setup.frameWidth + (setup.framePadding * 2))
    specialFrame:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8X8',
        edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border',
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {left = 4, right = 4, top = 4, bottom = 4}
    })
    specialFrame:SetBackdropColor(0, 0, 0, 0.3)
    specialFrame:SetBackdropBorderColor(0.3, 0.3, 0.3, .6)
    specialFrame.frames = {}
    specialFrame.elapsed = 0
    specialFrame:Hide()
    if DF.profile.raid.showSpecialFrame then
        specialFrame:Show()
    end

    specialFrame.header = DF.ui.Font(specialFrame, 10, 'Focus', {1, .5, .5}, 'CENTER', 'OUTLINE')
    specialFrame.header:SetPoint('BOTTOM', specialFrame, 'TOP', 0, 5)
    if not DF.profile.raid.showGroupElements then
        specialFrame.header:Hide()
    end

    for i = 1, 5 do
        local f = CreateUnitFrame(specialFrame, nil, nil)
        f:SetPoint('TOPLEFT', specialFrame, 'TOPLEFT', setup.framePadding, -setup.framePadding - (i-1)*(setup.frameHeight + setup.frameSpacing))
        f:Hide()
        specialFrame.frames[i] = f
    end

    for i = 1, 5 do
        local f = specialFrame.frames[i]
        local c = DF.profile.raid.targetBorderColor
        f.targetBorderLeftTex = DF.ui.CreateSelectiveBorder(f.targetBorderLeft, {top=true, bottom=true, left=true}, 2, c[1], c[2], c[3], 1)
        f.targetBorderRightTex = DF.ui.CreateSelectiveBorder(f.targetBorderRight, {top=true, bottom=true, right=true}, 2, c[1], c[2], c[3], 1)
        local ac = DF.profile.raid.aggroBorderColor
        f.aggroBorderTex = DF.ui.CreateSelectiveBorder(f.aggroBorder, {top=true, bottom=true, left=true, right=true}, 2, ac[1], ac[2], ac[3], 1)
    end

    raid.groupHealthBars = {}
    for group = 1, 8 do
        local bar = CreateFrame('StatusBar', nil, raid)
        bar:SetSize(setup.frameWidth, 15)
        bar:SetStatusBarTexture(statusBarTextures[DF.profile.raid.statusBarTexture])
        bar:SetStatusBarColor(0, 1, 0)
        bar:Hide()

        local overlay = CreateFrame('Frame', nil, bar)
        overlay:SetAllPoints(bar)
        overlay:SetFrameLevel(bar:GetFrameLevel() + 1)
        bar.text = DF.ui.Font(overlay, 10, '', {1, 1, 1}, 'CENTER', 'OUTLINE')
        bar.text:SetPoint('CENTER', overlay, 'CENTER', 0, 0)

        raid.groupHealthBars[group] = bar
    end

    local controlFrame = CreateFrame('Frame', 'DF_RaidControlFrame', raid)
    controlFrame:SetSize(setup.frameWidth, 20)
    controlFrame:Hide()

    local configBtnSize = 20
    local toggleBtn = CreateFrame('Button', nil, controlFrame)
    toggleBtn:SetSize(configBtnSize, configBtnSize)
    toggleBtn:SetPoint('LEFT', controlFrame, 'LEFT', 0, 0)
    -- toggleBtn:SetNormalTexture(media['tex:bags:configbtn.blp']) -- renable in phase 2
    -- remove in phase 2 TODO
    local toggleNormal = toggleBtn:CreateTexture(nil, 'ARTWORK')
    toggleNormal:SetAllPoints(toggleBtn)
    toggleNormal:SetTexture(media['tex:bags:configbtn.blp'])
    toggleNormal:SetDesaturated(true)
    toggleBtn:SetNormalTexture(toggleNormal)
    -- end remove
    local toggleHighlight = toggleBtn:CreateTexture(nil, 'HIGHLIGHT')
    toggleHighlight:SetAllPoints(toggleBtn)
    toggleHighlight:SetTexture(media['tex:bags:configbtn.blp'])
    toggleHighlight:SetBlendMode('ADD')

    local toggleFrame = CreateFrame('Frame', nil, UIParent)
    toggleFrame:SetSize(400, 400)
    toggleFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    toggleFrame:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8X8'})
    toggleFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
    toggleFrame:Hide()

    toggleBtn:SetScript('OnClick', function()
        if true then return end
        if toggleFrame:IsShown() then
            toggleFrame:Hide()
        else
            toggleFrame:Show()
        end
    end)

    local specialBtn = CreateFrame('Button', nil, controlFrame)
    specialBtn:SetSize(configBtnSize, configBtnSize)
    specialBtn:SetPoint('LEFT', toggleBtn, 'RIGHT', -3, 0)
    specialBtn:SetNormalTexture(media['tex:bags:focusbtn.blp'])
    local specialHighlight = specialBtn:CreateTexture(nil, 'HIGHLIGHT')
    specialHighlight:SetAllPoints(specialBtn)
    specialHighlight:SetTexture(media['tex:bags:focusbtn.blp'])
    specialHighlight:SetBlendMode('ADD')

    local headerBtn = CreateFrame('Button', nil, controlFrame)
    headerBtn:SetSize(configBtnSize, configBtnSize)
    headerBtn:SetPoint('LEFT', specialBtn, 'RIGHT', -3, 0)
    headerBtn:SetNormalTexture(media['tex:bags:groupelementsbtn.blp'])
    local headerHighlight = headerBtn:CreateTexture(nil, 'HIGHLIGHT')
    headerHighlight:SetAllPoints(headerBtn)
    headerHighlight:SetTexture(media['tex:bags:groupelementsbtn.blp'])
    headerHighlight:SetBlendMode('ADD')

    local testBtn = CreateFrame('Button', nil, controlFrame)
    testBtn:SetSize(configBtnSize, configBtnSize)
    testBtn:SetPoint('LEFT', headerBtn, 'RIGHT', -3, 0)
    testBtn:SetNormalTexture(media['tex:bags:debugbtn.blp'])
    local testHighlight = testBtn:CreateTexture(nil, 'HIGHLIGHT')
    testHighlight:SetAllPoints(testBtn)
    testHighlight:SetTexture(media['tex:bags:debugbtn.blp'])
    testHighlight:SetBlendMode('ADD')

    local buttons = {
        {btn = toggleBtn, title = 'Interact Editor', desc = 'Opens the interact editor for configuring click actions on raid frames'},
        {btn = specialBtn, title = 'Focus Frame', desc = 'Toggles the focus frame showing the 5 lowest HP raid members (requires active raid)'},
        {btn = headerBtn, title = 'Group Elements', desc = 'Toggles group headers and group total HP bars'},
        {btn = testBtn, title = 'Test Mode', desc = 'Toggles test mode (or /df raid)'}
    }

    for _, data in buttons do
        local btn = data.btn
        local title = data.title
        local desc = data.desc
        btn:SetScript('OnEnter', function()
            GameTooltip:SetOwner(btn, 'ANCHOR_RIGHT')
            GameTooltip:SetText(title)
            GameTooltip:AddLine(desc, 1, 1, 1, 1)
            if btn == toggleBtn then
                GameTooltip:AddLine('Currently disabled - Coming in Phase 2', 1, 0, 0, 1)
            end
            GameTooltip:Show()
        end)
        btn:SetScript('OnLeave', function()
            GameTooltip:Hide()
        end)
    end

    headerBtn:SetScript('OnClick', function()
        DF.profile.raid.showGroupElements = not DF.profile.raid.showGroupElements
        if DF.profile.raid.showGroupElements then
            for col = 1, 8 do
                if raid.frames[(col-1)*5 + 1]:IsShown() then
                    raid.groupHeaders[col]:Show()
                    raid.groupHealthBars[col]:Show()
                end
            end
            specialFrame.header:Show()
        else
            for col = 1, 8 do
                raid.groupHeaders[col]:Hide()
                raid.groupHealthBars[col]:Hide()
            end
            specialFrame.header:Hide()
        end
    end)

    specialFrame:SetScript('OnUpdate', function()
        if testMode then return end
        this.elapsed = this.elapsed + arg1
        if this.elapsed < setup.specialUpdateRate then return end
        this.elapsed = 0

        local units = {}
        for i = 1, 40 do
            if raid.frames[i]:IsShown() and UnitExists(raid.frames[i].unit) then
                local hp = UnitHealth(raid.frames[i].unit)
                local maxhp = UnitHealthMax(raid.frames[i].unit)
                if maxhp > 0 then
                    table.insert(units, {index = i, hp = hp, maxhp = maxhp, percent = hp/maxhp})
                end
            end
        end

        table.sort(units, function(a, b) return a.percent < b.percent end)

        local visibleCount = 0
        for i = 1, 5 do
            local f = this.frames[i]
            if units[i] then
                local raidFrame = raid.frames[units[i].index]
                f.unit = raidFrame.unit
                f.hp:SetMinMaxValues(0, units[i].maxhp)
                f.hp:SetValue(units[i].hp)
                f.mana:SetMinMaxValues(0, UnitManaMax(f.unit))
                f.mana:SetValue(UnitMana(f.unit))
                local powerType = UnitPowerType(f.unit)
                local color = DF.tables.powercolors[powerType] or {0, 0, 1}
                f.mana:SetStatusBarColor(color[1], color[2], color[3])
                f.name:SetText(UnitName(f.unit) or '')
                setup:SetHPText(f.hpText, units[i].hp, units[i].maxhp, DF.profile.raid.hpTextFormat)
                local r, g, b = setup:GetHPColor(f.unit, units[i].hp, units[i].maxhp)
                f.hp:SetStatusBarColor(r, g, b)
                setup:UpdateRaidIcon(f)
                f:Show()
                visibleCount = visibleCount + 1
            else
                f.unit = nil
                f:Hide()
            end
        end

        if visibleCount > 0 then
            setup:UpdateSpecialFrameSize()
        end
    end)

    specialBtn:SetScript('OnClick', function()
        DF.profile.raid.showSpecialFrame = not DF.profile.raid.showSpecialFrame
        if DF.profile.raid.showSpecialFrame then
            specialFrame:SetWidth(setup.frameWidth + (setup.framePadding * 2))
            specialFrame:ClearAllPoints()
            specialFrame:SetPoint('TOPLEFT', raid, 'TOPRIGHT', setup.frameSpacing, 0)
            specialFrame:Show()
        else
            specialFrame:Hide()
        end
    end)

    alphaUpdater:SetScript('OnUpdate', function()
        this.elapsed = (this.elapsed or 0) + arg1
        if this.elapsed < 0.01 then return end
        this.elapsed = 0

        for i = 1, 40 do
            local f = raid.frames[i]
            if f and f.alphaAnim then
                local anim = f.alphaAnim
                anim.elapsed = anim.elapsed + arg1
                if anim.elapsed >= anim.duration then
                    f:SetAlpha(anim.target)
                    f.alphaAnim = nil
                else
                    local progress = anim.elapsed / anim.duration
                    local current = anim.start + (anim.target - anim.start) * progress
                    f:SetAlpha(current)
                end
            end
        end

        for i = 1, 5 do
            local f = specialFrame.frames[i]
            if f and f.alphaAnim then
                local anim = f.alphaAnim
                anim.elapsed = anim.elapsed + arg1
                if anim.elapsed >= anim.duration then
                    f:SetAlpha(anim.target)
                    f.alphaAnim = nil
                else
                    local progress = anim.elapsed / anim.duration
                    local current = anim.start + (anim.target - anim.start) * progress
                    f:SetAlpha(current)
                end
            end
        end

        local hasAnim = false
        for i = 1, 40 do
            if raid.frames[i] and raid.frames[i].alphaAnim then
                hasAnim = true
                break
            end
        end
        if not hasAnim then
            for i = 1, 5 do
                if specialFrame.frames[i] and specialFrame.frames[i].alphaAnim then
                    hasAnim = true
                    break
                end
            end
        end
        if not hasAnim then
            this:Hide()
        end
    end)

    -- methods
    function setup:AbbreviateNumber(num)
        if num >= 1000000 then
            return string.format('%.1fm', num / 1000000)
        elseif num >= 1000 then
            return string.format('%.1fk', num / 1000)
        else
            return tostring(num)
        end
    end

    function setup:SetHPText(hpText, hp, maxhp, format)
        local style = DF.profile.raid.hpTextStyle
        local text = ''
        if format == 'current' then
            text = style == 'abbreviated' and self:AbbreviateNumber(hp) or hp
        elseif format == 'cur/max' then
            if style == 'abbreviated' then
                text = self:AbbreviateNumber(hp)..'/'..self:AbbreviateNumber(maxhp)
            else
                text = hp..'/'..maxhp
            end
        elseif format == 'missing' then
            local missing = hp - maxhp
            if missing == 0 then
                text = ''
            else
                text = style == 'abbreviated' and self:AbbreviateNumber(missing) or missing
            end
        end
        hpText:SetText(text)
        local r, g, b = self:GetHPTextColor(hp, maxhp)
        hpText:SetTextColor(r, g, b)
    end

    function setup:GetHPColor(unit, hp, maxhp)
        local p = DF.profile.raid
        if p.hpBarUseFullColor and hp == maxhp then
            return p.hpBarFullColor[1], p.hpBarFullColor[2], p.hpBarFullColor[3]
        end
        if p.hpBarColorMode == 'class' then
            local class
            if type(unit) == 'string' and string.find(unit, 'raid') then
                -- debugprint('raid unit: '..unit)
                local _, c = UnitClass(unit)
                class = c
                -- debugprint('class from UnitClass: '..tostring(class))
            elseif type(unit) == 'string' then
                -- debugprint('string class: '..unit)
                class = unit
            end
            if class and DF.tables.classcolors[class] then
                local color = DF.tables.classcolors[class]
                return color[1], color[2], color[3]
            end
            return 1, 1, 1
        elseif p.hpBarColorMode == 'static' then
            return p.hpBarStaticColor[1], p.hpBarStaticColor[2], p.hpBarStaticColor[3]
        elseif p.hpBarColorMode == 'gradient' then
            local perc = hp / maxhp
            return DF.math.colorGradient(perc, p.gradientLow[1], p.gradientLow[2], p.gradientLow[3], p.gradientMid[1], p.gradientMid[2], p.gradientMid[3], p.gradientHigh[1], p.gradientHigh[2], p.gradientHigh[3])
        end
    end

    function setup:GetTotalHPColor(hp, maxhp)
        local p = DF.profile.raid
        if p.totalHpBarColorMode == 'static' then
            return p.totalHpBarStaticColor[1], p.totalHpBarStaticColor[2], p.totalHpBarStaticColor[3]
        elseif p.totalHpBarColorMode == 'gradient' then
            local perc = hp / maxhp
            return DF.math.colorGradient(perc, p.gradientLow[1], p.gradientLow[2], p.gradientLow[3], p.gradientMid[1], p.gradientMid[2], p.gradientMid[3], p.gradientHigh[1], p.gradientHigh[2], p.gradientHigh[3])
        end
    end

    function setup:GetHPTextColor(hp, maxhp)
        local p = DF.profile.raid
        if p.hpTextColorMode == 'gradient' then
            local perc = hp / maxhp
            return DF.math.colorGradient(perc, p.gradientLow[1], p.gradientLow[2], p.gradientLow[3], p.gradientMid[1], p.gradientMid[2], p.gradientMid[3], p.gradientHigh[1], p.gradientHigh[2], p.gradientHigh[3])
        end
        return 1, 1, 1
    end

    function setup:UpdateTargetBorders()
        if not DF.profile.raid.showTargetBorder then return end
        local targetUnit = UnitName('target')
        for i = 1, 40 do
            local f = raid.frames[i]
            if f:IsShown() and UnitExists(f.unit) and UnitName(f.unit) == targetUnit then
                f.targetBorderLeft:Show()
                f.targetBorderRight:Show()
            else
                f.targetBorderLeft:Hide()
                f.targetBorderRight:Hide()
            end
        end
        for i = 1, 5 do
            local f = specialFrame.frames[i]
            if f:IsShown() and f.unit and UnitExists(f.unit) and UnitName(f.unit) == targetUnit then
                f.targetBorderLeft:Show()
                f.targetBorderRight:Show()
            else
                f.targetBorderLeft:Hide()
                f.targetBorderRight:Hide()
            end
        end
    end

    function setup:UpdateAggroBorders()
        if not DF.profile.raid.showAggroBorder then return end
        for i = 1, 40 do
            local f = raid.frames[i]
            if f:IsShown() and UnitExists(f.unit) then
                local unitTarget = f.unit..'target'
                if UnitExists(unitTarget) and UnitCanAttack('player', unitTarget) and UnitIsUnit(unitTarget..'target', f.unit) then
                    f.aggroBorder:Show()
                else
                    f.aggroBorder:Hide()
                end
            else
                f.aggroBorder:Hide()
            end
        end
        for i = 1, 5 do
            local f = specialFrame.frames[i]
            if f:IsShown() and f.unit and UnitExists(f.unit) then
                local unitTarget = f.unit..'target'
                if UnitExists(unitTarget) and UnitCanAttack('player', unitTarget) and UnitIsUnit(unitTarget..'target', f.unit) then
                    f.aggroBorder:Show()
                else
                    f.aggroBorder:Hide()
                end
            else
                f.aggroBorder:Hide()
            end
        end
    end

    function setup:UpdateTargetBorderPositions()
        for i = 1, 40 do
            local f = raid.frames[i]
            local offset = self.frameWidth / 3
            f.targetBorderLeft:ClearAllPoints()
            f.targetBorderLeft:SetPoint('TOPLEFT', f, 'TOPLEFT', -2, 2)
            f.targetBorderLeft:SetPoint('BOTTOMRIGHT', f, 'BOTTOM', -offset, -2)
            f.targetBorderRight:ClearAllPoints()
            f.targetBorderRight:SetPoint('TOPLEFT', f, 'TOP', offset, 2)
            f.targetBorderRight:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 2, -2)
        end
        for i = 1, 5 do
            local f = specialFrame.frames[i]
            local offset = self.frameWidth / 3
            f.targetBorderLeft:ClearAllPoints()
            f.targetBorderLeft:SetPoint('TOPLEFT', f, 'TOPLEFT', -2, 2)
            f.targetBorderLeft:SetPoint('BOTTOMRIGHT', f, 'BOTTOM', -offset, -2)
            f.targetBorderRight:ClearAllPoints()
            f.targetBorderRight:SetPoint('TOPLEFT', f, 'TOP', offset, 2)
            f.targetBorderRight:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', 2, -2)
        end
    end

    function setup:UpdateTargetBorderColors()
        local c = DF.profile.raid.targetBorderColor
        for i = 1, 40 do
            local f = raid.frames[i]
            if f.targetBorderLeftTex then
                for _, tex in f.targetBorderLeftTex do
                    tex:SetVertexColor(c[1], c[2], c[3], 1)
                end
            end
            if f.targetBorderRightTex then
                for _, tex in f.targetBorderRightTex do
                    tex:SetVertexColor(c[1], c[2], c[3], 1)
                end
            end
        end
        for i = 1, 5 do
            local f = specialFrame.frames[i]
            if f.targetBorderLeftTex then
                for _, tex in f.targetBorderLeftTex do
                    tex:SetVertexColor(c[1], c[2], c[3], 1)
                end
            end
            if f.targetBorderRightTex then
                for _, tex in f.targetBorderRightTex do
                    tex:SetVertexColor(c[1], c[2], c[3], 1)
                end
            end
        end
    end

    function setup:SmoothAlpha(frame, targetAlpha, mode)
        if mode == 'off' then
            frame:SetAlpha(1)
            return
        end

        if mode == 'instant' then
            frame:SetAlpha(targetAlpha)
            return
        end

        -- gradient mode
        if not frame.alphaAnim then
            frame.alphaAnim = {target = targetAlpha, start = frame:GetAlpha(), elapsed = 0, duration = 0.2}
        else
            frame.alphaAnim.target = targetAlpha
            frame.alphaAnim.start = frame:GetAlpha()
            frame.alphaAnim.elapsed = 0
        end
    end

    function setup:UpdateRaidIcon(f)
        local index = GetRaidTargetIndex(f.unit)
        if index and index > 0 then
            local left = math.mod(index - 1, 4) * 0.25
            local right = left + 0.25
            local top = math.floor((index - 1) / 4) * 0.25
            local bottom = top + 0.25
            f.raidIcon:SetTexCoord(left, right, top, bottom)
            f.raidIcon:Show()
        else
            f.raidIcon:Hide()
        end
    end

    function setup:PositionRaidIcons()
        for i = 1, 40 do
            local f = raid.frames[i]
            f.raidIcon:ClearAllPoints()
            if self.raidIconPosition == 'top' then
                f.raidIcon:SetPoint('TOP', f, 'TOP', 0, 0)
            elseif self.raidIconPosition == 'left' then
                f.raidIcon:SetPoint('LEFT', f, 'LEFT', 0, 0)
            elseif self.raidIconPosition == 'right' then
                f.raidIcon:SetPoint('RIGHT', f, 'RIGHT', 0, 0)
            elseif self.raidIconPosition == 'bottom' then
                f.raidIcon:SetPoint('BOTTOM', f, 'BOTTOM', 0, 0)
            end
        end
        for i = 1, 5 do
            local f = specialFrame.frames[i]
            f.raidIcon:ClearAllPoints()
            if self.raidIconPosition == 'top' then
                f.raidIcon:SetPoint('TOP', f, 'TOP', 0, 0)
            elseif self.raidIconPosition == 'left' then
                f.raidIcon:SetPoint('LEFT', f, 'LEFT', 0, 0)
            elseif self.raidIconPosition == 'right' then
                f.raidIcon:SetPoint('RIGHT', f, 'RIGHT', 0, 0)
            elseif self.raidIconPosition == 'bottom' then
                f.raidIcon:SetPoint('BOTTOM', f, 'BOTTOM', 0, 0)
            end
        end
    end

    function setup:UpdateSpecialFrameSize()
        local visibleCount = 0
        for i = 1, 5 do
            if specialFrame.frames[i]:IsShown() then
                visibleCount = visibleCount + 1
            end
        end
        if visibleCount > 0 then
            local width = self.frameWidth + (self.framePadding * 2)
            local height = visibleCount * self.frameHeight + (visibleCount - 1) * self.frameSpacing + (self.framePadding * 2)
            specialFrame:SetSize(width, height)
        end
    end

    function setup:RepositionFrames()
        local groupCounts = {}
        local firstFrameInGroup = {}
        for i = 1, 40 do
            local f = raid.frames[i]
            if UnitExists(f.unit) then
                local _, _, group = GetRaidRosterInfo(i)
                if group then
                    groupCounts[group] = (groupCounts[group] or 0) + 1
                    if not firstFrameInGroup[group] then
                        firstFrameInGroup[group] = f
                    end
                end
            end
        end

        local groupToCol = {}
        local col = 0
        for group = 1, 8 do
            if groupCounts[group] then
                col = col + 1
                groupToCol[group] = col
            end
        end

        for i = 1, 40 do
            local f = raid.frames[i]
            if UnitExists(f.unit) then
                local _, _, group = GetRaidRosterInfo(i)
                if group and groupToCol[group] then
                    local groupIndex = 1
                    for j = 1, i - 1 do
                        local _, _, g = GetRaidRosterInfo(j)
                        if g == group then
                            groupIndex = groupIndex + 1
                        end
                    end
                    f:ClearAllPoints()
                    f:SetPoint('TOPLEFT', raid, 'TOPLEFT', setup.framePadding + (groupToCol[group]-1)*(setup.frameWidth+setup.frameSpacing), -setup.framePadding - (groupIndex-1)*(setup.frameHeight+setup.frameSpacing))
                end
            end
        end

        for group = 1, 8 do
            if firstFrameInGroup[group] then
                raid.groupHealthBars[group]:ClearAllPoints()
                raid.groupHealthBars[group]:SetPoint('BOTTOM', firstFrameInGroup[group], 'TOP', 0, DF.profile.raid.totalHpBarSpacing)
                raid.groupHeaders[group]:ClearAllPoints()
                raid.groupHeaders[group]:SetPoint('BOTTOM', raid.groupHealthBars[group], 'TOP', 0, groupHeaderSpacing)
            end
        end
    end

    function setup:RefreshUnit(f)
        if UnitExists(f.unit) then
            local hp = UnitHealth(f.unit)
            local maxhp = UnitHealthMax(f.unit)
            f.hp:SetMinMaxValues(0, maxhp)
            f.hp:SetValue(hp)
            f.mana:SetMinMaxValues(0, UnitManaMax(f.unit))
            f.mana:SetValue(UnitMana(f.unit))
            local powerType = UnitPowerType(f.unit)
            local color = DF.tables.powercolors[powerType] or {0, 0, 1}
            f.mana:SetStatusBarColor(color[1], color[2], color[3])
            f.name:SetText(UnitName(f.unit) or '')
            setup:SetHPText(f.hpText, hp, maxhp, DF.profile.raid.hpTextFormat)
            local r, g, b = self:GetHPColor(f.unit, hp, maxhp)
            f.hp:SetStatusBarColor(r, g, b)
            f:Show()
            self:UpdateGroupHealth()
            self:UpdateRaidIcon(f)
        else
            f:Hide()
        end
    end

    function setup:UpdateGroupHealth()
        for group = 1, 8 do
            local totalHP = 0
            local totalMaxHP = 0
            for i = 1, 40 do
                if raid.frames[i]:IsShown() then
                    local _, _, g = GetRaidRosterInfo(i)
                    if g == group then
                        totalHP = totalHP + UnitHealth(raid.frames[i].unit)
                        totalMaxHP = totalMaxHP + UnitHealthMax(raid.frames[i].unit)
                    end
                end
            end
            if totalMaxHP > 0 then
                raid.groupHealthBars[group]:SetMinMaxValues(0, totalMaxHP)
                raid.groupHealthBars[group]:SetValue(totalHP)
                local percent = math.floor((totalHP / totalMaxHP) * 100)
                raid.groupHealthBars[group].text:SetText(percent..'%')
                local r, g, b = self:GetTotalHPColor(totalHP, totalMaxHP)
                raid.groupHealthBars[group]:SetStatusBarColor(r, g, b)
            end
        end
    end

    function setup:UpdateRange()
        if DF.profile.raid.rangeFading == 'off' then return end

        for i = 1, 40 do
            local f = raid.frames[i]
            if f:IsShown() and UnitExists(f.unit) then
                local distance = UnitXP('distanceBetween', 'player', f.unit)
                if not distance or distance > DF.profile.raid.range then
                    self:SmoothAlpha(f, DF.profile.raid.minAlpha, DF.profile.raid.rangeFading)
                else
                    self:SmoothAlpha(f, 1, DF.profile.raid.rangeFading)
                end
            end
        end

        for i = 1, 5 do
            local f = specialFrame.frames[i]
            if f:IsShown() and f.unit and UnitExists(f.unit) then
                local distance = UnitXP('distanceBetween', 'player', f.unit)
                if not distance or distance > DF.profile.raid.range then
                    self:SmoothAlpha(f, DF.profile.raid.minAlpha, DF.profile.raid.rangeFading)
                else
                    self:SmoothAlpha(f, 1, DF.profile.raid.rangeFading)
                end
            end
        end

        if DF.profile.raid.rangeFading == 'gradient' then
            alphaUpdater:Show()
        end
    end

    function setup:UpdateControlFrame()
        -- if not DF.profile.raid.showControlFrame then return end
        controlFrame:ClearAllPoints()
        controlFrame:SetPoint('TOPLEFT', raid, 'BOTTOMLEFT', 3, -0)
        -- controlFrame:Show()
    end

    function setup:UpdateSpecialFrame()
        if not DF.profile.raid.showSpecialFrame then return end
        specialFrame:ClearAllPoints()
        specialFrame:SetPoint('TOPLEFT', raid, 'TOPRIGHT', setup.frameSpacing, 0)
    end

    function setup:UpdateRaidSize()
        local groupCounts = {}
        for i = 1, 40 do
            if raid.frames[i]:IsShown() then
                local _, _, group = GetRaidRosterInfo(i)
                if group then
                    groupCounts[group] = (groupCounts[group] or 0) + 1
                end
            end
        end
        local visibleGroups = 0
        local maxRow = 0
        for group, count in groupCounts do
            visibleGroups = visibleGroups + 1
            if count > maxRow then maxRow = count end
        end
        for col = 1, 8 do
            if groupCounts[col] then
                if DF.profile.raid.showGroupHeaders and DF.profile.raid.showGroupElements then
                    raid.groupHeaders[col]:Show()
                    raid.groupHealthBars[col]:Show()
                end
            else
                raid.groupHeaders[col]:Hide()
                raid.groupHealthBars[col]:Hide()
            end
        end
        if visibleGroups > 0 and maxRow > 0 then
            local raidWidth = visibleGroups * (self.frameWidth + self.frameSpacing) - self.frameSpacing + (self.framePadding * 2)
            local raidHeight = maxRow * (self.frameHeight + self.frameSpacing) - self.frameSpacing + (self.framePadding * 2)
            raid:SetSize(raidWidth, raidHeight)
            self:UpdateControlFrame()
            self:UpdateSpecialFrame()
        end
    end

    -- events
    for _, event in setup.events.raid do
        raid:RegisterEvent(event)
    end
    raid:RegisterEvent('PLAYER_TARGET_CHANGED')
    raid:SetScript('OnEvent', function()
        if event == 'PLAYER_TARGET_CHANGED' then
            setup:UpdateTargetBorders()
        elseif event == 'RAID_TARGET_UPDATE' then
            for i = 1, 40 do
                if UnitExists(raid.frames[i].unit) then
                    setup:UpdateRaidIcon(raid.frames[i])
                end
            end
        elseif UnitInRaid('player') then
            setup:RepositionFrames()
            for i = 1, 40 do
                setup:RefreshUnit(raid.frames[i])
            end
            raid:Show()
            setup:UpdateRaidSize()
        else
            raid:Hide()
        end
        setup:UpdateAggroBorders()
    end)

    raid:SetScript('OnUpdate', function()
        this.elapsed = (this.elapsed or 0) + arg1
        if this.elapsed < 0.1 then return end
        this.elapsed = 0
        setup:UpdateRange()
    end)

    DF.timers.every(0.1, function()
        setup:UpdateAggroBorders()
    end)

    setup:PositionRaidIcons()
    setup:UpdateTargetBorderPositions()

    -- test mode
    local testMode = false
    local testData = {}

    function DF.setups.ToggleRaidTestMode()
        testMode = not testMode
        if testMode then
            raid:UnregisterAllEvents()
            raid:Show()
            for i = 1, 40 do
                local f = raid.frames[i]
                f:UnregisterAllEvents()
                f:SetAlpha(1)
                f.alphaAnim = nil
                testData[i] = {hp = 2000, mana = 2000}
                testData[i].class = testClasses[math.mod(i - 1, 9) + 1]
                local col = math.ceil(i / 5)
                local row = math.mod(i - 1, 5) + 1
                f:ClearAllPoints()
                f:SetPoint('TOPLEFT', raid, 'TOPLEFT', setup.framePadding + (col-1)*(setup.frameWidth+setup.frameSpacing), -setup.framePadding - (row-1)*(setup.frameHeight+setup.frameSpacing))
                f.name:SetText('Player'..i)
                setup:SetHPText(f.hpText, 2000, 2000, DF.profile.raid.hpTextFormat)
                f.hp:SetMinMaxValues(0, 2000)
                f.hp:SetValue(2000)
                f.mana:SetMinMaxValues(0, 2000)
                f.mana:SetValue(2000)
                f:Show()
            end
            for col = 1, 8 do
                local firstFrame = raid.frames[(col-1)*5 + 1]
                if DF.profile.raid.showGroupElements then
                    raid.groupHeaders[col]:Show()
                    raid.groupHealthBars[col]:Show()
                end
                raid.groupHealthBars[col]:ClearAllPoints()
                raid.groupHealthBars[col]:SetPoint('BOTTOM', firstFrame, 'TOP', 0, DF.profile.raid.totalHpBarSpacing)
                raid.groupHeaders[col]:ClearAllPoints()
                raid.groupHeaders[col]:SetPoint('BOTTOM', raid.groupHealthBars[col], 'TOP', 0, groupHeaderSpacing)
                raid.groupHealthBars[col]:SetMinMaxValues(0, 10000)
                raid.groupHealthBars[col]:SetValue(10000)
                raid.groupHealthBars[col].text:SetText('100%')
            end
            alphaUpdater:Hide()
            local raidWidth = 8 * (setup.frameWidth + setup.frameSpacing) - setup.frameSpacing + (setup.framePadding * 2)
            local raidHeight = 5 * (setup.frameHeight + setup.frameSpacing) - setup.frameSpacing + (setup.framePadding * 2)
            raid:SetSize(raidWidth, raidHeight)
            setup:UpdateControlFrame()
            setup:UpdateSpecialFrame()
            raid.frames[1].raidIcon:SetTexCoord(0, 0.25, 0, 0.25)
            raid.frames[1].raidIcon:Show()
            raid:SetScript('OnUpdate', function()
                for i = 1, 40 do
                    local d = testData[i]
                    d.hp = d.hp - 10
                    d.mana = d.mana - 10
                    if d.hp < 0 then d.hp = 2000 end
                    if d.mana < 0 then d.mana = 2000 end
                    raid.frames[i].hp:SetValue(d.hp)
                    setup:SetHPText(raid.frames[i].hpText, math.floor(d.hp), 2000, DF.profile.raid.hpTextFormat)
                    local r, g, b = setup:GetHPColor(d.class, d.hp, 2000)
                    raid.frames[i].hp:SetStatusBarColor(r, g, b)
                    raid.frames[i].mana:SetValue(d.mana)
                end
                for group = 1, 8 do
                    local totalHP = 0
                    for i = (group-1)*5 + 1, group*5 do
                        totalHP = totalHP + testData[i].hp
                    end
                    raid.groupHealthBars[group]:SetValue(totalHP)
                    local percent = math.floor((totalHP / 10000) * 100)
                    raid.groupHealthBars[group].text:SetText(percent..'%')
                    local r, g, b = setup:GetTotalHPColor(totalHP, 10000)
                    raid.groupHealthBars[group]:SetStatusBarColor(r, g, b)
                end
            end)
        else
            raid.frames[1].raidIcon:Hide()
            for i = 1, 40 do
                local f = raid.frames[i]
                f:SetAlpha(1)
                f.alphaAnim = nil
                f.targetBorderLeft:Hide()
                f.targetBorderRight:Hide()
            end
            for i = 1, 5 do
                specialFrame.frames[i].targetBorderLeft:Hide()
                specialFrame.frames[i].targetBorderRight:Hide()
            end
            raid:SetScript('OnUpdate', function()
                setup:UpdateRange()
            end)
            for _, event in setup.events.raid do
                raid:RegisterEvent(event)
            end
            raid:RegisterEvent('PLAYER_TARGET_CHANGED')
            for i = 1, 40 do
                local f = raid.frames[i]
                for _, event in setup.events.frame do
                    f:RegisterEvent(event)
                end
                setup:RefreshUnit(f)
            end
            setup:RepositionFrames()
            setup:UpdateRaidSize()
            if specialFrame:IsShown() then
                for i = 1, 5 do
                    specialFrame.frames[i]:Hide()
                end
            end
            if UnitInRaid('player') then
                raid:Show()
            else
                raid:Hide()
            end
        end
    end
    testBtn:SetScript('OnClick', DF.setups.ToggleRaidTestMode)

    -- callbacks
    local callbacks = {}
    local callbackHelper = {
        TestModeLayout = function()
            for i = 1, 40 do
                local col = math.ceil(i / 5)
                local row = math.mod(i - 1, 5) + 1
                raid.frames[i]:ClearAllPoints()
                raid.frames[i]:SetPoint('TOPLEFT', raid, 'TOPLEFT', setup.framePadding + (col-1)*(setup.frameWidth+setup.frameSpacing), -setup.framePadding - (row-1)*(setup.frameHeight+setup.frameSpacing))
            end
            for col = 1, 8 do
                local firstFrame = raid.frames[(col-1)*5 + 1]
                raid.groupHealthBars[col]:ClearAllPoints()
                raid.groupHealthBars[col]:SetPoint('BOTTOM', firstFrame, 'TOP', 0, DF.profile.raid.totalHpBarSpacing)
            end
            local raidWidth = 8 * (setup.frameWidth + setup.frameSpacing) - setup.frameSpacing + (setup.framePadding * 2)
            local raidHeight = 5 * (setup.frameHeight + setup.frameSpacing) - setup.frameSpacing + (setup.framePadding * 2)
            raid:SetSize(raidWidth, raidHeight)
            setup:UpdateControlFrame()
            setup:UpdateSpecialFrame()
        end,
        UpdateAllColors = function()
            if testMode then
                for i = 1, 40 do
                    local d = testData[i]
                    local r, g, b = setup:GetHPColor(d.class, d.hp, 100)
                    raid.frames[i].hp:SetStatusBarColor(r, g, b)
                end
            else
                for i = 1, 40 do
                    setup:RefreshUnit(raid.frames[i])
                end
            end
        end
    }

    callbacks.frameSpacing = function(value)
        setup.frameSpacing = value
        for i = 1, 5 do
            specialFrame.frames[i]:ClearAllPoints()
            specialFrame.frames[i]:SetPoint('TOPLEFT', specialFrame, 'TOPLEFT', setup.framePadding, -setup.framePadding - (i-1)*(setup.frameHeight + setup.frameSpacing))
        end
        setup:UpdateSpecialFrameSize()
        if testMode then
            callbackHelper.TestModeLayout()
        else
            setup:RepositionFrames()
            setup:UpdateRaidSize()
        end
    end

    callbacks.framePadding = function(value)
        setup.framePadding = value
        specialFrame:SetWidth(setup.frameWidth + (setup.framePadding * 2))
        for i = 1, 5 do
            specialFrame.frames[i]:ClearAllPoints()
            specialFrame.frames[i]:SetPoint('TOPLEFT', specialFrame, 'TOPLEFT', setup.framePadding, -setup.framePadding - (i-1)*(setup.frameHeight + setup.frameSpacing))
        end
        setup:UpdateSpecialFrameSize()
        if testMode then
            callbackHelper.TestModeLayout()
        else
            setup:RepositionFrames()
            setup:UpdateRaidSize()
        end
    end

    callbacks.frameWidth = function(value)
        setup.frameWidth = value
        for i = 1, 40 do
            raid.frames[i]:SetWidth(value)
        end
        for i = 1, 5 do
            specialFrame.frames[i]:SetWidth(value)
        end
        for group = 1, 8 do
            raid.groupHealthBars[group]:SetWidth(value)
        end
        setup:UpdateSpecialFrameSize()
        setup:UpdateTargetBorderPositions()
        if testMode then
            callbackHelper.TestModeLayout()
        else
            setup:RepositionFrames()
            setup:UpdateRaidSize()
        end
    end

    callbacks.frameHeight = function(value)
        setup.frameHeight = value
        for i = 1, 40 do
            raid.frames[i]:SetHeight(value)
        end
        for i = 1, 5 do
            specialFrame.frames[i]:SetHeight(value)
            specialFrame.frames[i]:ClearAllPoints()
            specialFrame.frames[i]:SetPoint('TOPLEFT', specialFrame, 'TOPLEFT', setup.framePadding, -setup.framePadding - (i-1)*(setup.frameHeight + setup.frameSpacing))
        end
        setup:UpdateSpecialFrameSize()
        if testMode then
            callbackHelper.TestModeLayout()
        else
            setup:RepositionFrames()
            setup:UpdateRaidSize()
        end
    end

    callbacks.raidIconPosition = function(value)
        setup.raidIconPosition = value
        setup:PositionRaidIcons()
        if testMode then
            raid.frames[1].raidIcon:SetTexCoord(0, 0.25, 0, 0.25)
            raid.frames[1].raidIcon:Show()
        end
    end

    callbacks.specialUpdateRate = function(value)
        setup.specialUpdateRate = value
    end

    callbacks.minAlpha = function(value)
    end

    callbacks.hpTextFormat = function(value)
        if testMode then
            for i = 1, 40 do
                local d = testData[i]
                setup:SetHPText(raid.frames[i].hpText, math.floor(d.hp), 2000, value)
            end
        else
            for i = 1, 40 do
                setup:RefreshUnit(raid.frames[i])
            end
        end
    end

    callbacks.hpTextStyle = function(value)
        if testMode then
            for i = 1, 40 do
                local d = testData[i]
                setup:SetHPText(raid.frames[i].hpText, math.floor(d.hp), 2000, DF.profile.raid.hpTextFormat)
            end
        else
            for i = 1, 40 do
                setup:RefreshUnit(raid.frames[i])
            end
        end
    end

    callbacks.showNames = function(value)
        for i = 1, 40 do
            if value then raid.frames[i].name:Show() else raid.frames[i].name:Hide() end
        end
        for i = 1, 5 do
            if value then specialFrame.frames[i].name:Show() else specialFrame.frames[i].name:Hide() end
        end
    end

    callbacks.showGroupHeaders = function(value)
        if not DF.profile.raid.showGroupElements then return end
        for col = 1, 8 do
            if value and raid.frames[(col-1)*5 + 1]:IsShown() then
                raid.groupHeaders[col]:Show()
            else
                raid.groupHeaders[col]:Hide()
            end
        end
    end

    callbacks.showManaBar = function(value)
        local manaHeight = value and DF.profile.raid.manaBarHeight or 0
        for i = 1, 40 do
            if value then raid.frames[i].mana:Show() else raid.frames[i].mana:Hide() end
            raid.frames[i].hp:ClearAllPoints()
            raid.frames[i].hp:SetPoint('TOPLEFT', raid.frames[i], 'TOPLEFT', 0, 0)
            raid.frames[i].hp:SetPoint('BOTTOMRIGHT', raid.frames[i], 'BOTTOMRIGHT', 0, manaHeight)
        end
        for i = 1, 5 do
            if value then specialFrame.frames[i].mana:Show() else specialFrame.frames[i].mana:Hide() end
            specialFrame.frames[i].hp:ClearAllPoints()
            specialFrame.frames[i].hp:SetPoint('TOPLEFT', specialFrame.frames[i], 'TOPLEFT', 0, 0)
            specialFrame.frames[i].hp:SetPoint('BOTTOMRIGHT', specialFrame.frames[i], 'BOTTOMRIGHT', 0, manaHeight)
        end
    end

    callbacks.manaBarHeight = function(value)
        local manaHeight = DF.profile.raid.showManaBar and value or 0
        for i = 1, 40 do
            raid.frames[i].mana:SetHeight(value)
            raid.frames[i].hp:ClearAllPoints()
            raid.frames[i].hp:SetPoint('TOPLEFT', raid.frames[i], 'TOPLEFT', 0, 0)
            raid.frames[i].hp:SetPoint('BOTTOMRIGHT', raid.frames[i], 'BOTTOMRIGHT', 0, manaHeight)
        end
        for i = 1, 5 do
            specialFrame.frames[i].mana:SetHeight(value)
            specialFrame.frames[i].hp:ClearAllPoints()
            specialFrame.frames[i].hp:SetPoint('TOPLEFT', specialFrame.frames[i], 'TOPLEFT', 0, 0)
            specialFrame.frames[i].hp:SetPoint('BOTTOMRIGHT', specialFrame.frames[i], 'BOTTOMRIGHT', 0, manaHeight)
        end
    end

    callbacks.font = function(value)
        local fontPath = media[value]
        local hpSize = DF.profile.raid.hpTextSize
        local nameSize = DF.profile.raid.nameTextSize
        local headerSize = DF.profile.raid.headerTextSize
        local totalHpSize = DF.profile.raid.totalHpTextSize
        for i = 1, 40 do
            raid.frames[i].name:SetFont(fontPath, nameSize, 'OUTLINE')
            raid.frames[i].hpText:SetFont(fontPath, hpSize, 'OUTLINE')
        end
        for i = 1, 5 do
            specialFrame.frames[i].name:SetFont(fontPath, nameSize, 'OUTLINE')
            specialFrame.frames[i].hpText:SetFont(fontPath, hpSize, 'OUTLINE')
        end
        for col = 1, 8 do
            raid.groupHeaders[col]:SetFont(fontPath, headerSize, 'OUTLINE')
            raid.groupHealthBars[col].text:SetFont(fontPath, totalHpSize, 'OUTLINE')
        end
        specialFrame.header:SetFont(fontPath, headerSize, 'OUTLINE')
    end

    callbacks.hpTextSize = function(value)
        for i = 1, 40 do
            local font = raid.frames[i].hpText:GetFont()
            raid.frames[i].hpText:SetFont(font, value, 'OUTLINE')
        end
        for i = 1, 5 do
            local font = specialFrame.frames[i].hpText:GetFont()
            specialFrame.frames[i].hpText:SetFont(font, value, 'OUTLINE')
        end
    end

    callbacks.nameTextSize = function(value)
        for i = 1, 40 do
            local font = raid.frames[i].name:GetFont()
            raid.frames[i].name:SetFont(font, value, 'OUTLINE')
        end
        for i = 1, 5 do
            local font = specialFrame.frames[i].name:GetFont()
            specialFrame.frames[i].name:SetFont(font, value, 'OUTLINE')
        end
    end

    callbacks.headerTextSize = function(value)
        for col = 1, 8 do
            local font = raid.groupHeaders[col]:GetFont()
            raid.groupHeaders[col]:SetFont(font, value, 'OUTLINE')
        end
        local font = specialFrame.header:GetFont()
        specialFrame.header:SetFont(font, value, 'OUTLINE')
    end

    callbacks.totalHpTextSize = function(value)
        for col = 1, 8 do
            local font = raid.groupHealthBars[col].text:GetFont()
            raid.groupHealthBars[col].text:SetFont(font, value, 'OUTLINE')
        end
    end

    callbacks.showTargetBorder = function(value)
        if value then
            setup:UpdateTargetBorders()
        else
            for i = 1, 40 do
                raid.frames[i].targetBorderLeft:Hide()
                raid.frames[i].targetBorderRight:Hide()
            end
            for i = 1, 5 do
                specialFrame.frames[i].targetBorderLeft:Hide()
                specialFrame.frames[i].targetBorderRight:Hide()
            end
        end
    end

    callbacks.targetBorderColor = function(value)
        setup:UpdateTargetBorderColors()
    end

    callbacks.showAggroBorder = function(value)
        if not value then
            for i = 1, 40 do
                raid.frames[i].aggroBorder:Hide()
            end
            for i = 1, 5 do
                specialFrame.frames[i].aggroBorder:Hide()
            end
        else
            setup:UpdateAggroBorders()
        end
    end

    callbacks.aggroBorderColor = function(value)
        for i = 1, 40 do
            local f = raid.frames[i]
            if f.aggroBorderTex then
                for _, tex in f.aggroBorderTex do
                    tex:SetVertexColor(value[1], value[2], value[3], 1)
                end
            end
        end
        for i = 1, 5 do
            local f = specialFrame.frames[i]
            if f.aggroBorderTex then
                for _, tex in f.aggroBorderTex do
                    tex:SetVertexColor(value[1], value[2], value[3], 1)
                end
            end
        end
    end

    callbacks.containerBgColor = function(value)
        raid:SetBackdropColor(value[1], value[2], value[3], DF.profile.raid.containerBgAlpha)
        specialFrame:SetBackdropColor(value[1], value[2], value[3], DF.profile.raid.containerBgAlpha)
        controlFrame:SetBackdropColor(value[1], value[2], value[3], 1)
    end

    callbacks.containerBgAlpha = function(value)
        local c = DF.profile.raid.containerBgColor
        raid:SetBackdropColor(c[1], c[2], c[3], value)
        specialFrame:SetBackdropColor(c[1], c[2], c[3], value)
    end

    callbacks.unitBgColor = function(value)
        for i = 1, 40 do
            raid.frames[i].bg:SetVertexColor(value[1], value[2], value[3], DF.profile.raid.unitBgAlpha)
        end
        for i = 1, 5 do
            specialFrame.frames[i].bg:SetVertexColor(value[1], value[2], value[3], DF.profile.raid.unitBgAlpha)
        end
    end

    callbacks.unitBgAlpha = function(value)
        local c = DF.profile.raid.unitBgColor
        for i = 1, 40 do
            raid.frames[i].bg:SetVertexColor(c[1], c[2], c[3], value)
        end
        for i = 1, 5 do
            specialFrame.frames[i].bg:SetVertexColor(c[1], c[2], c[3], value)
        end
    end

    callbacks.statusBarTexture = function(value)
        local tex = statusBarTextures[value]
        for i = 1, 40 do
            raid.frames[i].hp:SetStatusBarTexture(tex)
            raid.frames[i].mana:SetStatusBarTexture(tex)
        end
        for i = 1, 5 do
            specialFrame.frames[i].hp:SetStatusBarTexture(tex)
            specialFrame.frames[i].mana:SetStatusBarTexture(tex)
        end
        for group = 1, 8 do
            raid.groupHealthBars[group]:SetStatusBarTexture(tex)
        end
    end

    callbacks.showControlFrame = function(value)
        if value then
            controlFrame:Show()
        else
            controlFrame:Hide()
        end
    end

    callbacks.gradientLow = function(value) callbackHelper.UpdateAllColors() setup:UpdateGroupHealth() end
    callbacks.gradientMid = function(value) callbackHelper.UpdateAllColors() setup:UpdateGroupHealth() end
    callbacks.gradientHigh = function(value) callbackHelper.UpdateAllColors() setup:UpdateGroupHealth() end
    callbacks.hpTextColorMode = function(value)
        if testMode then
            for i = 1, 40 do
                local d = testData[i]
                setup:SetHPText(raid.frames[i].hpText, math.floor(d.hp), 2000, DF.profile.raid.hpTextFormat)
            end
        else
            for i = 1, 40 do
                setup:RefreshUnit(raid.frames[i])
            end
        end
    end
    callbacks.hpBarColorMode = function(value) callbackHelper.UpdateAllColors() end
    callbacks.hpBarStaticColor = function(value) callbackHelper.UpdateAllColors() end
    callbacks.hpBarUseFullColor = function(value) callbackHelper.UpdateAllColors() end
    callbacks.hpBarFullColor = function(value) callbackHelper.UpdateAllColors() end
    callbacks.totalHpBarColorMode = function(value) setup:UpdateGroupHealth() end
    callbacks.totalHpBarStaticColor = function(value) setup:UpdateGroupHealth() end
    callbacks.totalHpBarSpacing = function(value)
        if testMode then
            for col = 1, 8 do
                local firstFrame = raid.frames[(col-1)*5 + 1]
                raid.groupHealthBars[col]:ClearAllPoints()
                raid.groupHealthBars[col]:SetPoint('BOTTOM', firstFrame, 'TOP', 0, value)
            end
        else
            setup:RepositionFrames()
        end
    end
    callbacks.range = function(value) end
    callbacks.rangeFading = function(value) end

    DF:NewCallbacks('raid', callbacks)
end)
