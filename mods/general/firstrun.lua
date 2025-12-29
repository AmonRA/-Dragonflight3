UNLOCKDRAGONFLIGHT()

DF:NewDefaults('firstrun', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('firstrun', 1, function()
    local charName = UnitName('player')
    local realmName = GetRealmName()
    local charKey = charName .. '-' .. realmName

    DF_Profiles.meta.installShown = DF_Profiles.meta.installShown or {}

    if not DF_Profiles.meta.installShown[charKey] then
        local installFrame = DF.ui.CreatePaperDollFrame('DF_InstallPanel', UIParent, 350, 250, 2)
        installFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)

        local title = DF.ui.Font(installFrame, 16, 'Welcome to '..info.addonNameColor, {1, 1, 1}, 'CENTER')
        title:SetPoint('TOP', installFrame, 'TOP', 0, -30)

        local warning = DF.ui.Font(installFrame, 12, 'This is an |cffff0000ALPHA build|r. Expect bugs.\n\nGuzruul.', {1, 1, 1}, 'CENTER')
        warning:SetPoint('CENTER', installFrame, 'CENTER', 0, 0)

        local function ApplyProfile(profileName)
            local profile = DF.tables.profiles[profileName]
            if profile then
                for option, value in pairs(profile) do
                    if option == 'framePositions' then
                        DF.profile['editmode']['framePositions'] = value
                        for name, pos in pairs(value) do
                            local frame = getglobal(name)
                            if frame then
                                frame:ClearAllPoints()
                                if pos.parent and pos.rx and pos.ry then
                                    local parent = getglobal(pos.parent)
                                    if parent then
                                        frame:SetPoint('CENTER', parent, 'CENTER', pos.rx, pos.ry)
                                    end
                                elseif pos.x and pos.y then
                                    frame:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', pos.x, pos.y)
                                end
                            end
                        end
                    else
                        for module, _ in pairs(DF.defaults) do
                            if DF.defaults[module][option] and DF.callbacks[module .. '.' .. option] then
                                DF:SetConfig(module, option, value)
                            end
                        end
                    end
                end
            end
        end

        -- local auroraBtn = DF.ui.Button(installFrame, 'DF_', 100, 30)
        -- auroraBtn:SetPoint('BOTTOM', installFrame, 'BOTTOM', -55, 60)
        -- auroraBtn:SetScript('OnClick', function()
        --     ApplyProfile('DF_')
        -- end)

        -- local dragonflightBtn = DF.ui.Button(installFrame, 'Dragonflight', 100, 30)
        -- dragonflightBtn:SetPoint('BOTTOM', installFrame, 'BOTTOM', 55, 60)
        -- dragonflightBtn:SetScript('OnClick', function()
        --     ApplyProfile('Dragonflight')
        -- end)

        local okBtn = DF.ui.Button(installFrame, 'OK', 100, 30)
        okBtn:SetPoint('BOTTOM', installFrame, 'BOTTOM', 0, 20)
        okBtn:SetScript('OnClick', function()
            DF_Profiles.meta.installShown[charKey] = true
            installFrame:Hide()
        end)
    end

    -- callbacks
    local callbacks = {}
    DF:NewCallbacks('firstrun', callbacks)
end)
