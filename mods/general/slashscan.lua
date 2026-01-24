DRAGONFLIGHT()
-- this file is a bitch... TODO
-- mt needs to set on our addon loaded, gui needs to wait since some addon do weird delayed slash registry, must change init.lua for that and check EVERY addon if it needs VARIABLES LOADED as replacement lol...
local debugstack = debugstack
local slashCommandRegistry = {}
local SlashCmdList = _G.SlashCmdList
local mt = {}
local oldNewIndex = nil
mt.__newindex = function(t, key, value)
    local stack = debugstack(2)
    local addonName = DF.lua.match(stack, "AddOns\\([^\\]+)\\") or "Unknown"

    local cmds = {}
    local i = 1
    while _G["SLASH_"..key..i] do
        table.insert(cmds, _G["SLASH_"..key..i])
        i = i + 1
    end

    slashCommandRegistry[key] = {
        addon = addonName,
        handler = value,
        commands = cmds,
        blocked = DF_GlobalData.slashScanner and DF_GlobalData.slashScanner[key] or false
    }

    if oldNewIndex then
        oldNewIndex(t, key, value)
    else
        rawset(t, key, value)
    end
end
setmetatable(SlashCmdList, mt)
slashCommandRegistry['DRAGONFLIGHT'] = {
    addon = 'Dragonflight 3',
    commands = {'/df', '/dragonflight', '/load', '/unload', '/gm'}
}

DF:NewDefaults('slashscan', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('slashscan', 1, 'PLAYER_LOGIN', function()
    if not DF_GlobalData.slashScanner then
        DF_GlobalData.slashScanner = {}
    end

    local mainframe = DF.ui.CreatePaperDollFrame('DF_SlashScan', UIParent, 400, 500, 2)
    mainframe:SetPoint('CENTER', UIParent, 'CENTER')
    mainframe:SetFrameStrata('HIGH')
    mainframe:SetMovable(true)
    mainframe:EnableMouse(true)
    mainframe:RegisterForDrag('LeftButton')
    mainframe:SetScript('OnDragStart', function() mainframe:StartMoving() end)
    mainframe:SetScript('OnDragStop', function() mainframe:StopMovingOrSizing() end)
    mainframe:Hide()

    tinsert(UISpecialFrames, 'DF_SlashScan')

    DF.setups.slashscan = mainframe

    local title = DF.ui.Font(mainframe, 12, 'Slash Commands', {1, 1, 1}, 'CENTER')
    title:SetPoint('TOP', mainframe, 'TOP', 0, -5)

    local closeBtn = DF.ui.CreateRedButton(mainframe, 'close', function()
        mainframe:Hide()
    end)
    closeBtn:SetPoint('TOPRIGHT', mainframe, 'TOPRIGHT', -3, -3)
    closeBtn:SetFrameLevel(mainframe:GetFrameLevel() + 1)

    local scroll = DF.ui.Scrollframe(mainframe, 360, 420, 'DF_SlashScan_Scroll')
    scroll:SetPoint('TOP', mainframe, 'TOP', 0, -60)

    local addonHeader = DF.ui.Font(mainframe, 10, 'Addons', {1, 1, 1}, 'LEFT')
    addonHeader:SetPoint('TOPLEFT', mainframe, 'TOPLEFT', 37, -35)

    local stateHeader = DF.ui.Font(mainframe, 10, 'State', {1, 1, 1}, 'LEFT')
    stateHeader:SetPoint('TOPLEFT', mainframe, 'TOPLEFT', 310, -35)

    for key, _ in pairs(slashCommandRegistry) do
        if DF_GlobalData.slashScanner[key] then
            rawset(SlashCmdList, key, nil)
        end
    end

    local function BuildSlashList()
        scroll.content:SetHeight(1)
        local yOffset = -10

        local sortedList = {}
        for key, info in pairs(slashCommandRegistry) do
            table.insert(sortedList, {key = key, info = info})
        end
        table.sort(sortedList, function(a, b)
            return string.lower(a.info.addon) < string.lower(b.info.addon)
        end)

        for _, entry in ipairs(sortedList) do
            local key = entry.key
            local info = entry.info

            local addonFont = DF.ui.Font(scroll.content, 14, info.addon, {1, 0.82, 0}, 'LEFT')
            addonFont:SetPoint('TOPLEFT', scroll.content, 'TOPLEFT', 10, yOffset)
            yOffset = yOffset - 20

            local cmdButtons = {}
            for _, cmd in ipairs(info.commands) do
                local cmdFont = DF.ui.Font(scroll.content, 12, cmd, {1, 1, 1}, 'LEFT')
                cmdFont:SetPoint('TOPLEFT', scroll.content, 'TOPLEFT', 30, yOffset)

                if info.addon ~= 'Dragonflight 3' then
                    local btn = DF.ui.Button(scroll.content, 'Block', 100, 20, nil, nil, nil, nil)
                    local currentKey = key
                    local currentInfo = info

                    btn:SetPoint('TOPRIGHT', scroll.content, 'TOPRIGHT', -10, yOffset + 2)

                    if currentInfo.blocked then
                        btn.text:SetText('Restore')
                        btn:SetBackdropBorderColor(0, 0.8, 0, 0.8)
                        cmdFont:SetTextColor(0.5, 0.5, 0.5)
                    else
                        btn.text:SetText('Block')
                        btn:SetBackdropBorderColor(0.8, 0, 0, 0.8)
                    end

                    table.insert(cmdButtons, {btn = btn, font = cmdFont})

                    btn:SetScript('OnClick', function()
                        if currentInfo.blocked then
                            rawset(SlashCmdList, currentKey, currentInfo.handler)
                            currentInfo.blocked = false
                            DF_GlobalData.slashScanner[currentKey] = nil
                        else
                            rawset(SlashCmdList, currentKey, nil)
                            currentInfo.blocked = true
                            DF_GlobalData.slashScanner[currentKey] = true
                        end

                        for _, pair in ipairs(cmdButtons) do
                            if currentInfo.blocked then
                                pair.btn.text:SetText('Restore')
                                pair.btn:SetBackdropBorderColor(0, 0.8, 0, 0.8)
                                pair.font:SetTextColor(0.5, 0.5, 0.5)
                            else
                                pair.btn.text:SetText('Block')
                                pair.btn:SetBackdropBorderColor(0.8, 0, 0, 0.8)
                                pair.font:SetTextColor(1, 1, 1)
                            end
                        end
                    end)
                end

                yOffset = yOffset - 18
            end

            yOffset = yOffset - 5
        end

        scroll.content:SetHeight(math.abs(yOffset))
        scroll.updateScrollBar()
    end

    BuildSlashList()
end)
