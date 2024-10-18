-- -----------------------------------------------------------------------------
-- Draconic Evolution Logic Functions
-- -----------------------------------------------------------------------------
-- Imports the Customisation
local Customisation = require("/ReactorMonitoring/Customisation")
-- Imports the Reactor Core Class
local ReactorCore = require("/ReactorMonitoring/ReactorCore")

-- If the reactor has been restarted due to temp, will keep checking until it is cool enough and restart
local temp_restarted = false

-- -----------------------------------------------------------------------------
-- Safeties
-- -----------------------------------------------------------------------------

-- Controls the temperature kill switch
function TemperatureKillSwitch(temp)
    local msg = nil
    local reactor = ReactorCore:GetReactor()

    -- Over the maximum temperature set in the config
    -- If over the max temp and not restarted
    if temp >= Customisation.MAX_TEMP and not temp_restarted then
        reactor.stopReactor()
        temp_restarted = true
        msg = "Reactor has gotten too hot. Powering down..."

        print(msg)

    -- If over the max temp and already restarted, stays off
    elseif temp >= Customisation.MAX_TEMP and temp_restarted then
        msg = "Reactor has failed to cool. Remaining powered down..."
        print(msg)

    -- If temperature is within tolerance and reactor has been restarted, restart the reactor
    elseif (temp <= Customisation.MIN_TEMP - Customisation.TOLERANCE_TEMP) and temp_restarted then
        temp_restarted = false
        msg = "Reactor has cooled. Restarting..."
        print(msg)
        reactor.activateReactor()
    end

    -- Logs Errors and Info
    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "info" and msg ~= nil) then
            LogMessage(msg, "[ERROR]")
    elseif (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info" and msg == nil) then
            LogMessage("Reactor Temperature is healthy", "[INFO]")
    end

    -- If using ender modem, send the message
    if Customisation.USE_ENDER_MODEM and msg ~= nil then
        ReactorCore:SendEnderModemMessage(msg)
        msg = nil
    end

    
end

-- Controls the field generation display
function ShieldKillSwitch(shield, reactorStatus)
    local msg = nil
    local reactor = ReactorCore:GetReactor()

    if shield <= Customisation.KILL_FIELD_PERCENT and reactorStatus == "online" then
        msg = "WARNING: Reactor has too low of a containment field... Stopping the reactor..."
        print(msg)
        reactor.stopReactor()
        reactor.chargeReactor()
           
        -- Rams the input flux gate with tons of energy to try and rescue it 
        local iFluxGate = ReactorCore:GetInputFlux()
        inputfluxgate.setSignalLowFlow(900000)
    elseif shield <= Customisation.MIN_FIELD_PERCENT and reactorStatus == "online" then
        msg = "WARNING: Reactor generation field has hit the warning threshold..."
        print(msg)
    end
    

     -- Logs Errors and Info
    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "info" and msg ~= nil) then
            LogMessage(msg, "[ERROR]")
    elseif (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info" and msg == nil) then
            LogMessage("Reactor Containment is healthy", "[INFO]")
    end

    -- If using ender modem, send the message
    if Customisation.USE_ENDER_MODEM and msg ~= nil then
        ReactorCore:SendEnderModemMessage(msg)
        msg = nil
    end
end

-- Low Fuel Kill Switch
function FuelKillSwitch(fuel)
    local msg = nil
    local reactor = ReactorCore:GetReactor()

    -- Stop the reactor if fuel reaches the kill threshold
    if fuel <= Customisation.LOW_FUEL_KILL then
        msg = "Fuel has hit the termination value. Stopping the reactor..."
        print(msg)
        reactor.stopReactor()

    -- Warn if fuel is below the low fuel warning threshold
    elseif fuel <= Customisation.LOW_FUEL_WARNING then
        msg = "WARNING: Reactor is running low on fuel..."
        print(msg)
    end

     -- Logs Errors and Info
    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "info" and msg ~= nil) then
            LogMessage(msg, "[ERROR]")
    elseif (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info" and msg == nil) then
            LogMessage("Reactor Fuel is good", "[INFO]")
    end

    -- If using ender modem, send the message
    if Customisation.USE_ENDER_MODEM and msg ~= nil then
        ReactorCore:SendEnderModemMessage(msg)
        msg = nil
    end
end

-- -----------------------------------------------------------------------------
-- Return the Safety Module
-- -----------------------------------------------------------------------------
return {
    TemperatureKillSwitch = TemperatureKillSwitch,
    FuelKillSwitch = FuelKillSwitch,
    ShieldKillSwitch = ShieldKillSwitch
}