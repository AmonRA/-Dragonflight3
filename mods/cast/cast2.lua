DRAGONFLIGHT()
if not dependency('SuperWoW') then return end

DF:NewDefaults('castbar-testversion', {
    enabled = { value = false },
    version = { value = '1.0' },
})

DF:NewModule('castbar-testversion', 2, 'PLAYER_LOGIN', function()
    DF.common.KillFrame(CastingBarFrame)

    local GetTime = GetTime
    local strformat = string.format
    local UnitExists = UnitExists
    local UnitCastingInfo = UnitCastingInfo
    local UnitChannelInfo = UnitChannelInfo
    local SpellInfo = SpellInfo

    local function CreateCastBar(unit, frameName, width, height)
        local castBar = CreateFrame('Frame', frameName, UIParent)
        castBar:SetSize(width, height)
        castBar:SetFrameStrata('LOW')
        castBar:Hide()

        castBar.bg = castBar:CreateTexture(nil, 'BACKGROUND')
        castBar.bg:SetAllPoints()
        castBar.bg:SetTexture(media['tex:castbar:CastingBarBackground.blp'])

        castBar.dropshadow = castBar:CreateTexture(nil, 'BACKGROUND')
        castBar.dropshadow:SetSize(width - 4, height + 9)
        castBar.dropshadow:SetPoint('TOP', castBar, 'BOTTOM', -1, 5)
        castBar.dropshadow:SetTexture(media['tex:castbar:CastingBarFrameDropShadow.blp'])
        castBar.dropshadow:SetAlpha(0.5)

        castBar.barFill = castBar:CreateTexture(nil, 'ARTWORK')
        castBar.barFill:SetPoint('LEFT', castBar, 'LEFT', 0, 0)
        castBar.barFill:SetTexture(media['tex:castbar:CastingBarStandard3.tga'])
        castBar.barFill:SetVertexColor(1, 0.82, 0)
        castBar.barFill:SetSize(0, height)

        castBar.text = castBar:CreateFontString(nil, 'ARTWORK')
        castBar.text:SetPoint('LEFT', castBar.dropshadow, 'LEFT', 6, -1)
        castBar.text:SetFont('Fonts\\FRIZQT__.TTF', height * 0.75)
        castBar.text:SetShadowOffset(1, -1)
        castBar.text:SetShadowColor(0, 0, 0)

        castBar.timeText = castBar:CreateFontString(nil, 'ARTWORK')
        castBar.timeText:SetPoint('RIGHT', castBar.dropshadow, 'RIGHT', -6, -1)
        castBar.timeText:SetFont('Fonts\\FRIZQT__.TTF', height * 0.75)
        castBar.timeText:SetShadowOffset(1, -1)
        castBar.timeText:SetShadowColor(0, 0, 0)

        castBar.spark = castBar:CreateTexture(nil, 'OVERLAY')
        castBar.spark:SetSize(32, height + 11)
        castBar.spark:SetTexture('Interface\\CastingBar\\UI-CastingBar-Spark')
        castBar.spark:SetBlendMode('ADD')
        castBar.spark:Hide()

        castBar.border = castBar:CreateTexture(nil, 'OVERLAY')
        castBar.border:SetAllPoints()
        castBar.border:SetTexture(media['tex:castbar:CastingBarFrame.blp'])

        local start, duration, spell, channel
        local currentSpellId
        local castPushback = 0       -- ms, increases duration
        local channelPushback = 0    -- ms, reduces remaining time

        function castBar:StartCast(spellName, castTime, isChannel)
            spell = spellName
            duration = castTime / 1000
            start = GetTime()
            channel = isChannel
            castPushback = 0
            channelPushback = 0

            local pct = channel and 1 or 0
            castBar.barFill:SetWidth(width * pct)
            castBar.barFill:SetTexCoord(0, pct, 0, 1)
            castBar:Show()
        end

        function castBar:SetCastInfo(spellName, startTime, endTime, isChannel)
            local now = GetTime() * 1000
            local totalDuration = (endTime - startTime) / 1000
            local elapsed = (now - startTime) / 1000

            spell = spellName
            duration = totalDuration
            start = GetTime() - elapsed
            channel = isChannel
            castPushback = 0
            channelPushback = 0

            castBar:Show()
        end

        function castBar:OnEvent()
            if event == 'PLAYER_TARGET_CHANGED' and unit == 'target' then
                start = nil
                castBar:Hide()

                if UnitExists('target') then
                    if UnitCastingInfo(unit) then
                        local spellName, _, _, _, s, e = UnitCastingInfo(unit)
                        castBar:SetCastInfo(spellName, s, e, false)
                    elseif UnitChannelInfo(unit) then
                        local spellName, _, _, _, s, e = UnitChannelInfo(unit)
                        castBar:SetCastInfo(spellName, s, e, true)
                    end
                end

            elseif event == 'UNIT_CASTEVENT' then
                local casterGUID = arg1
                local _, unitGUID = UnitExists(unit)
                if casterGUID ~= unitGUID then return end

                local castType, spellid, castTime = arg3, arg4, arg5
                local spellName = SpellInfo(spellid) or "Unknown"

                if castType == 'START' then
                    currentSpellId = spellid
                    castBar:StartCast(spellName, castTime, false)

                elseif castType == 'CHANNEL' then
                    currentSpellId = spellid
                    castBar:StartCast(spellName, castTime, true)

                elseif castType == 'CAST' or castType == 'FAIL' then
                    if spellid == currentSpellId then
                        start = nil
                        currentSpellId = nil
                        castBar:Hide()
                    end
                end

            elseif event == 'SPELLCAST_DELAYED' and unit == 'player' then
                if not start then return end
                local disruption = tonumber(arg1) or 0
                if disruption <= 0 then return end

                if channel then
                    channelPushback = channelPushback + disruption
                else
                    castPushback = castPushback + disruption
                end
            end
        end

        function castBar:OnUpdate()
            if not start then return end

            local elapsed = GetTime() - start
            local effectiveDuration = duration + (castPushback / 1000)
            local remain = effectiveDuration - elapsed

            if channel then
                remain = remain - (channelPushback / 1000)
            end

            if remain <= 0 then
                castBar:Hide()
                castBar.spark:Hide()
                return
            end

            local value = channel and remain or elapsed
            local pct = value / effectiveDuration
            if pct < 0 then pct = 0 elseif pct > 1 then pct = 1 end

            castBar.barFill:SetWidth(width * pct)
            castBar.barFill:SetTexCoord(0, pct, 0, 1)
            castBar.text:SetText(spell)
            castBar.timeText:SetText(strformat('%.1f', channel and -remain or elapsed))

            castBar.spark:SetPoint('CENTER', castBar, 'LEFT', width * pct, 0)
            castBar.spark:Show()
        end

        castBar:SetScript('OnEvent', castBar.OnEvent)
        castBar:SetScript('OnUpdate', castBar.OnUpdate)
        castBar:RegisterEvent('UNIT_CASTEVENT')
        castBar:RegisterEvent('SPELLCAST_DELAYED')
        if unit == 'target' then
            castBar:RegisterEvent('PLAYER_TARGET_CHANGED')
        end

        return castBar
    end

    local playerCastBar = CreateCastBar('player', 'DF_CastBar_Player', 200, 16)
    playerCastBar:SetPoint('CENTER', 0, -150)

    local targetCastBar = CreateCastBar('target', 'DF_CastBar_Target', 160, 13)
    targetCastBar:SetPoint('TOP', getglobal('DF_TargetFrame'), 'BOTTOM', 0, -200)
end)
