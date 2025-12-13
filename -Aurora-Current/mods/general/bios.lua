UNLOCKAURORA()

AU:NewDefaults('bios', {
    version = {value = '1.0'},
    enabled = {value = true},
    gui = {
        {indexRange = {1, 1}, tab = 'bios', subtab = 1},
    },

})

AU:NewModule('bios', 1, function()
    local frame = AU.ui.CreatePaperDollFrame('AU_BIOSFrame', UIParent, 500, 400, 'default')
    frame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    frame:Hide()
    frame:EnableMouse(true)

    local closeBtn = AU.ui.CreateRedButton(frame, "close", function() frame:Hide() end)
    closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -1)

    local header = AU.ui.Font(frame, 13, "BIOS", {1,1,1}, "CENTER")
    header:SetPoint("TOP", frame, "TOP", 0, -4)


    local sry = AU.ui.Font(frame, 13, "Feature not implemented yet.", {1,0,0}, "CENTER")
    sry:SetPoint("CENTER", frame, "CENTER", 0, -0)

    -- local safebootBtn = AU.ui.Button(frame, "Safeboot", 100, 30)
    -- safebootBtn:SetPoint("CENTER", frame, "CENTER", 0, 0)
    -- safebootBtn:SetScript("OnClick", function() BIOS:CreateSafeBootDialog() end)

    table.insert(UISpecialFrames, frame:GetName())

    -- callbacks
    local helpers = {}
    local callbacks = {}


    AU:NewCallbacks('bios', callbacks)
end)
