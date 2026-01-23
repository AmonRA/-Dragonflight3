-- DRAGONFLIGHT()

-- DF:NewDefaults('bubbles', {
--     enabled = {value = true},
--     version = {value = '1.0'},
--     -- defaults gui structure: {tab = 'tabname', subtab = 'subtabname', 'category1', 'category2', ...}
--     -- named keys (tab, subtab) define panel location, array elements define categories within that panel
--     -- each category groups related settings with a header, settings use category + indexInCategory for ordering
--     gui = {
--         {tab = 'bubbles', subtab = 'mainbar', 'General'},
--     },

--     -- defaults examples:
--     -- animationTexture = {value = 'Aura1', metadata = {element = 'dropdown', category = 'Animation', indexInCategory = 2, description = 'Animation texture style', options = {'Aura1', 'Aura2', 'Aura3', 'Aura4', 'Glow1', 'Glow2', 'Shock1', 'Shock2', 'Shock3'}, dependency = {key = 'minimapAnimation', state = true}}},
--     -- customPlayerArrow = {value = true, metadata = {element = 'checkbox', category = 'Arrow', indexInCategory = 1, description = 'Use Dragonflight\'s custom player arrow', dependency = {key = 'showMinimap', state = true}}},
--     -- playerArrowScale = {value = 1, metadata = {element = 'slider', category = 'Arrow', indexInCategory = 3, description = 'Size of the player arrow', min = 0.5, max = 2, stepSize = 0.1, dependency = {key = 'showMinimap', state = true}}},
--     -- playerArrowColor = {value = {1, 1, 1}, metadata = {element = 'colorpicker', category = 'Arrow', indexInCategory = 4, description = 'Color of the player arrow', dependency = {key = 'customPlayerArrow', state = true}}},
--     bubblesprint = {value = true, metadata = {element = 'checkbox', category = 'General', indexInCategory = 1, description = 'bubbles print description'}},

-- })

-- DF:NewModule('bubbles', 1, function()
--     -- dragonflight module system flow:
--     -- ApplyDefaults() populates DF.profile[module][option] with default values from DF.defaults
--     -- ExecModules() loads modules by calling each enabled module's func() based on priority
--     -- module's func() creates UI/features and calls NewCallbacks() as its last step
--     -- NewCallbacks() registers callbacks and immediately executes them with current DF_Profiles values to initialize module state
--     -- gui changes trigger SetConfig() which updates DF_Profiles then re-executes the callback with new value

--     -- base structure area for base module setup
--     local bubbleFrame = CreateFrame('Frame')
--     bubbleFrame:RegisterEvent('CHAT_MSG_SAY')
--     bubbleFrame:RegisterEvent('CHAT_MSG_YELL')
--     bubbleFrame:RegisterEvent('CHAT_MSG_PARTY')
--     bubbleFrame:RegisterEvent('CHAT_MSG_MONSTER_SAY')
--     bubbleFrame:RegisterEvent('CHAT_MSG_MONSTER_YELL')

--     local lastSender = nil
--     local lastMessage = nil

--     local function IsChatBubble(frame)
--         if frame:GetName() then return false end
--         if frame.customBubble then return true end
--         if not frame:GetRegions() then return false end
--         local region = frame:GetRegions()
--         return region and region.GetTexture and region:GetTexture() == 'Interface\\Tooltips\\ChatBubble-Background'
--     end



--     local function StyleBubble(bubble, senderName, messageText)
--         local regions = {bubble:GetRegions()}
--         for _, region in pairs(regions) do
--             if region:GetObjectType() == 'Texture' then
--                 region:SetTexture(nil)
--             elseif region:GetObjectType() == 'FontString' then
--                 region:Hide()
--             end
--         end

--         bubble:SetWidth(1)
--         bubble:SetHeight(1)
--         bubble:SetAlpha(0)

--         if not bubble.customBubble then
--             local customBubble = CreateFrame('Frame', nil, bubble)
--             customBubble:SetPoint('CENTER', bubble, 'CENTER', 0, 50)
--             customBubble:SetWidth(200)
--             customBubble:SetHeight(60)
--             customBubble:SetBackdrop({
--                 bgFile = 'Interface\\Buttons\\WHITE8X8',
--                 edgeFile = 'Interface\\Buttons\\WHITE8X8',
--                 edgeSize = 2,
--             })
--             customBubble:SetBackdropColor(0, 0, 0, 0.8)
--             customBubble:SetBackdropBorderColor(0, 0, 0, 1)
--             customBubble:SetFrameStrata('TOOLTIP')

--             customBubble.text = customBubble:CreateFontString(nil, 'OVERLAY')
--             customBubble.text:SetFont('Fonts\\FRIZQT__.TTF', 12, '')
--             customBubble.text:SetPoint('CENTER',customBubble)

--             local nameFrame = CreateFrame('Frame', nil, customBubble)
--             nameFrame:SetPoint('BOTTOMLEFT', customBubble, 'TOPLEFT', 0, 0)
--             nameFrame:SetHeight(20)
--             nameFrame:SetWidth(50)
--             nameFrame:SetBackdrop({
--                 bgFile = 'Interface\\Buttons\\WHITE8X8',
--                 edgeFile = 'Interface\\Buttons\\WHITE8X8',
--                 edgeSize = 1,
--             })
--             nameFrame:SetBackdropColor(0, 0, 0, 0.8)
--             nameFrame:SetBackdropBorderColor(0, 0, 0, 1)

--             nameFrame.text = nameFrame:CreateFontString(nil, 'OVERLAY')
--             nameFrame.text:SetFont('Fonts\\FRIZQT__.TTF', 8, '')
--             nameFrame.text:SetPoint('CENTER', nameFrame)

--             customBubble.nameFrame = nameFrame
--             bubble.customBubble = customBubble
--         end

--         bubble.customBubble.text:SetText(messageText or '')
--         if senderName then
--             bubble.customBubble.nameFrame.text:SetText(senderName)
--         end
--     end

--     local function ScanBubbles()
--         local children = {WorldFrame:GetChildren()}
--         for _, child in pairs(children) do
--             if IsChatBubble(child) then
--                 StyleBubble(child, lastSender, lastMessage)
--             end
--         end
--     end

--     bubbleFrame:SetScript('OnEvent', function()
--         lastMessage = arg1
--         lastSender = arg2
--         bubbleFrame:SetScript('OnUpdate', function()
--             ScanBubbles()
--             bubbleFrame:SetScript('OnUpdate', nil)
--         end)
--     end)

--     -- callbacks area are options that show up for the user in the gui
--     local callbacks = {}
--     local callbackHelper = {} -- helper table for shared functions

--     callbacks.bubblesprint = function(value)
--         if value then
--             print('bubblesprint from bubbles!')
--         end
--     end

--     DF:NewCallbacks('bubbles', callbacks)
-- end)
