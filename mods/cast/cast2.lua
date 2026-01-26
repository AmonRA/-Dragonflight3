DRAGONFLIGHT()
if not dependency('SuperWoW') then return end

DF:NewDefaults('castbar-testversion', {
    enabled = {value = false},
    version = {value = '1.0'},
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
        local currentSpellId = nil

        function castBar:StartCast(spellName, castTime, isChannel)
            spell = spellName
            duration = castTime / 1000
            start = GetTime()
            channel = isChannel
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
            castBar:Show()
        end

        function castBar:OnEvent()
            if event == 'PLAYER_TARGET_CHANGED' and unit == 'target' then
                start = nil
                castBar:Hide()
                if UnitExists('target') then
                    if UnitCastingInfo(unit) then
                        local spellName, _, _, _, startTime, endTime = UnitCastingInfo(unit)
                        castBar:SetCastInfo(spellName, startTime, endTime, false)
                    elseif UnitChannelInfo(unit) then
                        local spellName, _, _, _, startTime, endTime = UnitChannelInfo(unit)
                        castBar:SetCastInfo(spellName, startTime, endTime, true)
                    end
                end
            elseif event == 'UNIT_CASTEVENT' then
                local casterGUID = arg1
                local _, unitGUID = UnitExists(unit)
                if casterGUID == unitGUID then
                    local castType, spellid, castTime = arg3, arg4, arg5
                    local spellName = SpellInfo(spellid) or "Unknown"

                    -- debugprint("[" .. unit .. "] CASTEVENT: " .. castType .. " | SpellID: " .. spellid .. " | Spell: " .. spellName .. " | CurrentID: " .. (currentSpellId or "nil"))

                    if castType == 'START' or castType == 'CHANNEL' then
                        start = nil  -- clear before starting new cast
                    end
                    if castType == 'START' then
                        currentSpellId = spellid
                        -- debugprint("[" .. unit .. "] STARTING cast - Set currentSpellId to: " .. spellid)
                        castBar:StartCast(spellName, castTime, false)
                    elseif castType == 'CHANNEL' then
                        currentSpellId = spellid
                        -- debugprint("[" .. unit .. "] STARTING channel - Set currentSpellId to: " .. spellid)
                        castBar:StartCast(spellName, castTime, true)
                    elseif castType == 'CAST' or castType == 'FAIL' then
                        if spellid == currentSpellId then
                            -- debugprint("[" .. unit .. "] HIDING castbar - SpellID matches currentSpellId: " .. spellid)
                            start = nil
                            currentSpellId = nil
                            castBar:Hide()
                        else
                            -- debugprint("[" .. unit .. "] IGNORING " .. castType .. " - SpellID " .. spellid .. " != currentSpellId " .. (currentSpellId or "nil"))
                        end
                    end
                end
            end
        end

        function castBar:OnUpdate()
            if start then
                local elapsed = GetTime() - start
                local remain = duration - elapsed
                if remain > 0 then
                    local value = channel and remain or elapsed
                    local pct = value / duration
                    castBar.barFill:SetWidth(width * pct)
                    castBar.barFill:SetTexCoord(0, pct, 0, 1)
                    castBar.text:SetText(spell)
                    castBar.timeText:SetText(strformat('%.1f', channel and -remain or elapsed))
                    local sparkPos = width * pct
                    castBar.spark:SetPoint('CENTER', castBar, 'LEFT', sparkPos, 0)
                    castBar.spark:Show()
                else
                    castBar:Hide()
                    castBar.spark:Hide()
                end
            end
        end

        castBar:SetScript('OnEvent', castBar.OnEvent)
        castBar:SetScript('OnUpdate', castBar.OnUpdate)
        castBar:RegisterEvent('UNIT_CASTEVENT')
        if unit == 'target' then castBar:RegisterEvent('PLAYER_TARGET_CHANGED') end

        return castBar
    end

    local playerCastBar = CreateCastBar('player', 'DF_CastBar_Player', 200, 16)
    playerCastBar:SetPoint('CENTER', 0, -150)

    local targetCastBar = CreateCastBar('target', 'DF_CastBar_Target', 160, 13)
    targetCastBar:SetPoint('TOP', getglobal('DF_TargetFrame'), 'BOTTOM', -0, -200)
end)
