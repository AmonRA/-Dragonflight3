DRAGONFLIGHT()

DF:NewDefaults('frameinspect', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('frameinspect', 1, function()
    local frame = DF.ui.Frame(UIParent, 300, 400, 0.4, false, 'InspectorFrame')
    frame:SetFrameStrata('TOOLTIP')
    frame:IsToplevel(true)
    frame:SetFrameLevel(100)
    frame:SetClampedToScreen(true)
    frame:Hide()

    DF.setups.frameinspect = frame

    local targetHeight = 400
    local targetWidth = 300
    local targetX, targetY = 0, 0
    local currentX, currentY = 0, 0

    local fonts = {}
    local fontNames = {'nameFont', 'pathFont', 'strataFont', 'layerFont', 'dimensionsFont', 'positionFont', 'typeFont', 'anchorFont', 'scriptsFont', 'childrenFont', 'texturesFont', 'regionsFont'}
    for i = 1, table.getn(fontNames) do
        local size = i == 1 and 12 or 11
        local color = i == 1 and {1, 1, 0} or {1, 1, 1}
        fonts[fontNames[i]] = DF.ui.Font(frame, size, '', color, 'LEFT')
        if i == 1 then
            fonts[fontNames[i]]:SetPoint('TOPLEFT', frame, 'TOPLEFT', 5, -5)
        else
            fonts[fontNames[i]]:SetPoint('TOPLEFT', fonts[fontNames[i-1]], 'BOTTOMLEFT', 0, -2)
        end
        fonts[fontNames[i]]:SetWidth(290)
    end
    local nameFont, pathFont, strataFont, layerFont, dimensionsFont, positionFont, typeFont, anchorFont, scriptsFont, childrenFont, texturesFont, regionsFont = fonts.nameFont, fonts.pathFont, fonts.strataFont, fonts.layerFont, fonts.dimensionsFont, fonts.positionFont, fonts.typeFont, fonts.anchorFont, fonts.scriptsFont, fonts.childrenFont, fonts.texturesFont, fonts.regionsFont

    frame:SetScript('OnUpdate', function()
        local x, y = GetCursorPosition()
        local scale = UIParent:GetEffectiveScale()
        local screenWidth = UIParent:GetWidth()
        local screenHeight = UIParent:GetHeight()

        if x/scale > screenWidth/2 then
            if y/scale > screenHeight/2 then
                targetX = x/scale - 10 - frame:GetWidth()
                targetY = y/scale - 10 - frame:GetHeight()
            else
                targetX = x/scale - 10 - frame:GetWidth()
                targetY = y/scale + 10
            end
        else
            if y/scale > screenHeight/2 then
                targetX = x/scale + 10
                targetY = y/scale - 10 - frame:GetHeight()
            else
                targetX = x/scale + 10
                targetY = y/scale + 10
            end
        end

        currentX = currentX + (targetX - currentX) * 0.3
        currentY = currentY + (targetY - currentY) * 0.3

        frame:ClearAllPoints()
        frame:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', currentX, currentY)

        local hoverFrame = GetMouseFocus()
        if hoverFrame then
            nameFont:SetText(hoverFrame:GetName() or 'unnamed')

            local path = ''
            local current = hoverFrame
            while current and current ~= UIParent do
                local name = current:GetName() or 'unnamed'
                path = name .. (path == '' and '' or ' > ' .. path)
                current = current:GetParent()
            end
            pathFont:SetText('|cFF87CEEB Parents:|r ' .. path)

            strataFont:SetText('|cFF87CEEB Strata:|r ' .. hoverFrame:GetFrameStrata())
            layerFont:SetText('|cFF87CEEB Layer:|r ' .. hoverFrame:GetFrameLevel())
            dimensionsFont:SetText('|cFF87CEEB Size:|r ' .. hoverFrame:GetWidth() .. 'x' .. hoverFrame:GetHeight())

            local left = hoverFrame:GetLeft() or 0
            local bottom = hoverFrame:GetBottom() or 0
            positionFont:SetText('|cFF87CEEB Position:|r ' .. left .. ',' .. bottom)

            typeFont:SetText('|cFF87CEEB Type:|r ' .. hoverFrame:GetObjectType())

            local numPoints = hoverFrame:GetNumPoints()
            anchorFont:SetText('|cFF87CEEB Anchors:|r ' .. numPoints)

            local scriptTypes = {'OnLoad', 'OnShow', 'OnHide', 'OnUpdate', 'OnEvent', 'OnClick', 'OnEnter', 'OnLeave'}
            local activeScripts = ''
            local scriptCount = 0
            for i = 1, table.getn(scriptTypes) do
                if hoverFrame:HasScript(scriptTypes[i]) and hoverFrame:GetScript(scriptTypes[i]) then
                    scriptCount = scriptCount + 1
                    if scriptCount == 1 then
                        activeScripts = '|cFF87CEEB Scripts:|r ' .. scriptCount
                    end
                    activeScripts = activeScripts .. '\n|cFFFFFF00' .. scriptCount .. '|r. ' .. scriptTypes[i]
                end
            end
            if scriptCount == 0 then activeScripts = '|cFF87CEEB Scripts:|r 0' end
            scriptsFont:SetText(activeScripts)

            local children = {hoverFrame:GetChildren()}
            local childInfo = '|cFF87CEEB Children:|r ' .. table.getn(children)
            for i = 1, table.getn(children) do
                local child = children[i]
                local childName = child:GetName() or 'unnamed'
                local childType = child:GetObjectType()
                childInfo = childInfo .. '\n|cFFFF8000' .. i .. '|r. ' .. childName .. ' (' .. childType .. ')'
            end
            childrenFont:SetText(childInfo)

            local regions = {hoverFrame:GetRegions()}
            local textureInfo = ''
            local textureCount = 0
            for i = 1, table.getn(regions) do
                if regions[i]:GetObjectType() == 'Texture' then
                    textureCount = textureCount + 1
                end
            end

            textureInfo = '|cFF87CEEB Textures:|r ' .. textureCount
            local texIndex = 0
            for i = 1, table.getn(regions) do
                if regions[i]:GetObjectType() == 'Texture' then
                    texIndex = texIndex + 1
                    local tex = regions[i]
                    local texPath = tex:GetTexture() or 'none'
                    local layer = tex:GetDrawLayer() or 'ARTWORK'
                    textureInfo = textureInfo .. '\n|cFF00FF00' .. texIndex .. '|r. ' .. layer .. ': ' .. texPath
                end
            end
            texturesFont:SetText(textureInfo)

            local regionInfo = ''
            local regionCount = 0
            for i = 1, table.getn(regions) do
                local regionType = regions[i]:GetObjectType()
                if regionType == 'Texture' or regionType == 'FontString' then
                    regionCount = regionCount + 1
                end
            end

            regionInfo = '|cFF87CEEB Regions:|r ' .. regionCount
            local regIndex = 0
            for i = 1, table.getn(regions) do
                local region = regions[i]
                local regionType = region:GetObjectType()
                if regionType == 'Texture' then
                    regIndex = regIndex + 1
                    local texPath = region:GetTexture() or 'none'
                    local layer = region:GetDrawLayer() or 'ARTWORK'
                    regionInfo = regionInfo .. '\n|cFF00FF00' .. regIndex .. '|r. Texture: ' .. layer .. ': ' .. texPath
                elseif regionType == 'FontString' then
                    regIndex = regIndex + 1
                    local text = region:GetText() or 'empty'
                    regionInfo = regionInfo .. '\n|cFFFFD700' .. regIndex .. '|r. FontString: ' .. text
                end
            end
            regionsFont:SetText(regionInfo)

            local textureBottom = regionsFont:GetBottom() or 0
            local frameTop = frame:GetTop() or 0
            local contentHeight = frameTop - textureBottom + 20
            targetHeight = contentHeight

            local maxWidth = 300
            local fonts = {nameFont, pathFont, strataFont, layerFont, dimensionsFont, positionFont, typeFont, anchorFont, scriptsFont, childrenFont, texturesFont, regionsFont}
            for i = 1, table.getn(fonts) do
                local textWidth = fonts[i]:GetStringWidth() + 10
                if textWidth > maxWidth then
                    maxWidth = textWidth
                end
            end
            targetWidth = maxWidth

            local currentHeight = frame:GetHeight()
            local newHeight = currentHeight + (targetHeight - currentHeight) * 0.3
            frame:SetHeight(newHeight)

            local currentWidth = frame:GetWidth()
            local newWidth = currentWidth + (targetWidth - currentWidth) * 0.3
            frame:SetWidth(newWidth)

            for i = 1, table.getn(fonts) do
                fonts[i]:SetWidth(newWidth - 10)
            end
        end
    end)
end)
