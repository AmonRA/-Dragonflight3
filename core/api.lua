UNLOCKDRAGONFLIGHT()

local DragonflightAPI = {}

-- addon: Puppeteer
-- reason: needs access to actionbars eventFrame to manage UPDATE_BINDINGS in bulk with other frames
function DragonflightAPI:PuppeteerGetActionbarsEventFrame()
    if DF.setups.actionbars and DF.setups.actionbars.eventFrame then
        return DF.setups.actionbars.eventFrame
    end
end

-- expose
_G.DragonflightAPI = DragonflightAPI
