DRAGONFLIGHT()

DF:NewDefaults('gui-developement', {
    enabled = {value = true},
    version = {value = '1.0'},
})

DF:NewModule('gui-developement', 2, function()
    local setup = DF.setups.guiBase
    if not setup then return end

    local devPanel = setup.panels['development']

    local block1 = DF.ui.Font(devPanel, 18, '|cffff8000BETA BUILD|r - Expect bugs and frequent changes.', {1, 1, 1}, 'CENTER')
    block1:SetPoint('TOP', devPanel, 'TOP', -55, -40)

    local block2 = DF.ui.Font(devPanel, 12, '|cffffcc00Bug Reports:|r\n\n- You must use |cffffcc00/df safeboot|r before reporting.\n- This proves the bug is caused by ' .. info.addonNameColor .. ' only.\n- Explain how to reproduce the issue.\n- Include screenshots and error messages.', {0.8, 0.8, 0.8}, 'LEFT')
    block2:SetPoint('TOPLEFT', block1, 'BOTTOMLEFT', 50, -40)

    local block3 = DF.ui.Font(devPanel, 12, '|cffffcc00Do not report:|r\n\n- Addon compatibility issues.', {0.8, 0.8, 0.8}, 'LEFT')
    block3:SetPoint('TOPLEFT', block2, 'BOTTOMLEFT', 0, -30)

    local block4 = DF.ui.Font(devPanel, 12, 'So |cffffcc00update frequently|r or |cffffcc00suffer|r,\n\nGuzruul.', {1, 1, 1}, 'CENTER')
    block4:SetPoint('TOP', block1, 'BOTTOM', 0, -250)
end)
