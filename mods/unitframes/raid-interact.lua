DRAGONFLIGHT()

local interact = {}

function interact:OnClick(frame)
    if arg1 == 'LeftButton' then
        TargetUnit(frame.unit)
    elseif arg1 == 'RightButton' then
        if frame.unit and string.find(frame.unit, 'raid') then
            local id = string.gsub(frame.unit, 'raid', '')
            local name = UnitName(frame.unit)
            FriendsDropDown.displayMode = 'MENU'
            ---@diagnostic disable-next-line: duplicate-set-field
            FriendsDropDown.initialize = function() UnitPopup_ShowMenu(_G[UIDROPDOWNMENU_OPEN_MENU], 'PARTY', frame.unit, name, id) end
            ToggleDropDownMenu(1, nil, FriendsDropDown, 'cursor')
        end
    end
end

-- expose
DF.setups.interact = interact