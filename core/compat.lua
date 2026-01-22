DRAGONFLIGHT()
-- i will add some more features so i keep this seperated from init lua; for now its just a flag;

local detectList = {'pfQuest'}

local compatFrame = CreateFrame('Frame')
compatFrame:RegisterEvent('ADDON_LOADED')
compatFrame:RegisterEvent('VARIABLES_LOADED')
compatFrame:SetScript('OnEvent', function()
    if event == 'ADDON_LOADED' then
        for _, addon in pairs(detectList) do
            if arg1 == addon then
                DF.others[addon] = true
            end
        end
    end

    if event == 'VARIABLES_LOADED' then
        compatFrame:UnregisterAllEvents()
    end
end)
