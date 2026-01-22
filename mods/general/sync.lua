DRAGONFLIGHT()

-- dependent on: -Dragonflight3-SYNC
-- sync gives dragonflight a custom hidden channel for communication, we can
-- send update notify, sent admin message to all or single users
-- and see usercount online on realm. we only want to cache names for troubleshooting
-- and future features maybe, otherwise not invade peoples privacy.

local syncFrame = CreateFrame('Frame')
local CHANNEL_NAME = 'DragonflightSync'
local updateShown = false
local isAdmin = UnitName('player') == a()
local major, minor, fix = DF.lua.match(info.version, '(%d+)%.(%d+)%.(%d+)')
local localversion = tonumber(major)*10000 + tonumber(minor)*100 + tonumber(fix)
local retryTimerId = nil
local isInChannel = false
local infoResponses = {}
local infoCountTimer = nil
local debugMode = false

-- filter messages right away, due to "Joined Channel" and other
-- messages coming in before SYNC_READY
if not (isAdmin and s()) then
    DF.hooks.Hook(DEFAULT_CHAT_FRAME, 'AddMessage', function(frame, msg, r, g, b, id)
        if msg and string.find(string.lower(msg), '%[%d+%. dragonflightsync%]') then
            return
        end
        local orig = DF.hooks.registry[DEFAULT_CHAT_FRAME]['AddMessage']
        orig(frame, msg, r, g, b, id)
    end)
end

function syncFrame:OnPlayerEnteringWorld()
    -- check stored version and notify on login if update available
    DF_GlobalData.highestVersion = DF_GlobalData.highestVersion or 0
    if DF_GlobalData.highestVersion > localversion then
        local maj = math.floor(DF_GlobalData.highestVersion / 10000)
        local min = math.floor((DF_GlobalData.highestVersion - maj*10000) / 100)
        local fixVer = DF_GlobalData.highestVersion - maj*10000 - min*100
        print('New version available: ' .. maj .. '.' .. min .. '.' .. fixVer)
        print('Download: ' .. info.github)
        updateShown = true
    end

    -- check if already in channel
    for i = 1, 10 do
        local _, name = GetChannelName(i)
        if name and string.find(name, CHANNEL_NAME) then
            isInChannel = true
            break
        end
    end

    -- join channel if not already in
    if not isInChannel then
        JoinChannelByName(CHANNEL_NAME, '', 1)
    end

    -- hide and proxy channel, block leaving
    if not (isAdmin and s()) then
        -- hide sync channel from dropdown menu
        DF.hooks.HookScript(DropDownList2, 'OnShow', function()
            for level = 1, 3 do
                for i = 1, 32 do
                    local btn = getglobal('DropDownList'..level..'Button'..i)
                    if btn and btn:IsShown() and btn:GetText() and string.find(string.lower(btn:GetText()), 'dragonflight') then
                        btn:Hide()
                        btn:EnableMouse(false)
                    end
                end
            end
        end, true)

        -- block /leave command for sync channel
        DF.hooks.Hook(_G.SlashCmdList, 'LEAVE', function(msg)
            local name = gsub(msg, '%s*([^%s]+).*', '%1')

            -- check if it's a number (channel shortcut)
            if tonumber(name) then
                local _, channelName = GetChannelName(tonumber(name))
                if channelName and string.find(string.lower(channelName), 'dragonflight') then
                    redprint('Blocked. System requires DragonflightSync.')
                    return
                end
            elseif string.find(string.lower(name), 'dragonflight') then
                redprint('Blocked. System requires DragonflightSync.')
                return
            end

            DF.hooks.registry[_G.SlashCmdList]['LEAVE'](msg)
        end)

        -- block LeaveChannelByName API for sync channel
        DF.hooks.Hook(_G, 'LeaveChannelByName', function(name)
            if name and string.find(string.lower(name), 'dragonflight') then
                redprint('Blocked. System requires DragonflightSync.')
                return
            end
            DF.hooks.registry[_G]['LeaveChannelByName'](name)
        end)

        -- redirect /1 /2 etc away from sync channel
        DF.hooks.Hook(_G, 'ChatEdit_ParseText', function(editBox, send)
            local text = editBox:GetText()
            if not text or string.len(text) == 0 or string.sub(text, 1, 1) ~= '/' then
                DF.hooks.registry[_G]['ChatEdit_ParseText'](editBox, send)
                return
            end

            local channel = gsub(text, '/([0-9]+).*', '%1')
            if string.len(channel) > 0 and channel >= '0' and channel <= '9' then
                local _, channelName = GetChannelName(channel)
                if channelName and string.find(string.lower(channelName), 'dragonflight') then
                    local found = false
                    -- find first non-sync channel
                    for i = 1, 10 do
                        local _, name = GetChannelName(i)
                        if name and not string.find(string.lower(name), 'dragonflight') then
                            editBox:SetText('/' .. i .. string.sub(text, string.len(channel) + 2))
                            found = true
                            break
                        end
                    end
                    -- fallback to /say if no other channels
                    if not found then
                        editBox:SetText('/s ' .. string.sub(text, string.len(channel) + 2))
                    end
                end
            end

            DF.hooks.registry[_G]['ChatEdit_ParseText'](editBox, send)
        end)
    end

    -- broadcast and send info
    self:BroadcastPresence()
    self:SendPlayerInfo()
end

function syncFrame:BroadcastPresence()
    for i = 1, 10 do
        local id, name = GetChannelName(i)
        if name and string.find(name, CHANNEL_NAME) then
            SendChatMessage('#V' .. localversion, 'CHANNEL', nil, id)
            break
        end
    end
    SendAddonMessage('Dragonflight', 'VERSION:' .. localversion, 'BATTLEGROUND')
    SendAddonMessage('Dragonflight', 'VERSION:' .. localversion, 'RAID')
    SendAddonMessage('Dragonflight', 'VERSION:' .. localversion, 'GUILD')
end

function syncFrame:SendPlayerInfo()
    if DF_GlobalData.infoSent then return end

    local playerName = UnitName('player')
    for i = 1, 10 do
        local id, name = GetChannelName(i)
        if name and string.find(name, CHANNEL_NAME) then
            SendChatMessage('#INFO' .. playerName, 'CHANNEL', nil, id)
            break
        end
    end

    if not retryTimerId then
        retryTimerId = DF.timers.every(3600, function()
            syncFrame:SendPlayerInfo()
        end)
    end
end

function syncFrame:OnChatMsgChannelDetected()
    if arg9 and string.find(arg9, CHANNEL_NAME) then
        -- version broadcast detection
        if string.find(arg1, '#V') then
            local version = DF.lua.match(arg1, '#V(.+)')
            self:CheckForUpdate(version)
        end
        -- admin help
        if arg1 == '#ADMIN' and isAdmin and s() then
            print('|cff00ff00Admin Commands:|r')
            print('|cffffcc00#ADMIN-INFO|r - Count online users')
            print('|cffffcc00#ADMIN-PUSHPRINT msg|r - Broadcast to all')
            print('|cffffcc00#ADMIN-PUSHPRINT-user msg|r - Send to specific user')
            print('|cffffcc00#ADMIN-DEBUG on/off|r - Toggle debug mode')
        end
        -- player info confirmation
        if string.find(arg1, '#CONFIRM') then
            local name = DF.lua.match(arg1, '#CONFIRM(.+)')
            if name == UnitName('player') and retryTimerId then
                DF_GlobalData.infoSent = true
                DF.timers.cancel(retryTimerId)
                retryTimerId = nil
            end
        end
        -- admin request for user list
        if string.find(arg1, '#ADMIN%-INFO') and arg2 == a() then
            if isAdmin and s() then
                infoResponses = {}
                if infoCountTimer then
                    DF.timers.cancel(infoCountTimer)
                end
                infoCountTimer = DF.timers.delay(5, function()
                    local count = 0
                    for _, _ in pairs(infoResponses) do
                        count = count + 1
                    end
                    print('|cff00ff00[Admin] ' .. count .. ' users responded|r')
                    infoCountTimer = nil
                end)
            else
                if debugMode then return end
                local playerName = UnitName('player')
                for i = 1, 10 do
                    local id, name = GetChannelName(i)
                    if name and string.find(name, CHANNEL_NAME) then
                        SendChatMessage('#REPLY' .. playerName .. ':' .. info.version, 'CHANNEL', nil, id)
                        break
                    end
                end
            end
        end
        -- collect info responses for admin
        if string.find(arg1, '#REPLY') and isAdmin and s() then
            local name = DF.lua.match(arg1, '#REPLY([^:]+)')
            if name then
                infoResponses[name] = true
            end
        end
        -- admin broadcast or targeted message
        if string.find(arg1, '#ADMIN%-PUSHPRINT') then
            if arg2 == a() then
                local targetUser, message = DF.lua.match(arg1, '#ADMIN%-PUSHPRINT%-([^%s]+)%s*(.+)')
                if targetUser and message then
                    if debugMode and not (isAdmin and s()) then return end
                    if string.lower(UnitName('player')) == string.lower(targetUser) or (isAdmin and s()) then
                        print('|cffff6600[Admin Message]|r: ' .. message)
                    end
                else
                    local msg = DF.lua.match(arg1, '#ADMIN%-PUSHPRINT(.+)')
                    if msg then
                        if debugMode and not (isAdmin and s()) then return end
                        print('|cffff6600[Admin Message]|r: ' .. msg)
                    end
                end
            end
        end
        -- admin toggle debug mode
        if string.find(arg1, '#ADMIN%-DEBUG') and arg2 == a() then
            local mode = DF.lua.match(arg1, '#ADMIN%-DEBUG%s*(.+)')
            if mode == 'on' then
                debugMode = true
                if isAdmin and s() then
                    print('|cffff0000[Admin] Debug mode ON|r')
                end
            elseif mode == 'off' then
                debugMode = false
                if isAdmin and s() then
                    print('|cff00ff00[Admin] Debug mode OFF|r')
                end
            end
        end
    end
end

function syncFrame:OnAddonMessage()
    if arg1 == info.addonName then
        local v, remoteversion = DF.lua.match(arg2, '(.+):(.+)')
        remoteversion = tonumber(remoteversion)
        if v == 'VERSION' and remoteversion then
            self:CheckForUpdate(remoteversion)
        end
    end
end

function syncFrame:CheckForUpdate(versionStr)
    local remoteversion = tonumber(versionStr)
    if remoteversion and remoteversion > localversion and not updateShown then
        DF_GlobalData.highestVersion = remoteversion
        local maj = math.floor(remoteversion / 10000)
        local min = math.floor((remoteversion - maj*10000) / 100)
        local fixVer = remoteversion - maj*10000 - min*100
        print('New version available: ' .. maj .. '.' .. min .. '.' .. fixVer)
        print('Download: ' .. info.github)
        updateShown = true
    end
end

function syncFrame:OnPartyMembersChanged()
    local groupsize = GetNumRaidMembers() > 0 and GetNumRaidMembers() or GetNumPartyMembers() > 0 and GetNumPartyMembers() or 0
    if ( self.group or 0 ) < groupsize then
        SendAddonMessage(info.addonName, 'VERSION:' .. localversion, 'BATTLEGROUND')
        SendAddonMessage(info.addonName, 'VERSION:' .. localversion, 'RAID')
    end
    self.group = groupsize
end

syncFrame:RegisterEvent('SYNC_READY')
syncFrame:RegisterEvent('CHAT_MSG_CHANNEL')
syncFrame:RegisterEvent('CHAT_MSG_ADDON')
syncFrame:RegisterEvent('PARTY_MEMBERS_CHANGED')
syncFrame:SetScript('OnEvent', function()
    if event == 'SYNC_READY' then
        syncFrame:UnregisterEvent('SYNC_READY')
        if DF.others.server ~= 'turtle' then return end
        syncFrame:OnPlayerEnteringWorld()
    end

    if event == 'CHAT_MSG_CHANNEL' then
        syncFrame:OnChatMsgChannelDetected()
    end

    if event == 'CHAT_MSG_ADDON' then
        syncFrame:OnAddonMessage()
    end

    if event == 'PARTY_MEMBERS_CHANGED' then
        syncFrame:OnPartyMembersChanged()
    end
end)

DF.others.syncActive = true

-- admin panel
if isAdmin then
    local adminPanelFrame = CreateFrame('Frame')
    adminPanelFrame:RegisterEvent('VARIABLES_LOADED')
    adminPanelFrame:SetScript('OnEvent', function()
        if event == 'VARIABLES_LOADED' then
            adminPanelFrame:UnregisterAllEvents()

            local syncLoaded = s()
            local statusText = syncLoaded and 'SYNC STATUS: ON' or 'SYNC STATUS: OFF'
            local statusColor = syncLoaded and {0, 1, 0} or {1, 0, 0}

            local warningText = DF.ui.Font(UIParent, 16, statusText, statusColor, 'CENTER')
            warningText:SetPoint('TOP', UIParent, 'TOP', 0, -20)

            local adminPanel = DF.ui.Frame(UIParent, 150, 30, .5, false)
            adminPanel:SetBackdropColor(1, 0, 0, .5)
            adminPanel:SetFrameStrata('BACKGROUND')
            adminPanel:SetFrameLevel(0)
            adminPanel:SetPoint('TOP', warningText, 'BOTTOM', 0, -10)
            local adminText = DF.ui.Font(adminPanel, 10, 'ADMIN', {1, 1, 1}, 'CENTER')
            adminText:SetPoint('CENTER', adminPanel, 'CENTER', 0, 0)
        end
    end)
end
