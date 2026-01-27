DRAGONFLIGHT()

DF:NewDefaults('map', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('map', 1, 'PLAYER_ENTERING_WORLD',function()
    UIPanelWindows['WorldMapFrame'] = { area = 'center' }

    local regions = {WorldMapFrame:GetRegions()}
    for i = 1, table.getn(regions) do
        local region = regions[i]
        if region:GetObjectType() == 'Texture' then
            local texture = region:GetTexture()
            if texture and string.find(texture, 'UI%-WorldMap') then
                region:Hide()
            end
        elseif region:GetObjectType() == 'FontString' then
            local text = region:GetText()
            if text and text == WORLD_MAP then
                region:Hide()
            end
        end
    end

    WorldMapFrameCloseButton:Hide()

    local customBg = DF.ui.CreatePaperDollFrame('DF_MapCustomBg', WorldMapFrame, 1024, 768, 2)
    customBg:SetPoint('TOPLEFT', WorldMapFrame, 'TOPLEFT', 0, 0)
    customBg:SetPoint('BOTTOMRIGHT', WorldMapFrame, 'BOTTOMRIGHT', 0, 0)
    customBg:SetFrameLevel(WorldMapFrame:GetFrameLevel())
    customBg.Bg:SetDrawLayer('BACKGROUND', -1)

    local title = customBg:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
    title:SetPoint('TOP', customBg, 'TOP', 0, -6)
    title:SetText(WORLD_MAP)

    local closeButton = DF.ui.CreateRedButton(customBg, 'close', function() HideUIPanel(WorldMapFrame) end)
    closeButton:SetPoint('TOPRIGHT', customBg, 'TOPRIGHT', 0, -1)
    closeButton:SetSize(20, 20)
    closeButton:SetFrameLevel(customBg:GetFrameLevel() + 3)

    tinsert(UISpecialFrames, 'DF_MapCustomBg')

    WorldMapFrame:ClearAllPoints()
    WorldMapFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    WorldMapFrame:SetSize(WorldMapButton:GetWidth() + 15, WorldMapButton:GetHeight() + 100)

    DF.hooks.HookScript(WorldMapFrame, 'OnShow', function()
        WorldMapFrame:SetScale(DF.profile.UIParent.worldmapScale or 0.7)
        this:EnableKeyboard(false)
    end, true)

    WorldMapFrame:SetMovable(true)
    WorldMapFrame:EnableMouse(true)
    WorldMapFrame:RegisterForDrag('LeftButton')
    WorldMapFrame:SetScript('OnDragStart', function()
        WorldMapFrame:StartMoving()
    end)
    WorldMapFrame:SetScript('OnDragStop', function()
        WorldMapFrame:StopMovingOrSizing()
    end)

    BlackoutWorld:Hide()

    DF.mixins.HideMinimizeMaximizeButton()

    WorldMapZoneDropDown:ClearAllPoints()
    WorldMapZoneDropDown:SetPoint('LEFT', WorldMapContinentDropDown, 'RIGHT', 20, 0)

    local continentRegions = {WorldMapContinentDropDown:GetRegions()}
    for i = 1, table.getn(continentRegions) do
        local region = continentRegions[i]
        if region and region:GetObjectType() == 'FontString' then
            local text = region:GetText()
            if text and text == CONTINENT then
                region:ClearAllPoints()
                region:SetPoint('RIGHT', WorldMapContinentDropDown, 'LEFT', 0, 0)
                break
            end
        end
    end

    local zoneRegions = {WorldMapZoneDropDown:GetRegions()}
    for i = 1, table.getn(zoneRegions) do
        local region = zoneRegions[i]
        if region and region:GetObjectType() == 'FontString' then
            local text = region:GetText()
            if text and text == ZONE then
                region:ClearAllPoints()
                region:SetPoint('RIGHT', WorldMapZoneDropDown, 'LEFT', 0, 0)
                break
            end
        end
    end

    local coordsBg = DF.ui.Frame(WorldMapButton, 120, 20, DF.profile.UIParent.worldmapScale or 0.7)
    coordsBg:SetPoint('BOTTOM', WorldMapButton, 'BOTTOM', 0, 0)
    local coordsText = DF.ui.Font(coordsBg, 12, '', {1, 1, 1})
    coordsText:SetPoint('CENTER', coordsBg, 'CENTER', 0, 0)

    local coordsFrame = CreateFrame('Frame', nil, WorldMapButton)
    coordsFrame:SetScript('OnUpdate', function()
        if not DF.profile.map.showCoords then
            coordsBg:Hide()
            return
        end
        local width = WorldMapButton:GetWidth()
        local height = WorldMapButton:GetHeight()
        local mx, my = WorldMapButton:GetCenter()
        local scale = WorldMapButton:GetEffectiveScale()
        local x, y = GetCursorPosition()
        if mx and my then
            mx = ((x / scale) - (mx - width / 2)) / width * 100
            my = ((my + height / 2) - (y / scale)) / height * 100
        end
        if mx and my and MouseIsOver(WorldMapButton) then
            coordsBg:Show()
            coordsText:SetText(string.format('X: %.1f    Y: %.1f', mx, my))
        else
            coordsBg:Hide()
        end

    end)

    local checkbox = DF.ui.Checkbox(customBg, 'Coordinates', 20, 20, 'RIGHT')
    checkbox:SetPoint('BOTTOMLEFT', customBg, 'BOTTOMLEFT', 10, 10)
    checkbox:SetChecked(DF.profile.map.showCoords == 1)
    checkbox:SetScript('OnClick', function()
        DF.profile.map.showCoords = this:GetChecked() and 1 or nil
    end)

end)
