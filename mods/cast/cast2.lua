DRAGONFLIGHT()
if not dependency('SuperWoW') then return end

DF:NewDefaults('castbar-testversion', {
    enabled = {value = false},
    version = {value = '1.0'},
})

DF:NewModule('castbar-testversion', 2, 'PLAYER_LOGIN', function()
    DF.common.KillFrame(CastingBarFrame)

    local function CreateCastBar(unit, frameName, width, height)
        local castBar = CreateFrame('Frame', frameName, UIParent)
        castBar:SetSize(width, height)
        castBar:SetFrameStrata('LOW')
        castBar:Hide()

        local bg = castBar:CreateTexture(nil, 'BACKGROUND')
        bg:SetAllPoints()
        bg:SetTexture(media['tex:castbar:CastingBarBackground.blp'])

        local dropshadow = castBar:CreateTexture(nil, 'BACKGROUND')
        dropshadow:SetSize(width - 4, height + 9)
        dropshadow:SetPoint('TOP', castBar, 'BOTTOM', -1, 5)
        dropshadow:SetTexture(media['tex:castbar:CastingBarFrameDropShadow.blp'])
        dropshadow:SetAlpha(0.5)

        local barFill = castBar:CreateTexture(nil, 'ARTWORK')
        barFill:SetPoint('LEFT', castBar, 'LEFT', 0, 0)
        barFill:SetTexture(media['tex:castbar:CastingBarStandard3.tga'])
        barFill:SetVertexColor(1, 0.82, 0)
        barFill:SetSize(0, height)

        local text = castBar:CreateFontString(nil, 'ARTWORK')
        text:SetPoint('LEFT', dropshadow, 'LEFT', 6, -1)
        text:SetFont('Fonts\\FRIZQT__.TTF', height * 0.75)
        text:SetShadowOffset(1, -1)
        text:SetShadowColor(0, 0, 0)

        local timeText = castBar:CreateFontString(nil, 'ARTWORK')
        timeText:SetPoint('RIGHT', dropshadow, 'RIGHT', -6, -1)
        timeText:SetFont('Fonts\\FRIZQT__.TTF', height * 0.75)
        timeText:SetShadowOffset(1, -1)
        timeText:SetShadowColor(0, 0, 0)

        local spark = castBar:CreateTexture(nil, 'OVERLAY')
        spark:SetSize(32, height + 11)
        spark:SetTexture('Interface\\CastingBar\\UI-CastingBar-Spark')
        spark:SetBlendMode('ADD')
        spark:Hide()

        local border = castBar:CreateTexture(nil, 'OVERLAY')
        border:SetAllPoints()
        border:SetTexture(media['tex:castbar:CastingBarFrame.blp'])

        local start, duration, spell, channel

        function castBar:OnUpdate()
            if start then
                local elapsed = GetTime() - start
                local remain = duration - elapsed
                if remain > 0 then
                    local value = channel and remain or elapsed
                    local pct = value / duration
                    barFill:SetWidth(width * pct)
                    barFill:SetTexCoord(0, pct, 0, 1)
                    text:SetText(spell)
                    timeText:SetText(string.format('%.1f', channel and -remain or elapsed))
                    local sparkPos = width * pct
                    spark:SetPoint('CENTER', castBar, 'LEFT', sparkPos, 0)
                    spark:Show()
                else
                    castBar:Hide()
                    spark:Hide()
                end
            end
        end

        function castBar:StartCast(spellName, castTime, isChannel)
            spell = spellName
            duration = castTime / 1000
            start = GetTime()
            channel = isChannel
            local pct = channel and 1 or 0
            barFill:SetWidth(width * pct)
            barFill:SetTexCoord(0, pct, 0, 1)
            castBar:Show()
        end

        function castBar:CheckCasting()
            if UnitCastingInfo(unit) then
                local spellName, _, _, _, startTime, endTime = UnitCastingInfo(unit)
                local now = GetTime() * 1000
                local totalDuration = (endTime - startTime) / 1000
                local elapsed = (now - startTime) / 1000
                spell = spellName
                duration = totalDuration
                start = GetTime() - elapsed
                channel = false
                castBar:Show()
            elseif UnitChannelInfo(unit) then
                local spellName, _, _, _, startTime, endTime = UnitChannelInfo(unit)
                local now = GetTime() * 1000
                local totalDuration = (endTime - startTime) / 1000
                local elapsed = (now - startTime) / 1000
                spell = spellName
                duration = totalDuration
                start = GetTime() - elapsed
                channel = true
                castBar:Show()
            end
        end

        function castBar:OnEvent()
            if event == 'PLAYER_TARGET_CHANGED' and unit == 'target' then
                start = nil  -- always clear, not just when no target
                castBar:Hide()
                if UnitExists('target') then
                    castBar:CheckCasting()
                end
            elseif event == 'UNIT_CASTEVENT' then
                local casterGUID = arg1
                local _, unitGUID = UnitExists(unit)
                if casterGUID == unitGUID then
                    local castType, spellid, castTime = arg3, arg4, arg5
                    if castType == 'START' or castType == 'CHANNEL' then
                        start = nil  -- clear before starting new cast
                    end
                    if castType == 'START' then
                        local spellName = SpellInfo(spellid)
                        castBar:StartCast(spellName, castTime, false)
                    elseif castType == 'CHANNEL' then
                        local spellName = SpellInfo(spellid)
                        castBar:StartCast(spellName, castTime, true)
                    elseif castType == 'CAST' or castType == 'FAIL' then
                        start = nil
                        castBar:Hide()
                    end
                end
            end
        end

        castBar:SetScript('OnEvent', castBar.OnEvent)
        castBar:SetScript('OnUpdate', castBar.OnUpdate)
        castBar:RegisterEvent('UNIT_CASTEVENT')
        if unit == 'target' then
            castBar:RegisterEvent('PLAYER_TARGET_CHANGED')
        end

        return castBar
    end

    local playerCastBar = CreateCastBar('player', 'DF_CastBar_Player', 200, 16)
    playerCastBar:SetPoint('CENTER', 0, -150)

    local targetCastBar = CreateCastBar('target', 'DF_CastBar_Target', 160, 13)
    targetCastBar:SetPoint('TOP', getglobal('DF_TargetFrame'), 'BOTTOM', -0, -200)
end)
