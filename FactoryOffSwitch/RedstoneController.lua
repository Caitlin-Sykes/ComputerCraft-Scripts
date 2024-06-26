-- Imports the Customisation
os.loadAPI("/FactoryOffSwitch/Customisation.lua")

-- -----------------------------------------------------------------------------
-- On Logic
-- -----------------------------------------------------------------------------

-- Factory on
function OnFactoryStart()

    -- If resistive heater is enabled
    -- set energy usage to 0
    if (Customisation.RESISTIVE_HEATER) then
        heater = GetHeater()
        heater.setEnergyUsage(0)
    end

    rs.setAnalogOutput(Customisation.REDSTONE_OUTPUT_COMPUTER, 0)
end

-- -----------------------------------------------------------------------------
-- Off Logic
-- -----------------------------------------------------------------------------

-- factory shutdown
function OnFactoryShutdown()
    
    rs.setAnalogOutput(Customisation.REDSTONE_OUTPUT_COMPUTER, 15)

    -- If resistive heater is enabled
        -- set energy usage to 4000
        if (Customisation.RESISTIVE_HEATER) then
            heater = GetHeater()
            heater.setEnergyUsage(4000)
        end
end

-- -----------------------------------------------------------------------------
-- Misc Logic
-- -----------------------------------------------------------------------------

-- Checks whether on or not on boot
function CheckOnOff()
    -- If factory status == running, runs
    if (Customisation.FACTORY_STATUS == "RUNNING") then
        Customisation.FACTORY_STATUS = "RUNNING"
        OnFactoryStart()
    -- Else off.
    else
        Customisation.FACTORY_STATUS = "STOPPED"
        OnFactoryShutdown()
    end
end

-- Get heater
function GetHeater()
    return peripheral.wrap("resistiveHeater_4"); 
end