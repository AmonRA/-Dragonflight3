DRAGONFLIGHT()

DF:NewDefaults('whatsnew', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('whatsnew', 1, function()
    local C = {
        O = '|cffff9933',  -- neon orange (slightly softened)
        Y = '|cffffee33',  -- neon yellow (not pure #FFFF00)
        G = '|cff33ff99',  -- neon green with a hint of cyan
        B = '|cff3399ff',  -- neon blue, not full electric
        P = '|cffff66cc',  -- neon pink/purple blend
    }

    local charKey = UnitName('player') .. '-' .. GetRealmName()
    DF_Profiles.meta.whatsnewShown = DF_Profiles.meta.whatsnewShown or {}

    if not DF_Profiles.meta.secondInstallShown or not DF_Profiles.meta.secondInstallShown[charKey] then return end
    if DF.data.compareVersions(info.version, DF_Profiles.meta.whatsnewShown[charKey]) <= 0 then return end

    local changelog = {
        features = {
            'Added timestamps to chat messages',
            'Added abbreviation to chat messages',
            'Added URL detection to chat messages',
            C.G .. 'Options under GUI > Chat > Chat|r',
            '',
            'Added tooltip default anchor to editmode',
        },
        bugfixes = {
            'Fixed some missing tooltips for UI elements like expand or close buttons etc.',
            'Some more minor clean ups and optimizations',
        },
    }

    local contentText = ''
    local lineCount = 0

    if table.getn(changelog.features) > 0 then
        contentText = contentText .. '|cff00ff00New Features:|r\n\n'
        lineCount = lineCount + 2
        for i = 1, table.getn(changelog.features) do
            if changelog.features[i] == '' then
                contentText = contentText .. '\n'
            else
                contentText = contentText .. '- ' .. changelog.features[i] .. '\n'
            end
            lineCount = lineCount + 1
        end
        contentText = contentText .. '\n'
        lineCount = lineCount + 1
    end

    if table.getn(changelog.bugfixes) > 0 then
        contentText = contentText .. '|cffff8000Bug Fixes:|r\n\n'
        lineCount = lineCount + 2
        for i = 1, table.getn(changelog.bugfixes) do
            if changelog.bugfixes[i] == '' then
                contentText = contentText .. '\n'
            else
                contentText = contentText .. '- ' .. changelog.bugfixes[i] .. '\n'
            end
            lineCount = lineCount + 1
        end
    end

    local frameHeight = 120 + (lineCount * 14)
    local frame = DF.ui.CreatePaperDollFrame('DF_WhatsNewPanel', UIParent, 500, frameHeight, 2)
    frame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    frame:SetFrameStrata('HIGH')
    frame:EnableMouse(true)

    local title = DF.ui.Font(frame, 12, "|cffffd100What's New in v: |cffffffff" .. info.version .. "|r", {1, 1, 1}, 'CENTER')
    title:SetPoint('TOP', frame, 'TOP', 0, -5)

    local closeBtn = DF.ui.CreateRedButton(frame, "close", function()
        DF_Profiles.meta.whatsnewShown[charKey] = info.version
        frame:Hide()
    end)
    closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -3)
    closeBtn:SetSize(19,19)

    local yPos = -55

    if table.getn(changelog.features) > 0 then
        local featHeader = DF.ui.Font(frame, 12, '|cff00ff00New Features:|r', {1, 1, 1}, 'LEFT')
        featHeader:SetPoint('TOPLEFT', frame, 'TOPLEFT', 50, yPos)

        local decorFeat = frame:CreateTexture(nil, 'ARTWORK')
        decorFeat:SetTexture(media['tex:bags:expand.tga'])
        decorFeat:SetSize(16, 16)
        decorFeat:SetPoint('RIGHT', featHeader, 'LEFT', -5, 0)
        decorFeat:SetTexCoord(1, 0, 0, 1)

        yPos = yPos - 28
        for i = 1, table.getn(changelog.features) do
            if changelog.features[i] ~= '' then
                local line = DF.ui.Font(frame, 11, '- ' .. changelog.features[i], {1, 1, 1}, 'LEFT')
                line:SetPoint('TOPLEFT', frame, 'TOPLEFT', 20, yPos)
            end
            yPos = yPos - 14
        end
        yPos = yPos - 14
    end

    if table.getn(changelog.bugfixes) > 0 then
        local bugHeader = DF.ui.Font(frame, 12, '|cffff8000Bug Fixes:|r', {1, 1, 1}, 'LEFT')
        bugHeader:SetPoint('TOPLEFT', frame, 'TOPLEFT', 50, yPos)

        local decorBug = frame:CreateTexture(nil, 'ARTWORK')
        decorBug:SetTexture(media['tex:bags:expand.tga'])
        decorBug:SetSize(16, 16)
        decorBug:SetPoint('RIGHT', bugHeader, 'LEFT', -5, 0)
        decorBug:SetTexCoord(1, 0, 0, 1)

        yPos = yPos - 28
        for i = 1, table.getn(changelog.bugfixes) do
            if changelog.bugfixes[i] ~= '' then
                local line = DF.ui.Font(frame, 11, '- ' .. changelog.bugfixes[i], {1, 1, 1}, 'LEFT')
                line:SetPoint('TOPLEFT', frame, 'TOPLEFT', 20, yPos)
            end
            yPos = yPos - 14
        end
    end

    local okBtn = DF.ui.Button(frame, 'OK', 100, 30)
    okBtn:SetPoint('BOTTOM', frame, 'BOTTOM', 0, 10)
    okBtn:SetScript('OnClick', function()
        DF_Profiles.meta.whatsnewShown[charKey] = info.version
        frame:Hide()
    end)
end)
