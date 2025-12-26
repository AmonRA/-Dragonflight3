UNLOCKDRAGONFLIGHT()

function DF.mixins.HideMinimizeMaximizeButton()
    if DF.others.server ~= 'turtle' then return end

    if WorldMapFrameMinimizeButton then
        WorldMapFrameMinimizeButton:Hide()
    end
end

function DF.mixins.IsCollectorException(buttonName)
    if DF.others.server ~= 'turtle' then return false end
    return buttonName == 'EBC_Minimap' or buttonName == 'TWMiniMapBattlefieldFrame'
end
