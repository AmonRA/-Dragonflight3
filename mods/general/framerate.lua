DRAGONFLIGHT()

DF:NewDefaults('framerate', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('framerate', 1, function()
    local fpsFrame = CreateFrame('Frame', "DF_FPS", UIParent)
    fpsFrame:SetSize(60, 30)
    fpsFrame:SetPoint('CENTER', UIParent, 'CENTER',0,-200)
    local fpsText = DF.ui.Font(fpsFrame, 12, 'FPS: 0', {1, 1, 1}, 'CENTER')
    fpsText:SetPoint("CENTER", fpsFrame)
    fpsFrame:Hide()

    fpsFrame:SetScript('OnUpdate', function()
        local now = GetTime()
        if fpsFrame.tick and fpsFrame.tick > now then return end
        fpsFrame.tick = now + 0.2
        fpsText:SetText('FPS: ' .. floor(GetFramerate()))
    end)

    function _G.ToggleFramerate()
        if fpsFrame:IsVisible() then
            fpsFrame:Hide()
        else
            fpsFrame:Show()
        end
    end
end)
