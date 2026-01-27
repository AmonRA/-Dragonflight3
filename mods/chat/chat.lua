DRAGONFLIGHT()

DF:NewDefaults('chat', {
    enabled = {value = true},
    version = {value = '1.0'},
    gui = {
        {tab = 'chat', subtab = 'chat', 'Chat'},
    },
    chatClassColors = {value = true, metadata = {element = 'checkbox', category = 'Chat', indexInCategory = 1, description = 'Show class colors for player names in chat'}},
    chatDetectUrls = {value = true, metadata = {element = 'checkbox', category = 'Chat', indexInCategory = 2, description = 'Detect and make URLs clickable in chat'}},
    chatTimestamps = {value = true, metadata = {element = 'checkbox', category = 'Chat', indexInCategory = 3, description = 'Show timestamps in chat messages'}},
    chatTimestampColor = {value = {0.41, 0.8, 0.94}, metadata = {element = 'colorpicker', category = 'Chat', indexInCategory = 4, description = 'Color of timestamps', dependency = {key = 'chatTimestamps', state = true}}},
    chatUrlColor = {value = {1, 0.3, 0.3}, metadata = {element = 'colorpicker', category = 'Chat', indexInCategory = 5, description = 'Color of URL links', dependency = {key = 'chatDetectUrls', state = true}}},
    chatAbbreviateChannels = {value = true, metadata = {element = 'checkbox', category = 'Chat', indexInCategory = 6, description = 'Abbreviate channel names (G, P, R, etc.)'}},
    chatFadeTime = {value = 8, metadata = {element = 'slider', category = 'Chat', indexInCategory = 7, description = 'Chat fade time in seconds (0 = disabled)', min = 0, max = 120, stepSize = 1}},

})

DF:NewModule('chat', 1, function()
    DF.common.KillFrame(ChatFrameMenuButton)

    DF_PlayerCache.players = DF_PlayerCache.players or {}
    local playerCache = DF_PlayerCache.players

    local chatcolor = {}
    chatcolor.scanTimer = 0
    chatcolor.scanner = CreateFrame('Frame')

    local chathook = {}
    chathook.original = {}
    chathook.filters = {}

    local chatchannel = {}
    chatchannel.originals = {}

    local chatlinks = {}
    chatlinks.patterns = {
        WWW = {rx = ' (www%d-)%.([_A-Za-z0-9-]+)%.(%S+)%s?', fm = '%s.%s.%s'},
        PROTOCOL = {rx = ' (%a+)://(%S+)%s?', fm = '%s://%s'},
        EMAIL = {rx = ' ([_A-Za-z0-9-%.:]+)@([_A-Za-z0-9-]+)(%.)([_A-Za-z0-9-]+%.?[_A-Za-z0-9-]*)%s?', fm = '%s@%s%s%s'},
        PORTIP = {rx = ' (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?):(%d%d?%d?%d?%d?)%s?', fm = '%s.%s.%s.%s:%s'},
        IP = {rx = ' (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%s?', fm = '%s.%s.%s.%s'},
        SHORTURL = {rx = ' (%a+)%.(%a+)/(%S+)%s?', fm = '%s.%s/%s'},
        URLIP = {rx = ' ([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%:([_0-9-]+)%s?', fm = '%s.%s.%s:%s'},
        URL = {rx = ' ([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%s?', fm = '%s.%s.%s'},
    }

    function chatchannel:Abbreviate()
        local left = '|r['
        local right = ']|r'
        local fmt = ' %s|r: '
        self.originals.CHAT_CHANNEL_GET = _G.CHAT_CHANNEL_GET
        self.originals.CHAT_GUILD_GET = _G.CHAT_GUILD_GET
        self.originals.CHAT_OFFICER_GET = _G.CHAT_OFFICER_GET
        self.originals.CHAT_PARTY_GET = _G.CHAT_PARTY_GET
        self.originals.CHAT_RAID_GET = _G.CHAT_RAID_GET
        self.originals.CHAT_RAID_LEADER_GET = _G.CHAT_RAID_LEADER_GET
        self.originals.CHAT_RAID_WARNING_GET = _G.CHAT_RAID_WARNING_GET
        self.originals.CHAT_BATTLEGROUND_GET = _G.CHAT_BATTLEGROUND_GET
        self.originals.CHAT_BATTLEGROUND_LEADER_GET = _G.CHAT_BATTLEGROUND_LEADER_GET
        self.originals.CHAT_SAY_GET = _G.CHAT_SAY_GET
        self.originals.CHAT_YELL_GET = _G.CHAT_YELL_GET
        self.originals.CHAT_WHISPER_GET = _G.CHAT_WHISPER_GET
        self.originals.CHAT_WHISPER_INFORM_GET = _G.CHAT_WHISPER_INFORM_GET
        self.originals.CHAT_AFK_GET = _G.CHAT_AFK_GET
        self.originals.CHAT_DND_GET = _G.CHAT_DND_GET
        _G.CHAT_CHANNEL_GET = '%s|r: '
        _G.CHAT_GUILD_GET = left .. 'G' .. right .. fmt
        _G.CHAT_OFFICER_GET = left .. 'O' .. right .. fmt
        _G.CHAT_PARTY_GET = left .. 'P' .. right .. fmt
        _G.CHAT_RAID_GET = left .. 'R' .. right .. fmt
        _G.CHAT_RAID_LEADER_GET = left .. 'RL' .. right .. fmt
        _G.CHAT_RAID_WARNING_GET = left .. 'RW' .. right .. fmt
        _G.CHAT_BATTLEGROUND_GET = left .. 'BG' .. right .. fmt
        _G.CHAT_BATTLEGROUND_LEADER_GET = left .. 'BL' .. right .. fmt
        _G.CHAT_SAY_GET = left .. 'S' .. right .. fmt
        _G.CHAT_YELL_GET = left .. 'Y' .. right .. fmt
        _G.CHAT_WHISPER_GET = left .. 'W' .. right .. fmt
        _G.CHAT_WHISPER_INFORM_GET = left .. 'W' .. right .. fmt
        _G.CHAT_AFK_GET = left .. 'AFK' .. right .. fmt
        _G.CHAT_DND_GET = left .. 'DND' .. right .. fmt
    end

    function chatchannel:Restore()
        for k, v in pairs(self.originals) do
            _G[k] = v
        end
    end

    function chathook:AddFilter(name, func)
        self.filters[name] = func
        self:RebuildHooks()
    end

    function chathook:RemoveFilter(name)
        self.filters[name] = nil
        self:RebuildHooks()
    end

    function chathook:RebuildHooks()
        for i = 1, NUM_CHAT_WINDOWS do
            local frame = getglobal('ChatFrame'..i)
            if frame then
                if not self.original[frame] then
                    self.original[frame] = frame.AddMessage
                end
                frame.AddMessage = function(self, text, r, g, b, id, hold)
                    if text then
                        -- hide DragonflightSync channel messages
                        if string.find(string.lower(text), '%[%d+%. dragonflightsync%]') then
                            local isAdmin = UnitName('player') == a()
                            if not (isAdmin and s()) then return end
                        end
                        for _, func in pairs(chathook.filters) do
                            text = func(text) or text
                        end
                    end
                    chathook.original[self](self, text, r, g, b, id, hold)
                end
            end
        end
    end

    function chatlinks:FormatLink(fmt, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
        if not (fmt and a1) then return end
        local url = string.format(fmt, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
        local invalidtld
        for _, arg in pairs({a10, a9, a8, a7, a6, a5, a4, a3, a2, a1}) do
            if arg then
                invalidtld = string.find(arg, '(%.%.)$')
                break
            end
        end
        if invalidtld then return url end
        local color = DF.profile.chat.chatUrlColor
        local hex = string.format('|cff%02x%02x%02x', color[1]*255, color[2]*255, color[3]*255)
        if fmt == self.patterns.EMAIL.fm then
            local colon = string.find(a1, ':')
            if colon and string.len(a1) > colon then
                if not (string.sub(a1, 1, 6) == 'mailto') then
                    local prefix, address = string.sub(url, 1, colon), string.sub(url, colon + 1)
                    return string.format(' %s'..hex..'|Hurl:%s|h[%s]|h|r ', prefix, address, address)
                end
            end
        end
        return ' '..hex..'|Hurl:' .. url .. '|h[' .. url .. ']|h|r '
    end

    function chatlinks:HandleLink(text)
        text = string.gsub(text, self.patterns.WWW.rx, function(a1, a2, a3) return self:FormatLink(self.patterns.WWW.fm, a1, a2, a3) end)
        text = string.gsub(text, self.patterns.PROTOCOL.rx, function(a1, a2) return self:FormatLink(self.patterns.PROTOCOL.fm, a1, a2) end)
        text = string.gsub(text, self.patterns.EMAIL.rx, function(a1, a2, a3, a4) return self:FormatLink(self.patterns.EMAIL.fm, a1, a2, a3, a4) end)
        text = string.gsub(text, self.patterns.PORTIP.rx, function(a1, a2, a3, a4, a5) return self:FormatLink(self.patterns.PORTIP.fm, a1, a2, a3, a4, a5) end)
        text = string.gsub(text, self.patterns.IP.rx, function(a1, a2, a3, a4) return self:FormatLink(self.patterns.IP.fm, a1, a2, a3, a4) end)
        text = string.gsub(text, self.patterns.SHORTURL.rx, function(a1, a2, a3) return self:FormatLink(self.patterns.SHORTURL.fm, a1, a2, a3) end)
        text = string.gsub(text, self.patterns.URLIP.rx, function(a1, a2, a3, a4) return self:FormatLink(self.patterns.URLIP.fm, a1, a2, a3, a4) end)
        text = string.gsub(text, self.patterns.URL.rx, function(a1, a2, a3) return self:FormatLink(self.patterns.URL.fm, a1, a2, a3) end)
        return text
    end

    chatlinks.dialog = DF.ui.CreateLinkPopup(UIParent, UIParent, "DF_ChatPopUp", '', 'Press Ctrl+C to copy the link')

    chatlinks.oldSetItemRef = _G.SetItemRef
    ---@diagnostic disable-next-line: duplicate-set-field
    function _G.SetItemRef(link, text, button)
        if strsub(link, 1, 3) == 'url' then
            if string.len(link) > 4 and string.sub(link, 1, 4) == 'url:' then
                local url = string.sub(link, 5, string.len(link))
                chatlinks.dialog.editBox:SetText(url)
                chatlinks.dialog.editBox:HighlightText()
                chatlinks.dialog:Show()
            end
            return
        end
        chatlinks.oldSetItemRef(link, text, button)
    end

    local function SkinChatTab(chatTab)
        if not chatTab or chatTab.auroraSkinned then return end

        local tex = media['tex:interface:uiframetabs']

        _G[chatTab:GetName()..'Left']:Hide()
        _G[chatTab:GetName()..'Middle']:Hide()
        _G[chatTab:GetName()..'Right']:Hide()

        local hl = chatTab:GetHighlightTexture()
        if hl then hl:Hide() end

        local left = chatTab:CreateTexture(nil, 'BACKGROUND')
        left:SetTexture(tex)
        left:SetSize(35, 36)
        left:SetPoint('TOPLEFT', chatTab, 'TOPLEFT', -3, 0)
        left:SetTexCoord(0.015625, 0.5625, 0.957031, 0.816406)
        chatTab.auroraLeft = left

        local right = chatTab:CreateTexture(nil, 'BACKGROUND')
        right:SetTexture(tex)
        right:SetSize(37, 36)
        right:SetPoint('TOPRIGHT', chatTab, 'TOPRIGHT', 7, 0)
        right:SetTexCoord(0.015625, 0.59375, 0.808594, 0.667969)
        chatTab.auroraRight = right

        local middle = chatTab:CreateTexture(nil, 'BACKGROUND')
        middle:SetTexture(tex)
        middle:SetSize(1, 36)
        middle:SetPoint('TOPLEFT', left, 'TOPRIGHT', 0, 0)
        middle:SetPoint('TOPRIGHT', right, 'TOPLEFT', 0, 0)
        middle:SetTexCoord(0, 0.015625, 0.316406, 0.175781)
        chatTab.auroraMiddle = middle

        local leftSel = chatTab:CreateTexture(nil, 'BACKGROUND')
        leftSel:SetTexture(tex)
        leftSel:SetSize(35, 35)
        leftSel:SetPoint('BOTTOMLEFT', chatTab, 'BOTTOMLEFT', -1, 0)
        leftSel:SetTexCoord(0.015625, 0.5625, 0.660156, 0.496094)
        leftSel:Hide()
        chatTab.auroraLeftSel = leftSel

        local rightSel = chatTab:CreateTexture(nil, 'BACKGROUND')
        rightSel:SetTexture(tex)
        rightSel:SetSize(37, 35)
        rightSel:SetPoint('BOTTOMRIGHT', chatTab, 'BOTTOMRIGHT', 8, 0)
        rightSel:SetTexCoord(0.015625, 0.59375, 0.488281, 0.324219)
        rightSel:Hide()
        chatTab.auroraRightSel = rightSel

        local middleSel = chatTab:CreateTexture(nil, 'BACKGROUND')
        middleSel:SetTexture(tex)
        middleSel:SetSize(1, 35)
        middleSel:SetPoint('BOTTOMLEFT', leftSel, 'BOTTOMRIGHT', 0, 0)
        middleSel:SetPoint('BOTTOMRIGHT', rightSel, 'BOTTOMLEFT', 0, 0)
        middleSel:SetTexCoord(0, 0.015625, 0.167969, 0.00390625)
        middleSel:Hide()
        chatTab.auroraMiddleSel = middleSel

        chatTab:SetScript('OnSizeChanged', function()
            local edgeWidth = this:GetWidth() / 2
            this.auroraLeft:SetWidth(edgeWidth)
            this.auroraRight:SetWidth(edgeWidth)
            this.auroraLeftSel:SetWidth(edgeWidth)
            this.auroraRightSel:SetWidth(edgeWidth)
        end)
        chatTab.auroraSkinned = true
    end

    local oldFCF_SelectDockFrame = _G.FCF_SelectDockFrame
    _G.FCF_SelectDockFrame = function(frame)
        oldFCF_SelectDockFrame(frame)
        for i = 1, NUM_CHAT_WINDOWS do
            local tab = _G['ChatFrame'..i..'Tab']
            if tab and tab.auroraSkinned then
                local isSelected = (SELECTED_DOCK_FRAME and SELECTED_DOCK_FRAME:GetID() == i)
                if isSelected then
                    tab.auroraLeft:Hide()
                    tab.auroraRight:Hide()
                    tab.auroraMiddle:Hide()
                    tab.auroraLeftSel:Show()
                    tab.auroraRightSel:Show()
                    tab.auroraMiddleSel:Show()
                else
                    tab.auroraLeft:Show()
                    tab.auroraRight:Show()
                    tab.auroraMiddle:Show()
                    tab.auroraLeftSel:Hide()
                    tab.auroraRightSel:Hide()
                    tab.auroraMiddleSel:Hide()
                end
            end
        end
    end

    local oldFCF_DockUpdate = _G.FCF_DockUpdate
    _G.FCF_DockUpdate = function()
        oldFCF_DockUpdate()
        for i = 1, NUM_CHAT_WINDOWS do
            local chatFrame = _G['ChatFrame'..i]
            local chatTab = _G['ChatFrame'..i..'Tab']
            if chatFrame and chatFrame.isDocked and chatTab then
                local isSelected = (SELECTED_DOCK_FRAME and SELECTED_DOCK_FRAME:GetID() == i)
                local yOffset = isSelected and 0 or 3
                local point, relativeTo, relativePoint, x, y = chatTab:GetPoint(1)
                if y ~= yOffset then
                    chatTab:ClearAllPoints()
                    chatTab:SetPoint(point, relativeTo, relativePoint, x, yOffset)
                end
            end
        end
    end


    for i = 1, NUM_CHAT_WINDOWS do
        local tab = _G['ChatFrame'..i..'Tab']
        if tab then
            SkinChatTab(tab)
            -- tab:ClearAllPoints()
            -- tab:SetPoint('BOTTOMLEFT', _G['ChatFrame'..i], 'TOPLEFT', 50, 15)
        end
    end

    for i = 1, NUM_CHAT_WINDOWS do
        local cf = _G['ChatFrame'..i]
        if cf then
            DF.common.KillFrame(_G['ChatFrame'..i..'BottomButton'])
            DF.common.KillFrame(_G['ChatFrame'..i..'DownButton'])
            DF.common.KillFrame(_G['ChatFrame'..i..'UpButton'])

            local upBtn = DF.ui.PageButton(cf, 20, 20, 'ChatFrame'..i..'UpBtn', 'north', 8)
            upBtn:SetPoint('BOTTOMLEFT', cf, 'BOTTOMLEFT', -24, 40)
            upBtn.clickDelay = 0
            upBtn:SetScript('OnUpdate', function()
                if this:GetButtonState() == 'PUSHED' then
                    this.clickDelay = this.clickDelay - arg1
                    if this.clickDelay < 0 then
                        cf:ScrollUp()
                        this.clickDelay = 0.05
                    end
                end
            end)
            upBtn:SetScript('OnMouseDown', function()
                cf:ScrollUp()
                PlaySound('igChatScrollUp')
                this.clickDelay = 0
            end)

            local downBtn = DF.ui.PageButton(cf, 20, 20, 'ChatFrame'..i..'DownBtn', 'south', 8)
            downBtn:SetPoint('BOTTOMLEFT', cf, 'BOTTOMLEFT', -24, 20)
            downBtn.clickDelay = 0
            downBtn:SetScript('OnUpdate', function()
                if this:GetButtonState() == 'PUSHED' then
                    this.clickDelay = this.clickDelay - arg1
                    if this.clickDelay < 0 then
                        cf:ScrollDown()
                        this.clickDelay = 0.05
                    end
                end
            end)
            downBtn:SetScript('OnMouseDown', function()
                cf:ScrollDown()
                PlaySound('igChatScrollDown')
                this.clickDelay = 0
            end)

            local bottomBtn = DF.ui.PageButton(cf, 20, 20, 'ChatFrame'..i..'BottomBtn', 'south', 8)
            bottomBtn:SetPoint('BOTTOMLEFT', cf, 'BOTTOMLEFT', -24, 0)
            bottomBtn:SetScript('OnClick', function()
                cf:ScrollToBottom()
                PlaySound('igChatScrollDown')
            end)

            local pulse = bottomBtn:CreateTexture(nil, 'OVERLAY')
            pulse:SetPoint('TOPLEFT', bottomBtn, 'TOPLEFT', -14, 7)
            pulse:SetPoint('BOTTOMRIGHT', bottomBtn, 'BOTTOMRIGHT', 14, -7)
            pulse:SetTexture(media['tex:micromenu:micro_highlight.blp'])
            pulse:SetBlendMode('ADD')
            pulse:SetAlpha(0)
            pulse._elapsed = 0
            pulse._direction = 1

            function bottomBtn:UpdatePulse()
                if cf:AtBottom() then
                    pulse:SetAlpha(0)
                    pulse:Hide()
                else
                    pulse:Show()
                    pulse._elapsed = pulse._elapsed + arg1
                    if pulse._elapsed >= 0.5 then
                        pulse._direction = -pulse._direction
                        pulse._elapsed = 0
                    end
                    local alpha = pulse._elapsed / 0.5
                    if pulse._direction < 0 then alpha = 1 - alpha end
                    pulse:SetAlpha(alpha * 0.5)
                end
            end

            cf:SetScript('OnUpdate', function() bottomBtn:UpdatePulse() end)
        end
    end

    local upBtn1 = _G['ChatFrame1UpBtn']
    local menuBtn = DF.ui.PageButton(UIParent, 20, 20, 'DF_ChatMenuButton', 'east', 8)
    menuBtn:SetPoint('BOTTOM', upBtn1, 'TOP', 0, 0)
    menuBtn:SetScript('OnClick', function()
        PlaySound('igChatEmoteButton')
        ToggleDropDownMenu(1, nil, ChatFrame1TabDropDown, 'DF_ChatMenuButton', 0, 0)
    end)
    menuBtn:SetScript('OnEnter', function()
        GameTooltip_AddNewbieTip('Chat', 1.0, 1.0, 1.0, _G['NEWBIE_TOOLTIP_CHATMENU'])
    end)
    menuBtn:SetScript('OnLeave', function()
        GameTooltip:Hide()
    end)

    chatcolor.scanner = CreateFrame('Frame')
    chatcolor.scanner:RegisterEvent('PLAYER_ENTERING_WORLD')
    chatcolor.scanner:RegisterEvent('FRIENDLIST_UPDATE')
    chatcolor.scanner:RegisterEvent('GUILD_ROSTER_UPDATE')
    chatcolor.scanner:RegisterEvent('RAID_ROSTER_UPDATE')
    chatcolor.scanner:RegisterEvent('PARTY_MEMBERS_CHANGED')
    chatcolor.scanner:RegisterEvent('PLAYER_TARGET_CHANGED')
    chatcolor.scanner:RegisterEvent('UPDATE_MOUSEOVER_UNIT')
    chatcolor.scanner:RegisterEvent('WHO_LIST_UPDATE')
    chatcolor.scanner:SetScript('OnEvent', function()
        if event == 'PLAYER_ENTERING_WORLD' then
            local name = UnitName('player')
            local _, class = UnitClass('player')
            playerCache[name] = class
        elseif event == 'FRIENDLIST_UPDATE' then
            for i = 1, GetNumFriends() do
                local name, level, class = GetFriendInfo(i)
                if name and class then
                    playerCache[name] = class
                end
            end
        elseif event == 'GUILD_ROSTER_UPDATE' then
            for i = 1, GetNumGuildMembers() do
                local name, _, _, _, class = GetGuildRosterInfo(i)
                if name and class then
                    playerCache[name] = class
                end
            end
        elseif event == 'RAID_ROSTER_UPDATE' then
            for i = 1, GetNumRaidMembers() do
                local name, _, _, _, class = GetRaidRosterInfo(i)
                if name and class then
                    playerCache[name] = class
                end
            end
        elseif event == 'PARTY_MEMBERS_CHANGED' then
            for i = 1, GetNumPartyMembers() do
                local unit = 'party'..i
                local name = UnitName(unit)
                local _, class = UnitClass(unit)
                if name and class then
                    playerCache[name] = class
                end
            end
        elseif event == 'WHO_LIST_UPDATE' then
            for i = 1, GetNumWhoResults() do
                local name, _, _, _, class = GetWhoInfo(i)
                if name and class then
                    playerCache[name] = class
                end
            end
        elseif event == 'PLAYER_TARGET_CHANGED' or event == 'UPDATE_MOUSEOVER_UNIT' then
            local unit = event == 'PLAYER_TARGET_CHANGED' and 'target' or 'mouseover'
            if UnitIsPlayer(unit) then
                local name = UnitName(unit)
                local _, class = UnitClass(unit)
                if name and class then
                    playerCache[name] = class
                end
            end
        end
    end)

    -- callbacks
    local callbacks = {}

    callbacks.chatClassColors = function(value)
        if value then
            chathook:AddFilter('classcolor', function(text)
                for name in string.gfind(text, '|Hplayer:(.-)|h') do
                    local parts = DF.data.split(name, ':')
                    local real = parts[1]
                    local class = playerCache[real]
                    local hex
                    if class and DF.tables.classcolors[class] then
                        local color = DF.tables.classcolors[class]
                        hex = string.format('|cff%02x%02x%02x', color[1]*255, color[2]*255, color[3]*255)
                    else
                        hex = '|cffbbbbbb'
                    end
                    text = string.gsub(text, '|Hplayer:'..name..'|h%['..real..'%]|h', '|r['..hex..'|Hplayer:'..name..'|h'..hex..real..'|h|r]|r')
                end
                return text
            end)
        else
            chathook:RemoveFilter('classcolor')
        end
    end

    callbacks.chatDetectUrls = function(value)
        if value then
            chathook:AddFilter('urls', function(text)
                return chatlinks:HandleLink(text)
            end)
        else
            chathook:RemoveFilter('urls')
        end
    end

    callbacks.chatTimestamps = function(value)
        if value then
            chathook:AddFilter('timestamp', function(text)
                local color = DF.profile.chat.chatTimestampColor
                local hex = string.format('|cff%02x%02x%02x', color[1]*255, color[2]*255, color[3]*255)
                return hex..'['..date('%H:%M:%S')..']|r ' .. text
            end)
        else
            chathook:RemoveFilter('timestamp')
        end
    end

    callbacks.chatTimestampColor = function(value)
        if DF.profile.chat.chatTimestamps then
            callbacks.chatTimestamps(false)
            callbacks.chatTimestamps(true)
        end
    end

    callbacks.chatUrlColor = function(value)
        if DF.profile.chat.chatDetectUrls then
            callbacks.chatDetectUrls(false)
            callbacks.chatDetectUrls(true)
        end
    end

    callbacks.chatAbbreviateChannels = function(value)
        if value then
            chatchannel:Abbreviate()
            chathook:AddFilter('channelnum', function(text)
                local channel = string.gsub(text, '.*%[(.-)%]%s+(.*|Hplayer).+', '%1')
                if string.find(channel, '%d+%. ') then
                    channel = string.gsub(channel, '(%d+)%..*', '%1')
                    text = string.gsub(text, '%[%d+%..-%]%s+(.*|Hplayer)', '|r['..channel..']|r %1')
                end
                return text
            end)
        else
            chatchannel:Restore()
            chathook:RemoveFilter('channelnum')
        end
    end

    callbacks.chatFadeTime = function(value)
        for i = 1, NUM_CHAT_WINDOWS do
            local f = _G['ChatFrame'..i]
            if value == 0 then
                f:SetFadeDuration(3)
                f:SetTimeVisible(180)
            else
                f:SetFadeDuration(0.3)
                f:SetTimeVisible(value)
            end
        end
    end

    DF:NewCallbacks('chat', callbacks)
end)
