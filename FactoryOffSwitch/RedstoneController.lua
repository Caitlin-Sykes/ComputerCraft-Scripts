-- -----------------------------------------------------------------------------
-- On Logic
-- -----------------------------------------------------------------------------

-- Factory on
    -- if resisitve heater, turn off
        -- set energy usage to 0
    -- redstone signal off
    
local function OnFactoryStart()

    -- If resistive heater is enabled
    -- set energy usage to 0
    if (RESISTIVE_HEATER) then
        heater.setEnergyUsage(0)
    end
    
    
end
-- -----------------------------------------------------------------------------
-- Off Logic
-- -----------------------------------------------------------------------------


-- factory shutdown
    --   redstone signal on
    --   wait a few seconds
    --   turn on resistive heater if present
        --   set energy usage to 1000

local function OnFactoryShutdown()


end


-- -----------------------------------------------------------------------------
-- Init Stuff
-- -----------------------------------------------------------------------------

-- Constants
RESISTIVE_HEATER = true

-- Gets resistive heater if enabled
if RESISTIVE_HEATER then
    heater = peripheral.wrap("resistiveHeater"); 
end